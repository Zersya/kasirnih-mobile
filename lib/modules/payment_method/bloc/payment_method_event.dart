part of 'payment_method_bloc.dart';

abstract class PaymentMethodEvent extends Equatable {
  final propss;
  const PaymentMethodEvent({this.propss});

  @override
  List<Object> get props => this.propss;
}

class PaymentMethodAdd extends PaymentMethodEvent {
  final String itemName;

  PaymentMethodAdd(this.itemName);
}

class PaymentMethodLoad extends PaymentMethodEvent {}
