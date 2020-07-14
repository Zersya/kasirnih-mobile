part of 'categories_widget_bloc.dart';

class CategoriesWidgetRepository {
  final Firestore _firestore = Firestore.instance;
  final storage = FlutterSecureStorage();

  Future<Stream<List<Category>>> loadCategories(
      CategoriesWidgetLoad event, CategoriesWidgetState state) async {
    final storeKey = await storage.read(key: kDefaultStore);

    final items = await _firestore
        .collection('stores')
        .document(storeKey)
        .collection('categories')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((event) =>
            event.documents.map((e) => Category.fromMap(e.data)).toList()
              ..insert(0, Category('', 'Semua', isSelected: true)));

    return items;
  }
}
