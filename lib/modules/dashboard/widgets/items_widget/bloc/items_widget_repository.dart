part of 'items_widget_bloc.dart';

class ItemsWidgetRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final storage = FlutterSecureStorage();

  Future<Stream<List<Item>>> loadItems(
      ItemsWidgetLoad event, ItemsWidgetState state) async {
    final storeKey = await storage.read(key: kDefaultStore);

    Stream<List<Item>> items;
    final List<String> names = event.categories.map((e) => e.name).toList();
    if (names.isEmpty) {
      items = _firestore
          .collection('stores')
          .doc(storeKey)
          .collection('items')
          .orderBy('created_at', descending: true)
          .snapshots()
          .map((event) => event.docs.map((e) => Item.fromMap(e.data())).toList());
    } else {
      items = _firestore
          .collection('stores')
          .doc(storeKey)
          .collection('items')
          .where('category_name', whereIn: names)
          .orderBy('created_at', descending: true)
          .snapshots()
          .map((event) => event.docs.map((e) => Item.fromMap(e.data())).toList());
    }
    return items;
  }

  Future<Stream<List<Item>>> searchItem(
      ItemsWidgetSearch event, ItemsWidgetState state) async {
    final storeKey = await storage.read(key: kDefaultStore);

    final items = _firestore
        .collection('stores')
        .doc(storeKey)
        .collection('items')
        .where('item_name',
            isGreaterThanOrEqualTo: event.name,
            isLessThanOrEqualTo: '${event.name}~')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) => Item.fromMap(e.data())).toList());

    return items;
  }
}
