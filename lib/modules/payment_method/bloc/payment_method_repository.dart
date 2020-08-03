part of 'payment_method_bloc.dart';

class PaymentMethodRepository {
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

  Future<bool> addPaymentMethod(PaymentMethodAdd event) async {
    final storeKey = await storage.read(key: kDefaultStore);

    final doc = await _firestore.collection('stores').doc(storeKey);
    final collection = doc.collection('payment_methods');

    final createdAt = DateTime.now().millisecondsSinceEpoch;

    final PaymentMethod item =
        PaymentMethod(collection.doc().id, event.itemName, createdAt);

    await collection.doc(item.docId).set(item.toMap());
    toastSuccess(tr('payment_method_screen.success_add_payment_method'));
    return true;
  }
}
