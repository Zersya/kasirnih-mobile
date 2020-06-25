part of 'form_stock_bloc.dart';

class FormStockRepository {
  final Firestore _firestore = Firestore.instance;
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: kStorageBucket);

  Future<List<Category>> loadCategory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(kUserDocIdKey);

    final doc = await _firestore
        .collection('users')
        .document(userKey)
        .collection('categories')
        .orderBy('created_at', descending: true)
        .getDocuments();

    List<Category> list =
        doc.documents.map((e) => Category.fromMap(e.data)).toList();
    return list;
  }

  Future<bool> addCategory(FormStockAddCategory event) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(kUserDocIdKey);

    final doc = await _firestore.collection('users').document(userKey);
    final collection = doc.collection('categories');

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final Category item = Category(
      collection.document().documentID,
      event.categoryName,
      createdAt: timestamp,
    );

    await collection.document(item.docId).setData(item.toMap());
    toastSuccess('Sukses menambahkan category');
    return true;
  }

  Future<bool> addItem(FormStockAddItem event, FormStockState state) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final userKey = prefs.getString(kUserDocIdKey);
      final storeKey = prefs.getString(kDefaultStore);
      final List<Category> categories = state.props[1];
      final Category supplierDocId = categories[state.props[3]];
      final imageUrl = await _uploadFile(state.props[2]);

      final doc = await _firestore.collection('users').document(userKey);
      final collection =
          doc.collection('stores').document(storeKey).collection('items');
      final docCategory =
          await doc.collection('suppliers').document(supplierDocId.docId);

      final createdAt = DateTime.now().millisecondsSinceEpoch;

      final invoice = Item(
          collection.document().documentID,
          event.itemName,
          imageUrl,
          event.totalStock,
          event.buyPrice,
          event.sellPrice,
          createdAt,
          docCategory.path);

      await collection.document(invoice.docId).setData(invoice.toMap());
      toastSuccess('Sukses menambahkan barang');
      return true;
    } on SocketException {
      toastError(tr('error.no_connection'));
      return false;
    }
  }

  Future<String> _uploadFile(String path) async {
    if (path == null || path.isEmpty) return '';
    final String uuid = Uuid().v1();
    final File file = await File(path);
    final StorageReference ref =
        _storage.ref().child('images').child('items').child('$uuid.png');
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