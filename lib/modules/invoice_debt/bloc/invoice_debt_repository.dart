part of 'invoice_debt_bloc.dart';

class InvoiceDebtRepository {
  final Firestore _firestore = Firestore.instance;
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: kStorageBucket);

  Future<List<Supplier>> loadSupplier() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(kUserDocIdKey);

    final doc = await _firestore
        .collection('users')
        .document(userKey)
        .collection('suppliers')
        .getDocuments();

    List<Supplier> list =
        doc.documents.map((e) => Supplier.fromMap(e.data)).toList();
    return list;
  }

  Future<bool> addSupplier(InvoiceDebtAddSupplier event) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(kUserDocIdKey);

    final doc = await _firestore.collection('users').document(userKey);
    final collection = doc.collection('suppliers');

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final Supplier item = Supplier(
      collection.document().documentID,
      event.supplierName,
      createdAt: timestamp,
    );

    await collection.document(item.docId).setData(item.toMap());
    toastSuccess('Sukses menambahkan supplier');
    return true;
  }

  Future<bool> addInvoice(
      InvoiceDebtAddInvoice event, InvoiceDebtState state) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final userKey = prefs.getString(kUserDocIdKey);
      final storeKey = prefs.getString(kDefaultStore);
      final DateTime dueDate = state.props[4];
      final Supplier supplierDocId = state.props[3];
      final imageUrl = await _uploadFile(state.props[2]);

      final doc = await _firestore.collection('users').document(userKey);
      final collection =
          doc.collection('stores').document(storeKey).collection('invoices');
      final docSupplier =
          await doc.collection('suppliers').document(supplierDocId.docId);

      final timestamp = DateTime.now().millisecondsSinceEpoch;

      final invoice = Invoice(
        collection.document().documentID,
        event.invoiceName,
        imageUrl,
        dueDate.millisecondsSinceEpoch,
        event.totalDebt,
        refSupplier: docSupplier.path,
        createdAt: timestamp,
      );

      await collection.document(invoice.docId).setData(invoice.toMap());
      toastSuccess('Sukses menambahkan Tagihan Hutang');
      return true;
    } on SocketException {
      toastError('No Connection');
      return false;
    }
  }

  Future<String> _uploadFile(String path) async {
    if (path == null || path.isEmpty) return '';
    final String uuid = Uuid().v1();
    final File file = await File(path);
    final StorageReference ref =
        _storage.ref().child('images').child('$uuid.png');
    final StorageUploadTask uploadTask = ref.putFile(
      file,
      StorageMetadata(
        contentLanguage: 'en',
        customMetadata: <String, String>{'activity': 'test'},
      ),
    );

    await uploadTask.onComplete;
    return await ref.getDownloadURL();
  }
}
