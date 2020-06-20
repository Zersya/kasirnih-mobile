part of 'store_registration_bloc.dart';

class StoreRegistrationRepository {
  final Firestore _firestore = Firestore.instance;

  Future<bool> registerStore(StoreRegistrationRegister event) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(kUserDocIdKey);

    final doc = await _firestore.collection('users').document(userKey);

    await doc.collection('stores').add(event.store.toMap());
    toastSuccess('Berhasil daftar toko');
    return true;
  }
}
