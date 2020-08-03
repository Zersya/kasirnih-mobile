part of 'invoice_debt_list_bloc.dart';

class InvoiceDebtListRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final storage = FlutterSecureStorage();

  Future<List<Invoice>> loadInvoices() async {
    final storeKey = await storage.read(key: kDefaultStore);

    final invoicesDoc = await _firestore
        .collection('stores')
        .doc(storeKey)
        .collection('invoices_debt')
        // .where('is_paid', isEqualTo: false)
        .get();

    List<Invoice> list =
        invoicesDoc.docs.map((e) => Invoice.fromMap(e.data())).toList();
    return list;
  }

  Future<int> loadTotal() async {
    final storeKey = await storage.read(key: kDefaultStore);

    final storeDoc = await _firestore.collection('stores').doc(storeKey).get();

    final total = storeDoc.data()['total_invoice_debt'] ?? 0;

    return total;
  }

  Future<bool> updateHasPaidInvoice(
      InvoiceDebtListUpdateHasPaid event, InvoiceDebtListState state) async {
    try {
      final storeKey = await storage.read(key: kDefaultStore);

      final stores = await _firestore.collection('stores');
      final invoices = await stores.doc(storeKey).collection('invoices_debt');

      try {
        await _firestore.runTransaction((transaction) async {
          final refStore = stores.doc(storeKey);
          final refInvoice = invoices.doc(event.docId);

          final freshsnapStore =
              await transaction.get(refStore).catchError((err) => throw err);
          final freshsnapInvoice =
              await transaction.get(refInvoice).catchError((err) => throw err);

          final currentTotal = freshsnapStore.data()['total_invoice_debt'] ?? 0;

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
