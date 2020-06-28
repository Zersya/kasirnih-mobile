part of 'dashboard_bloc.dart';

class DashboardRepository {
  final Firestore _firestore = Firestore.instance;

  Future<bool> isHasStore() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(kUserDocIdKey);

    final collection = await _firestore
        .collection('users')
        .document(userKey)
        .collection('stores');

    final docs = await collection.getDocuments();
    final isHasStore = docs.documents.isNotEmpty;
    if (isHasStore) {
      await prefs.setString(kDefaultStore, docs.documents.first.documentID);
    }
    return isHasStore;
  }

  Future<Stream<List<Category>>> loadCategories(
      DashboardLoadStore event, DashboardState state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(kUserDocIdKey);

    final items = await _firestore
        .collection('users')
        .document(userKey)
        .collection('categories')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((event) =>
            event.documents.map((e) => Category.fromMap(e.data)).toList());

    return items;
  }

  Future<Stream<List<Item>>> loadItems(
      DashboardLoadStore event, DashboardState state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(kUserDocIdKey);
    final storeKey = prefs.getString(kDefaultStore);

    final doc = await _firestore.collection('users').document(userKey);
    final items = doc
        .collection('stores')
        .document(storeKey)
        .collection('items')
        .snapshots()
        .map((event) =>
            event.documents.map((e) => Item.fromMap(e.data)).toList());

    return items;
  }
}
