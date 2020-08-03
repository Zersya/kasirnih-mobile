part of 'payment_bloc.dart';

class PaymentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final storage = FlutterSecureStorage();

  Future<List<PaymentMethod>> loadListPaymentMethod() async {
    final storeKey = await storage.read(key: kDefaultStore);

    final doc = await _firestore
        .collection('stores')
        .doc(storeKey)
        .collection('payment_methods')
        .orderBy('created_at', descending: true)
        .get();

    List<PaymentMethod> listName =
        doc.docs.map((e) => PaymentMethod.fromMap(e.data())).toList();
    return listName;
  }

  Future<Stream<String>> loadTrx() async {
    final storeKey = await storage.read(key: kDefaultStore);

    final snap = await _firestore
        .collection('stores')
        .doc(storeKey)
        .snapshots()
        .map<String>((event) => event.data()['latest_transaction_code']);

    return snap;
  }

  Future<trx.Transaction> addTransaction(PaymentSubmit event) async {
    final storeKey = await storage.read(key: kDefaultStore);
    final cashier = await storage.read(key: kUsername);

    final trxCollection = _firestore
        .collection('stores')
        .doc(storeKey)
        .collection('transactions');

    final trx.Transaction trxItem = event.transaction
        .copyWith(docId: trxCollection.doc().id, cashier: cashier);

    final codeTrx = event.transaction.code;
    final codeIdTrx = int.parse(codeTrx.substring(5)) + 1;
    final newCodeTrx = '#TRX-$codeIdTrx';

    return await _firestore.runTransaction((transaction) async {
      final snapStore = await transaction
          .get(_firestore.collection('stores').doc(storeKey))
          .catchError((err) => throw err);

      final snapTrx = await transaction
          .get(trxCollection.doc(trxItem.docId))
          .catchError((err) => throw err);

      event.transaction.items.forEach((element) async {
        final snapItem = await transaction
            .get(_firestore
                .collection('stores')
                .doc(storeKey)
                .collection('items')
                .doc(element.docId))
            .catchError((err) => throw err);
        final decrement = FieldValue.increment(-element.qty);
        await transaction
            .update(snapItem.reference, {'total_stock': decrement});
      });

      final currentTotal = snapStore.data()['total_transaction'] ?? 0;
      await transaction.update(snapStore.reference,
          {'total_transaction': currentTotal + trxItem.total});
      await transaction.set(snapTrx.reference, trxItem.toMap());
      await transaction
          .update(snapStore.reference, {'latest_transaction_code': newCodeTrx});
      toastSuccess('Sukses menambahkan transaksi');
      return trxItem;
    }).catchError((err) {
      toastError(err.message);
      return null;
    });
  }
}
