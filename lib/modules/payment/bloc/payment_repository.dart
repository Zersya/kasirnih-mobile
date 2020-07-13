part of 'payment_bloc.dart';

class PaymentRepository {
  final Firestore _firestore = Firestore.instance;

  Future<List<PaymentMethod>> loadListPaymentMethod() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userKey = prefs.getString(kUserDocIdKey);
    final storeKey = prefs.getString(kDefaultStore);

    final doc = await _firestore
        .collection('users')
        .document(userKey)
        .collection('stores')
        .document(storeKey)
        .collection('payment_methods')
        .orderBy('created_at', descending: true)
        .getDocuments();

    List<PaymentMethod> listName =
        doc.documents.map((e) => PaymentMethod.fromMap(e.data)).toList();
    listName.add(PaymentMethod.addInitial());
    return listName;
  }

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
        doc.collection('stores').document(storeKey).collection('transactions');

    final trx.Transaction transaction =
        event.transaction.copyWith(docId: collection.document().documentID);

    await collection.document(transaction.docId).setData(transaction.toMap());

    final codeTrx = event.transaction.code;
    final codeIdTrx = int.parse(codeTrx.substring(5)) + 1;
    final newCodeTrx = '#TRX-$codeIdTrx';

    await _firestore.runTransaction((transaction) async {
      final snapStore = await transaction
          .get(doc.collection('stores').document(storeKey))
          .catchError((err) => throw err);

      event.transaction.items.forEach((element) async {
        final snapItem = await transaction
            .get(doc
                .collection('stores')
                .document(storeKey)
                .collection('items')
                .document(element.docId))
            .catchError((err) => throw err);
        final decrement = FieldValue.increment(-element.qty);
        await transaction
            .update(snapItem.reference, {'total_stock': decrement});
      });

      await transaction
          .update(snapStore.reference, {'latest_transaction_code': newCodeTrx});
    }).catchError((err) {
      toastError(err.message);
      return false;
    });
    toastSuccess('Sukses menambahkan transaksi');
    return true;
  }
}
