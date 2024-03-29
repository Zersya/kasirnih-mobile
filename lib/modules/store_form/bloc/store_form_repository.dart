part of 'store_form_bloc.dart';

class StoreFormRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final storage = FlutterSecureStorage();

  Future<Store> loadStore() async {
    final userKey = await storage.read(key: kUserDocIdKey);

    final doc = await _firestore
        .collection('stores')
        .where('store_owner_id', isEqualTo: userKey)
        .get();

    if (doc.docs.isNotEmpty) {
      Store store = Store.fromMap(doc.docs.first.data());
      return store;
    } else {
      return null;
    }
  }

  Future<bool> registerStore(StoreFormRegister event) async {
    final userKey = await storage.read(key: kUserDocIdKey);

    event.store.storeOwnerId = userKey;
    final colStore = await _firestore.collection('stores');
    final docStore = await colStore.add(event.store.toMapRegister());

    final doc = await _firestore.collection('stores').doc(docStore.id);
    final collection = doc.collection('payment_methods');

    final createdAt = DateTime.now().millisecondsSinceEpoch;

    final PaymentMethod item =
        PaymentMethod(collection.doc().id, 'Tunai', createdAt);

    await collection.doc(item.docId).set(item.toMap());

    toastSuccess(tr('store_registration_screen.success_register_store'));
    return true;
  }

  Future<bool> updateStore(StoreFormUpdate event) async {
    final userKey = await storage.read(key: kUserDocIdKey);

    final doc = await _firestore
        .collection('users')
        .doc(userKey)
        .collection('stores')
        .get();
    final ref = doc.docs.first.reference;
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
