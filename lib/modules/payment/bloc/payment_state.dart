part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();
}

class PaymentLoading extends PaymentState {
  final int version;
  final Stream<String> streamCodeTrx;
  final String paymentMethod;
  final List<PaymentMethod> listPaymentMethods;

  PaymentLoading(this.version, this.streamCodeTrx, this.paymentMethod,
      this.listPaymentMethods);

  @override
  List<Object> get props =>
      [version, streamCodeTrx, paymentMethod, listPaymentMethods];
}

class PaymentInitial extends PaymentState {
  final int version;
  final Stream<String> streamCodeTrx;
  final String paymentMethod;
  final List<PaymentMethod> listPaymentMethods;

  PaymentInitial(
      {this.version = 0,
      this.streamCodeTrx,
      this.paymentMethod = '',
      this.listPaymentMethods = const []});

  @override
  List<Object> get props =>
      [version, streamCodeTrx, paymentMethod, listPaymentMethods];
}

class PaymentSuccess extends PaymentState {
  final int version;
  final Stream<String> streamCodeTrx;
  final String paymentMethod;
  final List<PaymentMethod> listPaymentMethods;

  PaymentSuccess(this.version, this.streamCodeTrx, this.paymentMethod,
      this.listPaymentMethods);

  @override
  List<Object> get props =>
      [version, streamCodeTrx, paymentMethod, listPaymentMethods];
}

class PaymentFailed extends PaymentState {
  final int version;
  final Stream<String> streamCodeTrx;
  final String paymentMethod;
  final List<PaymentMethod> listPaymentMethods;

  PaymentFailed(this.version, this.streamCodeTrx, this.paymentMethod,
      this.listPaymentMethods);

  @override
  List<Object> get props =>
      [version, streamCodeTrx, paymentMethod, listPaymentMethods];
}
