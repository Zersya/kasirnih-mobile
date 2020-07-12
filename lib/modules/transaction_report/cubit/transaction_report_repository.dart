part of 'transaction_report_cubit.dart';

class TransactionReportRepository {
  final Firestore _firestore = Firestore.instance;

  Future<Stream<List<trx.Transaction>>> loadTransaction(
      TransactionReportState state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(kUserDocIdKey);
    final storeKey = prefs.getString(kDefaultStore);

    final items = await _firestore
        .collection('users')
        .document(userKey)
        .collection('stores')
        .document(storeKey)
        .collection('transactions')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((event) => event.documents
            .map((e) => trx.Transaction.fromMap(e.data))
            .toList());
    return items;
  }
}
