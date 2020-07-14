part of 'transaction_selected_payment_cubit.dart';

abstract class TransactionSelectedPaymentState extends Equatable {
  final propss;
  const TransactionSelectedPaymentState({this.propss});

  int incrementV() {
    int version = propss[0];
    version++;
    return version;
  }

  @override
  List<Object> get props => propss;
}

class TransactionSelectedPaymentInitial
    extends TransactionSelectedPaymentState {
  final int version;
  final List<PaymentMethod> list;

  TransactionSelectedPaymentInitial({this.version = 0, this.list = const []})
      : super(propss: [version, list]);
}
