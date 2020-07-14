part of 'dashboard_bloc.dart';

class DashboardRepository {
  final Firestore _firestore = Firestore.instance;

  Future<bool> isHasStore() async {
    final storage = FlutterSecureStorage();
    final userKey = await storage.read(key: kUserDocIdKey);

    final collection = await _firestore
        .collection('users')
        .document(userKey)
        .collection('stores');

    final docs = await collection.getDocuments();
    final isHasStore = docs.documents.isNotEmpty;
    if (isHasStore) {
      await storage.write(
          key: kDefaultStore, value: docs.documents.first.documentID);
    }
    return isHasStore;
  }
}
