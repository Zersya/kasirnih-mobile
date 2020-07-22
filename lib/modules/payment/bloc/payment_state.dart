part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();
}

class PaymentLoading extends PaymentState {
  final int version;
  final Stream<String> streamCodeTrx;
  final String paymentMethod;
  final List<PaymentMethod> listPaymentMethods;
  final trx.Transaction transaction;

  PaymentLoading(this.version, this.streamCodeTrx, this.paymentMethod,
      this.listPaymentMethods, this.transaction);

  @override
  List<Object> get props =>
      [version, streamCodeTrx, paymentMethod, listPaymentMethods, transaction];
}

class PaymentInitial extends PaymentState {
  final int version;
  final Stream<String> streamCodeTrx;
  final String paymentMethod;
  final List<PaymentMethod> listPaymentMethods;
  final trx.Transaction transaction;

  PaymentInitial(
      {this.version = 0,
      this.streamCodeTrx,
      this.paymentMethod = '',
      this.listPaymentMethods = const [],
      this.transaction});

  @override
  List<Object> get props =>
      [version, streamCodeTrx, paymentMethod, listPaymentMethods, transaction];
}

class PaymentSuccess extends PaymentState {
  final int version;
  final Stream<String> streamCodeTrx;
  final String paymentMethod;
  final List<PaymentMethod> listPaymentMethods;
  final trx.Transaction transaction;

  PaymentSuccess(this.version, this.streamCodeTrx, this.paymentMethod,
      this.listPaymentMethods, this.transaction);

  @override
  List<Object> get props =>
      [version, streamCodeTrx, paymentMethod, listPaymentMethods, transaction];
}

class PaymentFailed extends PaymentState {
  final int version;
  final Stream<String> streamCodeTrx;
  final String paymentMethod;
  final List<PaymentMethod> listPaymentMethods;
  final trx.Transaction transaction;

  PaymentFailed(this.version, this.streamCodeTrx, this.paymentMethod,
      this.listPaymentMethods, this.transaction);

  @override
  List<Object> get props =>
      [version, streamCodeTrx, paymentMethod, listPaymentMethods, transaction];
}
