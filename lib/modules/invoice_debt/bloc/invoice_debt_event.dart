part of 'invoice_debt_bloc.dart';

abstract class InvoiceDebtEvent extends Equatable {
  final propss;
  const InvoiceDebtEvent({this.propss});
    @override
  List<Object> get props => propss;

}

class InvoiceDebtAddSupplier extends InvoiceDebtEvent {
  final String supplierName;

  InvoiceDebtAddSupplier(this.supplierName);
}

class InvoiceDebtLoad extends InvoiceDebtEvent {}
