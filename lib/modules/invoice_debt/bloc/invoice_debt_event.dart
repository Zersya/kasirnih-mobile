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

class InvoiceDebtAddInvoice extends InvoiceDebtEvent {
  final String invoiceName;
  final int totalDebt;

  InvoiceDebtAddInvoice(this.invoiceName,  this.totalDebt);
}

class InvoiceDebtLoad extends InvoiceDebtEvent {}

class InvoiceDebtChooseSupplier extends InvoiceDebtEvent {
  final Supplier supplier;

  InvoiceDebtChooseSupplier(this.supplier);
}

class InvoiceDebtChooseDate extends InvoiceDebtEvent {
  final DateTime dateTime;

  InvoiceDebtChooseDate(this.dateTime);
}

class InvoiceDebtGetImage extends InvoiceDebtEvent {
  final String imagePath;

  InvoiceDebtGetImage(this.imagePath);
}
