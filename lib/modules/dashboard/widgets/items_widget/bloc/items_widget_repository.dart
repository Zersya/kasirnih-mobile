part of 'items_widget_bloc.dart';

class ItemsWidgetRepository {
  final Firestore _firestore = Firestore.instance;

  Future<Stream<List<Item>>> loadItems(
      ItemsWidgetLoad event, ItemsWidgetState state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(kUserDocIdKey);
    final storeKey = prefs.getString(kDefaultStore);

    final doc = await _firestore.collection('users').document(userKey);
    Stream<List<Item>> items;
    final List<String> names = event.categories
        .map((e) => e.name)
        .toList();
    if (names.isEmpty) {
      items = doc
          .collection('stores')
          .document(storeKey)
          .collection('items')
          .snapshots()
          .map((event) =>
              event.documents.map((e) => Item.fromMap(e.data)).toList());
    } else {
      items = doc
          .collection('stores')
          .document(storeKey)
          .collection('items')
          .where('category_name', whereIn: names)
          .snapshots()
          .map((event) =>
              event.documents.map((e) => Item.fromMap(e.data)).toList());
    }
    return items;
  }
}
