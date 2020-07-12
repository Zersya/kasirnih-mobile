part of 'transaction_report_cubit.dart';

abstract class TransactionReportState extends Equatable {
  const TransactionReportState();
}

class TransactionReportInitial extends TransactionReportState {
  final int version;
  final Stream<List<trx.Transaction>> transaction;

  TransactionReportInitial({this.version = 0, this.transaction});
  
  @override
  List<Object> get props => [version, transaction];
}
