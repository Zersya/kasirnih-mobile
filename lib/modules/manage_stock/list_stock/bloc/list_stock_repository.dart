part of 'list_stock_bloc.dart';

class ListStockRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final storage = FlutterSecureStorage();

  Future<Stream<List<Item>>> loadStock(
      ListStockLoad event, ListStockState state) async {
    final storeKey = await storage.read(key: kDefaultStore);

    final dt =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    switch (event.indexScreen) {
      case 0:
        final items = _firestore
            .collection('stores')
            .doc(storeKey)
            .collection('items')
            .where('total_stock', isGreaterThan: 0)
            .snapshots()
            .map((event) =>
                event.docs.map((e) => Item.fromMap(e.data())).toList());

        return items;
      case 1:
        final qs = await _firestore
            .collection('stores')
            .doc(storeKey)
            .collection('transactions')
            .where('created_at',
                isGreaterThanOrEqualTo: dt.millisecondsSinceEpoch)
            .get();
        final List<trx.Transaction> transactions =
            qs.docs.map((e) => trx.Transaction.fromMap(e.data())).toList();

        final List<Item> items = transactions
            .map((e) => e.items)
            .toList()
            .expand((element) => element)
            .toList();

        final List<Item> newItems = [];
        items.forEach((element) {
          final newElement = newItems
              .singleWhere((e) => e.docId == element.docId, orElse: () => null);
          if (newElement == null) {
            element.soldToday++;
            newItems.add(element);
          } else {
            newElement.soldToday++;
          }
          return;
        });

        return Stream.value(newItems).asBroadcastStream();
      case 2:
        final items = _firestore
            .collection('stores')
            .doc(storeKey)
            .collection('items')
            .where('total_stock', isEqualTo: 0)
            .snapshots()
            .map((event) =>
                event.docs.map((e) => Item.fromMap(e.data())).toList());

        return items;
      default:
        return null;
    }
  }

  Future<Stream<List<Item>>> searchStock(
      ListStockSearch event, ListStockState state) async {
    final storeKey = await storage.read(key: kDefaultStore);

    final items = _firestore
        .collection('stores')
        .doc(storeKey)
        .collection('items')
        .where('item_name',
            isGreaterThanOrEqualTo: event.name,
            isLessThanOrEqualTo: '${event.name}~')
        .snapshots()
        .map((event) => event.docs.map((e) => Item.fromMap(e.data())).toList());

    return items;
  }

  Future<bool> deleteItem(ListStockDelete event) async {
    final storeKey = await storage.read(key: kDefaultStore);

    final doc = await _firestore.collection('stores').doc(storeKey);
    await doc.collection('items').doc(event.docId).delete();

    toastSuccess('Sukses menghapus item');
    return true;
  }
}
