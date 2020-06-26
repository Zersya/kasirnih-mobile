part of 'list_stock_bloc.dart';

class ListStockRepository {
  final Firestore _firestore = Firestore.instance;

  Future<Stream<List<Item>>> loadStock(ListStockLoad event, ListStockState state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(kUserDocIdKey);
    final storeKey = prefs.getString(kDefaultStore);

    final doc = await _firestore.collection('users').document(userKey);
    final items = doc
        .collection('stores')
        .document(storeKey)
        .collection('items')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((event) =>
            event.documents.map((e) => Item.fromMap(e.data)).toList());

    return items;
  }
}
