part of 'cashes_form_cubit.dart';

class CashesFormRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final storage = FlutterSecureStorage();

  Future<bool> addCashes(String name, int type, int total) async {
    try {
      final storeKey = await storage.read(key: kDefaultStore);

      final doc = _firestore.collection('stores').doc(storeKey);
      final collection = doc.collection('cashes');

      final createdAt = DateTime.now().millisecondsSinceEpoch;

      final Cashes item =
          Cashes(collection.doc().id, name, type, total, createdAt);

      await collection.doc(item.docId).set(item.toMap());
      toastSuccess('Berhasil menambahkan');
      return true;
    } on FirebaseException catch (e) {
      toastError(e.message);
      return false;
    }
  }
}
