part of 'categories_widget_bloc.dart';

class CategoriesWidgetRepository {
  final Firestore _firestore = Firestore.instance;

  Future<Stream<List<Category>>> loadCategories(
      CategoriesWidgetLoad event, CategoriesWidgetState state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(kUserDocIdKey);

    final items = await _firestore
        .collection('users')
        .document(userKey)
        .collection('categories')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((event) =>
            event.documents.map((e) => Category.fromMap(e.data)).toList()
              ..insert(0, Category('', 'Semua', isSelected: true)));

    return items;
  }
}
