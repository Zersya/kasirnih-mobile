part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();
}

class PaymentLoad extends PaymentEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class PaymentChooseMethod extends PaymentEvent {
  final String paymentMethod;

  PaymentChooseMethod(this.paymentMethod);

  @override
  List<Object> get props => throw UnimplementedError();
}

class PaymentSubmit extends PaymentEvent {
  final trx.Transaction transaction;

  PaymentSubmit(this.transaction);

  @override
  List<Object> get props => throw UnimplementedError();
}
