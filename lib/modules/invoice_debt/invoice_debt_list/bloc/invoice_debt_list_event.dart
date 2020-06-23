part of 'invoice_debt_list_bloc.dart';

abstract class InvoiceDebtListEvent extends Equatable {
  final propss;
  const InvoiceDebtListEvent({this.propss});

  @override
  List<Object> get props => propss;
}

class InvoiceDebtListLoadInvoice extends InvoiceDebtListEvent {}
