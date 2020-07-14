part of 'transaction_report_cubit.dart';

class TransactionReportRepository {
  final Firestore _firestore = Firestore.instance;

  Future<Stream<List<trx.Transaction>>> loadTransaction(
      List<String> keys) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(kUserDocIdKey);
    final storeKey = prefs.getString(kDefaultStore);

    final items = keys.isNotEmpty
        ? await _firestore
            .collection('users')
            .document(userKey)
            .collection('stores')
            .document(storeKey)
            .collection('transactions')
            .where('payment_method', whereIn: keys)
            .orderBy('created_at', descending: true)
            .snapshots()
            .map((event) => event.documents
                .map((e) => trx.Transaction.fromMap(e.data))
                .toList())
            .asBroadcastStream()
        : await _firestore
            .collection('users')
            .document(userKey)
            .collection('stores')
            .document(storeKey)
            .collection('transactions')
            .orderBy('created_at', descending: true)
            .snapshots()
            .map((event) => event.documents
                .map((e) => trx.Transaction.fromMap(e.data))
                .toList())
            .asBroadcastStream();
    return items;
  }

  Future<Stream<List<PaymentMethod>>> loadListPaymentMethod() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(kUserDocIdKey);
    final storeKey = prefs.getString(kDefaultStore);

    final stream = await _firestore
        .collection('users')
        .document(userKey)
        .collection('stores')
        .document(storeKey)
        .collection('payment_methods')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((event) =>
            event.documents.map((e) => PaymentMethod.fromMap(e.data)).toList());

    return stream;
  }
}
