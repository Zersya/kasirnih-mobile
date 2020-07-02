part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();
}

class PaymentLoading extends PaymentState {
  final int version;
  final Stream<String> streamCodeTrx;
  final String paymentMethod;

  PaymentLoading(this.version, this.streamCodeTrx, this.paymentMethod);

  @override
  List<Object> get props => [version, streamCodeTrx, paymentMethod];
}

class PaymentInitial extends PaymentState {
  final int version;
  final Stream<String> streamCodeTrx;
  final String paymentMethod;

  PaymentInitial(
      {this.version = 0, this.streamCodeTrx, this.paymentMethod = ''});

  @override
  List<Object> get props => [version, streamCodeTrx, paymentMethod];
}

class PaymentSuccess extends PaymentState {
  final int version;
  final Stream<String> streamCodeTrx;
  final String paymentMethod;

  PaymentSuccess(this.version, this.streamCodeTrx, this.paymentMethod);

  @override
  List<Object> get props => [version, streamCodeTrx, paymentMethod];
}

class PaymentFailed extends PaymentState {
  final int version;
  final Stream<String> streamCodeTrx;
  final String paymentMethod;

  PaymentFailed(this.version, this.streamCodeTrx, this.paymentMethod);

  @override
  List<Object> get props => [version, streamCodeTrx, paymentMethod];
}
