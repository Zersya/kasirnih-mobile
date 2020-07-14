part of 'transaction_report_cubit.dart';

abstract class TransactionReportState extends Equatable {
  const TransactionReportState();
}

class TransactionReportInitial extends TransactionReportState {
  final int version;
  final Stream<List<trx.Transaction>> transaction;
  final Stream<List<PaymentMethod>> paymentMethods;

  TransactionReportInitial(
      {this.version = 0, this.transaction, this.paymentMethods});

  @override
  List<Object> get props => [version, transaction, paymentMethods];
}

class TransactionReportLoading extends TransactionReportState {
  final int version;
  final Stream<List<trx.Transaction>> transaction;
  final Stream<List<PaymentMethod>> paymentMethods;

  TransactionReportLoading(this.version, this.transaction, this.paymentMethods);

  @override
  List<Object> get props => [version, transaction, paymentMethods];
}
