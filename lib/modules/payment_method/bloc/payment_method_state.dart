part of 'payment_method_bloc.dart';

abstract class PaymentMethodState extends Equatable {
  final propss;
  const PaymentMethodState({this.propss});

  @override
  List<Object> get props => propss;
}

class PaymentMethodStateInitial extends PaymentMethodState {
  final int version;
  final List<PaymentMethod> listName;
  
  PaymentMethodStateInitial({this.version = 0, this.listName = const []}) : super(propss: [version, listName]);
}

class PaymentMethodStateSuccess extends PaymentMethodState {
  final int version;
  final List<PaymentMethod> listName;

  PaymentMethodStateSuccess(this.version, this.listName) : super(propss: [version, listName]);
}

class PaymentMethodStateLoading extends PaymentMethodState {
  final int version;
  final List<PaymentMethod> listName;

  PaymentMethodStateLoading(this.version,this.listName) : super(propss: [version, listName]);
}
