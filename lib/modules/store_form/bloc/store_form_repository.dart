part of 'store_form_bloc.dart';

class StoreFormRepository {
  final Firestore _firestore = Firestore.instance;
  final storage = FlutterSecureStorage();

  Future<Store> loadStore() async {
    final userKey = await storage.read(key: kUserDocIdKey);

    final doc = await _firestore
        .collection('stores')
        .where('store_owner_id', isEqualTo: userKey)
        .getDocuments();

    if (doc.documents.isNotEmpty) {
      Store store = Store.fromMap(doc.documents.first.data);
      return store;
    } else {
      return null;
    }
  }

  Future<bool> registerStore(StoreFormRegister event) async {
    final userKey = await storage.read(key: kUserDocIdKey);

    event.store.storeOwnerId = userKey;
    await _firestore.collection('stores').add(event.store.toMapRegister());
    toastSuccess(tr('store_registration_screen.success_register_store'));
    return true;
  }

  Future<bool> updateStore(StoreFormUpdate event) async {
    final userKey = await storage.read(key: kUserDocIdKey);

    final doc = await _firestore
        .collection('users')
        .document(userKey)
        .collection('stores')
        .getDocuments();
    final ref = doc.documents.first.reference;
    final result = await _firestore.runTransaction((transaction) async {
      final freshsnap =
          await transaction.get(ref).catchError((err) => throw err);
      await transaction.update(freshsnap.reference, event.store.toMap());
    }).catchError((err) {
      toastError(err.message);
      return null;
    });

    if (result != null) {
      toastSuccess(tr('store_registration_screen.success_update_store'));
      return true;
    } else {
      return false;
    }
  }
}
