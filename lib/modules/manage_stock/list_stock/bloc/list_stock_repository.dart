part of 'list_stock_bloc.dart';

class ListStockRepository {
  final Firestore _firestore = Firestore.instance;

  Future<Stream<List<Item>>> loadStock(
      ListStockLoad event, ListStockState state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(kUserDocIdKey);
    final storeKey = prefs.getString(kDefaultStore);

    final doc = await _firestore.collection('users').document(userKey);
    final dt =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    switch (event.indexScreen) {
      case 0:
        final items = doc
            .collection('stores')
            .document(storeKey)
            .collection('items')
            .where('total_stock', isGreaterThan: 0)
            .snapshots()
            .map((event) =>
                event.documents.map((e) => Item.fromMap(e.data)).toList());

        return items;
      case 1:
        final qs = await doc
            .collection('stores')
            .document(storeKey)
            .collection('transactions')
            .where('created_at',
                isGreaterThanOrEqualTo: dt.millisecondsSinceEpoch)
            .getDocuments();
        final List<trx.Transaction> transactions =
            qs.documents.map((e) => trx.Transaction.fromMap(e.data)).toList();

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
        final items = doc
            .collection('stores')
            .document(storeKey)
            .collection('items')
            .where('total_stock', isEqualTo: 0)
            .snapshots()
            .map((event) =>
                event.documents.map((e) => Item.fromMap(e.data)).toList());

        return items;
      default:
        return null;
    }
  }

  Future<Stream<List<Item>>> searchStock(
      ListStockSearch event, ListStockState state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(kUserDocIdKey);
    final storeKey = prefs.getString(kDefaultStore);

    final doc = await _firestore.collection('users').document(userKey);
    final items = doc
        .collection('stores')
        .document(storeKey)
        .collection('items')
        .where('item_name',
            isGreaterThanOrEqualTo: event.name,
            isLessThanOrEqualTo: '${event.name}~')
        .snapshots()
        .map((event) =>
            event.documents.map((e) => Item.fromMap(e.data)).toList());

    return items;
  }
}
