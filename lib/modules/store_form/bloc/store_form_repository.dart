part of 'store_form_bloc.dart';

class StoreFormRepository {
  final Firestore _firestore = Firestore.instance;

  Future<Store> loadStore() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(kUserDocIdKey);

    final doc = await _firestore
        .collection('users')
        .document(userKey)
        .collection('stores')
        .getDocuments();

    Store store = Store.fromMap(doc.documents.first.data);

    return store;
  }

  Future<bool> registerStore(StoreFormRegister event) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(kUserDocIdKey);

    final doc = await _firestore.collection('users').document(userKey);

    await doc.collection('stores').add(event.store.toMap());
    toastSuccess(tr('store_registration_screen.success_register_store'));
    return true;
  }

  Future<bool> updateStore(StoreFormUpdate event) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(kUserDocIdKey);

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
