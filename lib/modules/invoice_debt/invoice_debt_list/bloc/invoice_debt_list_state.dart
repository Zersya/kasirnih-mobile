part of 'invoice_debt_list_bloc.dart';

abstract class InvoiceDebtListState extends Equatable {
  final propss;
  const InvoiceDebtListState({this.propss});
  @override
  List<Object> get props => propss;
}

class InvoiceDebtListInitial extends InvoiceDebtListState {
  final int version;
  final List<Invoice> listInvoice;
  final int total;

  InvoiceDebtListInitial({this.version = 0, this.listInvoice = const [], this.total = 0}):super(propss: [version, listInvoice, total]);

}

class InvoiceDebtListLoading extends InvoiceDebtListState {
  final int version;
  final List<Invoice> listInvoice;
  final int total;

  InvoiceDebtListLoading(this.version, this.listInvoice, this.total) : super(propss: [version, listInvoice, total]);
}


class InvoiceDebtListSuccessUpdate extends InvoiceDebtListState {
  final int version;
  final List<Invoice> listInvoice;
  final int total;

  InvoiceDebtListSuccessUpdate(this.version, this.listInvoice, this.total) : super(propss: [version, listInvoice, total]);
}
