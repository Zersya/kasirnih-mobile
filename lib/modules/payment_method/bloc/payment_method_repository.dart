part of 'payment_method_bloc.dart';

class PaymentMethodRepository {
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

  Future<bool> addPaymentMethod(PaymentMethodAdd event) async {
    final storeKey = await storage.read(key: kDefaultStore);

    final doc = await _firestore
        .collection('stores')
        .document(storeKey);
    final collection = doc.collection('payment_methods');

    final createdAt = DateTime.now().millisecondsSinceEpoch;

    final PaymentMethod item = PaymentMethod(
        collection.document().documentID, event.itemName, createdAt);

    await collection.document(item.docId).setData(item.toMap());
    toastSuccess(tr('payment_method_screen.success_add_payment_method'));
    return true;
  }
}
