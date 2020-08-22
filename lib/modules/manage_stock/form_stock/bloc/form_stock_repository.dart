part of 'form_stock_bloc.dart';

class FormStockRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: kStorageBucket);
  final storage = FlutterSecureStorage();

  Future<List<Category>> loadCategory() async {
    final storeKey = await storage.read(key: kDefaultStore);

    final doc = await _firestore
        .collection('stores')
        .doc(storeKey)
        .collection('categories')
        .orderBy('created_at', descending: true)
        .get();

    List<Category> list =
        doc.docs.map((e) => Category.fromMap(e.data())).toList();
    return list;
  }

  Future<bool> addCategory(FormStockAddCategory event) async {
    final storeKey = await storage.read(key: kDefaultStore);

    final collection = await _firestore
        .collection('stores')
        .doc(storeKey)
        .collection('categories');

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final Category item = Category(
      collection.doc().id,
      event.categoryName,
      createdAt: timestamp,
    );

    await collection.doc(item.docId).set(item.toMap());
    toastSuccess('Sukses menambahkan category');
    return true;
  }

  Future<List<Supplier>> loadSupplier() async {
    final storeKey = await storage.read(key: kDefaultStore);

    final doc = await _firestore
        .collection('stores')
        .doc(storeKey)
        .collection('suppliers')
        .orderBy('created_at', descending: true)
        .get();

    List<Supplier> list =
        doc.docs.map((e) => Supplier.fromMap(e.data())).toList();
    return list;
  }

  Future<bool> addSupplier(FormStockAddSupplier event) async {
    final storeKey = await storage.read(key: kDefaultStore);

    final collection = await _firestore
        .collection('stores')
        .doc(storeKey)
        .collection('suppliers');

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final Supplier item = Supplier(
      collection.doc().id,
      event.supplierName,
      createdAt: timestamp,
    );

    await collection.doc(item.docId).set(item.toMap());
    toastSuccess('Sukses menambahkan supplier');
    return true;
  }

  Future<bool> addItem(FormStockAddItem event, FormStockState state) async {
    try {
      final storeKey = await storage.read(key: kDefaultStore);

      final List<Category> categories = state.props[1];
      final Category category = categories[state.props[3]];
      final List<Supplier> suppliers = state.props[5];
      final Supplier supplier = suppliers[state.props[4]];
      final imageUrl = await _uploadFile(state.props[2]);

      final collection =
          _firestore.collection('stores').doc(storeKey).collection('items');
      final docCategory =
          await _firestore.collection('categories').doc(category.docId);
      final docSupplier =
          await _firestore.collection('suppliers').doc(supplier.docId);

      final createdAt = DateTime.now().millisecondsSinceEpoch;

      final item = Item(
        collection.doc().id,
        event.itemName,
        imageUrl,
        event.totalStock,
        event.buyPrice,
        event.sellPrice,
        createdAt,
        docCategory.path,
        category.name,
        docSupplier.path,
        supplier.name,
      );

      await collection.doc(item.docId).set(item.toMap());
      toastSuccess('Sukses menambahkan barang');
      return true;
    } on SocketException {
      toastError(tr('error.no_connection'));
      return false;
    }
  }

  Future<bool> editItem(FormStockEditItem event, FormStockState state) async {
    try {
      final storeKey = await storage.read(key: kDefaultStore);

      final List<Category> categories = state.props[1];
      final Category category = categories[state.props[3]];
      final List<Supplier> suppliers = state.props[5];
      final Supplier supplier = suppliers[state.props[4]];
      final imageUrl = event.item.urlImage.isEmpty
          ? await _uploadFile(state.props[2])
          : event.item.urlImage;

      final collection =
          _firestore.collection('stores').doc(storeKey).collection('items');
      final docCategory =
          await _firestore.collection('categories').doc(category.docId);
      final docSupplier =
          await _firestore.collection('suppliers').doc(supplier.docId);

      final item = Item(
        event.item.docId,
        event.itemName,
        imageUrl,
        event.totalStock,
        event.buyPrice,
        event.sellPrice,
        event.item.createdAt,
        docCategory.path,
        category.name,
        docSupplier.path,
        supplier.name,
      );

      await collection.doc(item.docId).update(item.toMap());
      toastSuccess('Sukses menambahkan barang');
      return true;
    } on SocketException {
      toastError(tr('error.no_connection'));
      return false;
    } on PlatformException catch (e) {
      toastError(e.message);
      return false;
    }
  }

  Future<String> _uploadFile(String path) async {
    try {
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
    } catch (e) {
      rethrow;
    }
  }
}
