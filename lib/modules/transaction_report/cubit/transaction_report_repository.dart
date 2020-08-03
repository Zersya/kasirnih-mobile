part of 'transaction_report_cubit.dart';

class TransactionReportRepository {
  final Firestore _firestore = Firestore.instance;
  final storage = FlutterSecureStorage();

  Future<Stream<List<trx.Transaction>>> loadTransaction(
      List<String> keys, DateTime start, DateTime end) async {
    final storeKey = await storage.read(key: kDefaultStore);
    final numberLimit = int.parse((await storage.read(key: kLimitData)));

    Query items;

    if (keys.isNotEmpty) {
      items = await _firestore
          .collection('stores')
          .document(storeKey)
          .collection('transactions')
          .where('payment_method', whereIn: keys)
          .orderBy('created_at', descending: true)
          .limit(numberLimit);
    } else {
      items = await _firestore
          .collection('stores')
          .document(storeKey)
          .collection('transactions')
          .orderBy('created_at', descending: true)
          .limit(numberLimit);
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
    final storeKey = await storage.read(key: kDefaultStore);

    final stream = await _firestore
        .collection('stores')
        .document(storeKey)
        .collection('payment_methods')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((event) =>
            event.documents.map((e) => PaymentMethod.fromMap(e.data)).toList());

    return stream;
  }

  Future<bool> requestEmail(DateTime start, DateTime end) async {
    final email = await storage.read(key: kEmail);
    final username = await storage.read(key: kUsername);
    final storeId = await storage.read(key: kDefaultStore);
    final startDate = start.millisecondsSinceEpoch;
    final endDate = end.millisecondsSinceEpoch;

    final rmId = _firestore.collection('statements_mail').document().documentID;
    await _firestore.collection('statements_mail').add({
      'rm_id': rmId,
      'email': email,
      'name': username,
      'store_id': storeId,
      'start_date': startDate,
      'end_date': endDate,
    });
    toastSuccess('Silahkan cek email kamu.');
    return true;
  }
}
