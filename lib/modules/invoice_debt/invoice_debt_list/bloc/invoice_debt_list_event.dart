part of 'invoice_debt_list_bloc.dart';

abstract class InvoiceDebtListEvent extends Equatable {
  final propss;
  const InvoiceDebtListEvent({this.propss});

  @override
  List<Object> get props => propss;
}

class InvoiceDebtListLoadInvoice extends InvoiceDebtListEvent {}

class InvoiceDebtListUpdateHasPaid extends InvoiceDebtListEvent {
  final String docId;
  final int totalDebt;
  final bool isPaid;

  InvoiceDebtListUpdateHasPaid(this.docId, this.isPaid, this.totalDebt);
}