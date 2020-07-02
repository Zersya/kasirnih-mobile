part of 'payment_bloc.dart';

class PaymentRepository {
  final Firestore _firestore = Firestore.instance;

  Future<Stream<String>> loadTrx() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(kUserDocIdKey);
    final storeKey = prefs.getString(kDefaultStore);

    final snap = await _firestore
        .collection('users')
        .document(userKey)
        .collection('stores')
        .document(storeKey)
        .snapshots()
        .map<String>((event) => event.data['latest_transaction_code']);

    return snap;
  }

  Future<bool> addTransaction(PaymentSubmit event) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(kUserDocIdKey);
    final storeKey = prefs.getString(kDefaultStore);

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      toastError(tr('error.no_connection'));
      return false;
    }

    final doc = await _firestore.collection('users').document(userKey);
    final collection =
        doc.collection('stores').document(storeKey).collection('transaction');

    final trx.Transaction transaction =
        event.transaction.copyWith(docId: collection.document().documentID);

    await collection.document(transaction.docId).setData(transaction.toMap());

    final codeTrx = event.transaction.code;
    final codeIdTrx = int.parse(codeTrx.substring(5)) + 1;
    final newCodeTrx = '#TRX-$codeIdTrx';

    await _firestore.runTransaction((transaction) async {
      final freshsnap = await transaction
          .get(doc.collection('stores').document(storeKey))
          .catchError((err) => throw err);
      await transaction
          .update(freshsnap.reference, {'latest_transaction_code': newCodeTrx});
    }).catchError((err) {
      toastError(err.message);
      return false;
    });
    toastSuccess('Sukses menambahkan transaksi');
    return true;
  }
}
