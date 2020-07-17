part of 'dashboard_bloc.dart';

class DashboardRepository {
  final Firestore _firestore = Firestore.instance;

  Future<bool> isHasStore() async {
    final storage = FlutterSecureStorage();
    final userKey = await storage.read(key: kUserDocIdKey);
    final storeKey = await storage.read(key: kDefaultStore);

    if (storeKey != null) return true;

    final docs = await _firestore
        .collection('stores')
        .where('store_owner_id', isEqualTo: userKey)
        .getDocuments();

    final isHasStore = docs.documents.isNotEmpty;
    if (isHasStore) {
      await storage.write(
          key: kDefaultStore, value: docs.documents.first.documentID);
    }
    return isHasStore;
  }
}
