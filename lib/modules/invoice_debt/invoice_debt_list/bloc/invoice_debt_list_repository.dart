part of 'invoice_debt_list_bloc.dart';

class InvoiceDebtListRepository {
  final Firestore _firestore = Firestore.instance;

  Future<List<Invoice>> loadInvoices() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(kUserDocIdKey);
    final storeKey = prefs.getString(kDefaultStore);

    final doc = await _firestore.collection('users').document(userKey);
    final invoicesDoc = await doc
        .collection('stores')
        .document(storeKey)
        .collection('invoices')
        .where('is_paid', isEqualTo: false)
        .getDocuments();

    List<Invoice> list =
        invoicesDoc.documents.map((e) => Invoice.fromMap(e.data)).toList();
    return list;
  }

  Future<int> loadTotal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(kUserDocIdKey);
    final storeKey = prefs.getString(kDefaultStore);

    final doc = await _firestore.collection('users').document(userKey);
    final storeDoc = await doc.collection('stores').document(storeKey).get();

    final total = storeDoc.data['total_invoice_debt'] ?? 0;

    return total;
  }
}
