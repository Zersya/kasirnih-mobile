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

    return docs.documents.isNotEmpty;
  }

}
