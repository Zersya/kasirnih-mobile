part of 'invoice_debt_bloc.dart';

class InvoiceDebtRepository {
  final Firestore _firestore = Firestore.instance;

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
    toastSuccess(
        tr('new_item_facilities_screen.success_add_new_item_facilities'));
    return true;
  }
}
