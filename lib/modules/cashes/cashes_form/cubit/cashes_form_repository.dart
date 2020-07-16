part of 'cashes_form_cubit.dart';

class CashesFormRepository {
  final Firestore _firestore = Firestore.instance;
  final storage = FlutterSecureStorage();

  Future<bool> addCashes(String name, int type, int total) async {
    final storeKey = await storage.read(key: kDefaultStore);

    final doc = await _firestore.collection('stores').document(storeKey);
    final collection = doc.collection('cashes');

    final createdAt = DateTime.now().millisecondsSinceEpoch;

    final Cashes item =
        Cashes(collection.document().documentID, name, type, total, createdAt);

    await collection.document(item.docId).setData(item.toMap());
    toastSuccess('Berhasil menambahkan');
    return true;
  }
}
