part of 'transaction_report_cubit.dart';

class TransactionReportRepository {
  final Firestore _firestore = Firestore.instance;
  final storage = FlutterSecureStorage();

  Future<Stream<List<trx.Transaction>>> loadTransaction(
      List<String> keys, DateTime start, DateTime end) async {
    final userKey = await storage.read(key: kUserDocIdKey);
    final storeKey = await storage.read(key: kDefaultStore);

    Query items;

    if (keys.isNotEmpty) {
      items = await _firestore
          .collection('users')
          .document(userKey)
          .collection('stores')
          .document(storeKey)
          .collection('transactions')
          .where('payment_method', whereIn: keys)
          .orderBy('created_at', descending: true);
    } else {
      items = await _firestore
          .collection('users')
          .document(userKey)
          .collection('stores')
          .document(storeKey)
          .collection('transactions')
          .orderBy('created_at', descending: true);
    }

    if (start != null) {
      items = items.where('created_at',
          isGreaterThanOrEqualTo: start.millisecondsSinceEpoch);
    }

    if (end != null) {
      items = items.where('created_at',
          isLessThanOrEqualTo: end.millisecondsSinceEpoch);
    }

    return items
        .snapshots()
        .map((event) => event.documents
            .map((e) => trx.Transaction.fromMap(e.data))
            .toList())
        .asBroadcastStream();
  }

  Future<Stream<List<PaymentMethod>>> loadListPaymentMethod() async {
    final userKey = await storage.read(key: kUserDocIdKey);
    final storeKey = await storage.read(key: kDefaultStore);

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
