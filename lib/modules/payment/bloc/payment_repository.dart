part of 'payment_bloc.dart';

class PaymentRepository {
  final Firestore _firestore = Firestore.instance;
  final storage = FlutterSecureStorage();

  Future<List<PaymentMethod>> loadListPaymentMethod() async {
    final storeKey = await storage.read(key: kDefaultStore);

    final doc = await _firestore
        .collection('stores')
        .document(storeKey)
        .collection('payment_methods')
        .orderBy('created_at', descending: true)
        .getDocuments();

    List<PaymentMethod> listName =
        doc.documents.map((e) => PaymentMethod.fromMap(e.data)).toList();
    return listName;
  }

  Future<Stream<String>> loadTrx() async {
    final storeKey = await storage.read(key: kDefaultStore);

    final snap = await _firestore
        .collection('stores')
        .document(storeKey)
        .snapshots()
        .map<String>((event) => event.data['latest_transaction_code']);

    return snap;
  }

  Future<bool> addTransaction(PaymentSubmit event) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      toastError(tr('error.no_connection'));
      return false;
    }

    final storeKey = await storage.read(key: kDefaultStore);
    final trxCollection = _firestore
        .collection('stores')
        .document(storeKey)
        .collection('transactions');

    final trx.Transaction trxItem =
        event.transaction.copyWith(docId: trxCollection.document().documentID);

    final codeTrx = event.transaction.code;
    final codeIdTrx = int.parse(codeTrx.substring(5)) + 1;
    final newCodeTrx = '#TRX-$codeIdTrx';

    await _firestore.runTransaction((transaction) async {
      final snapStore = await transaction
          .get(_firestore.collection('stores').document(storeKey))
          .catchError((err) => throw err);

      final snapTrx = await transaction
          .get(trxCollection.document(trxItem.docId))
          .catchError((err) => throw err);

      event.transaction.items.forEach((element) async {
        final snapItem = await transaction
            .get(_firestore
                .collection('stores')
                .document(storeKey)
                .collection('items')
                .document(element.docId))
            .catchError((err) => throw err);
        final decrement = FieldValue.increment(-element.qty);
        await transaction
            .update(snapItem.reference, {'total_stock': decrement});
      });

      final currentTotal = snapStore.data['total_transaction'] ?? 0;
      await transaction.update(snapStore.reference,
          {'total_transaction': currentTotal + trxItem.total});
      await transaction.set(snapTrx.reference, trxItem.toMap());
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
