part of 'new_item_facilities_bloc.dart';

class NewItemFacilitiesRepository {
  final Firestore _firestore = Firestore.instance;
  final storage = FlutterSecureStorage();

  Future<List<NewItemFacilities>> loadListNewFacilities() async {
    final userKey = await storage.read(key: kUserDocIdKey);
    final storeKey = await storage.read(key: kDefaultStore);

    final doc = await _firestore
        .collection('users')
        .document(userKey)
        .collection('stores')
        .document(storeKey)
        .collection('new_item_facilities')
        .orderBy('created_at', descending: true)
        .getDocuments();

    List<NewItemFacilities> listName =
        doc.documents.map((e) => NewItemFacilities.fromMap(e.data)).toList();
    return listName;
  }

  Future<bool> addNewFacilities(NewItemFacilitiesAdd event) async {
    final userKey = await storage.read(key: kUserDocIdKey);
    final storeKey = await storage.read(key: kDefaultStore);

    final doc = await _firestore
        .collection('users')
        .document(userKey)
        .collection('stores')
        .document(storeKey);
    final collection = doc.collection('new_item_facilities');

    final createdAt = DateTime.now().millisecondsSinceEpoch;

    final NewItemFacilities item = NewItemFacilities(
        collection.document().documentID, event.itemName, createdAt, false);

    await collection.document(item.docId).setData(item.toMap());
    toastSuccess(
        tr('new_item_facilities_screen.success_add_new_item_facilities'));
    return true;
  }

  Future<bool> updateValue(NewItemFacilitiesChangeValue event) async {
    final userKey = await storage.read(key: kUserDocIdKey);
    final storeKey = await storage.read(key: kDefaultStore);

    final doc = await _firestore
        .collection('users')
        .document(userKey)
        .collection('stores')
        .document(storeKey)
        .collection('new_item_facilities')
        .getDocuments();

    final ref = doc.documents
        .firstWhere((element) => event.item.docId == element.documentID)
        .reference;

    final result = await _firestore.runTransaction((transaction) async {
      final freshsnap =
          await transaction.get(ref).catchError((err) => throw err);
      await transaction.update(freshsnap.reference, event.item.toMap());
    }).catchError((err) {
      toastError(err.message);
      return null;
    });

    if (result != null) {
      return true;
    } else {
      return false;
    }
  }
}
