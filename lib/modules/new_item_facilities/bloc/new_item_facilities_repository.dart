part of 'new_item_facilities_bloc.dart';

class NewItemFacilitiesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final storage = FlutterSecureStorage();

  Future<List<NewItemFacilities>> loadListNewFacilities() async {
    final storeKey = await storage.read(key: kDefaultStore);

    final doc = await _firestore
        .collection('stores')
        .doc(storeKey)
        .collection('new_item_facilities')
        .orderBy('created_at', descending: true)
        .get();

    List<NewItemFacilities> listName =
        doc.docs.map((e) => NewItemFacilities.fromMap(e.data())).toList();
    return listName;
  }

  Future<bool> addNewFacilities(NewItemFacilitiesAdd event) async {
    final storeKey = await storage.read(key: kDefaultStore);

    final doc = await _firestore.collection('stores').doc(storeKey);
    final collection = doc.collection('new_item_facilities');

    final createdAt = DateTime.now().millisecondsSinceEpoch;

    final NewItemFacilities item = NewItemFacilities(
        collection.doc().id, event.itemName, createdAt, false);

    await collection.doc(item.docId).set(item.toMap());
    toastSuccess(
        tr('new_item_facilities_screen.success_add_new_item_facilities'));
    return true;
  }

  Future<bool> updateValue(NewItemFacilitiesChangeValue event) async {
    final storeKey = await storage.read(key: kDefaultStore);

    final doc = await _firestore
        .collection('stores')
        .doc(storeKey)
        .collection('new_item_facilities')
        .get();

    final ref = doc.docs
        .firstWhere((element) => event.item.docId == element.id)
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
