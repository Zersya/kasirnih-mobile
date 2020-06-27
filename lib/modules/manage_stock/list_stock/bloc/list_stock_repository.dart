part of 'list_stock_bloc.dart';

class ListStockRepository {
  final Firestore _firestore = Firestore.instance;

  Future<Stream<List<Item>>> loadStock(
      ListStockLoad event, ListStockState state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(kUserDocIdKey);
    final storeKey = prefs.getString(kDefaultStore);

    final doc = await _firestore.collection('users').document(userKey);
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
        final items = doc
            .collection('stores')
            .document(storeKey)
            .collection('items')
            .where('total_stock', isEqualTo: 0)
            .snapshots()
            .map((event) =>
                event.documents.map((e) => Item.fromMap(e.data)).toList());

        return items;
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
