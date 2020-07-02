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
        .collection('invoices_debt')
        // .where('is_paid', isEqualTo: false)
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

  Future<bool> updateHasPaidInvoice(
      InvoiceDebtListUpdateHasPaid event, InvoiceDebtListState state) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final userKey = prefs.getString(kUserDocIdKey);
      final storeKey = prefs.getString(kDefaultStore);

      final stores = await _firestore
          .collection('users')
          .document(userKey)
          .collection('stores');
      final invoices = await stores.document(storeKey).collection('invoices_debt');

      try {
        await _firestore.runTransaction((transaction) async {
          final refStore = stores.document(storeKey);
          final refInvoice = invoices.document(event.docId);

          final freshsnapStore =
              await transaction.get(refStore).catchError((err) => throw err);
          final freshsnapInvoice =
              await transaction.get(refInvoice).catchError((err) => throw err);

          final currentTotal = freshsnapStore.data['total_invoice_debt'] ?? 0;

          await transaction
              .update(freshsnapInvoice.reference, {'is_paid': event.isPaid});
          await transaction.update(freshsnapStore.reference,
              {'total_invoice_debt': currentTotal - event.totalDebt});
        });

        toastSuccess('Sukses merubah status');
        return true;
      } catch (err) {
        toastError(err.message);
        return null;
      }
    } on SocketException {
      toastError('No Connection');
      return false;
    }
  }
}
