part of 'invoice_debt_form_bloc.dart';

abstract class InvoiceDebtFormEvent extends Equatable {
  final propss;
  const InvoiceDebtFormEvent({this.propss});
  @override
  List<Object> get props => propss;
}

class InvoiceDebtFormLoadSupplier extends InvoiceDebtFormEvent {}


class InvoiceDebtFormAddSupplier extends InvoiceDebtFormEvent {
  final String supplierName;

  InvoiceDebtFormAddSupplier(this.supplierName);
}

class InvoiceDebtFormAddInvoice extends InvoiceDebtFormEvent {
  final String invoiceName;
  final int totalDebt;

  InvoiceDebtFormAddInvoice(this.invoiceName, this.totalDebt);
}

class InvoiceDebtFormChooseSupplier extends InvoiceDebtFormEvent {
  final Supplier supplier;

  InvoiceDebtFormChooseSupplier(this.supplier);
}

class InvoiceDebtFormChooseDate extends InvoiceDebtFormEvent {
  final DateTime dateTime;

  InvoiceDebtFormChooseDate(this.dateTime);
}

class InvoiceDebtFormGetImage extends InvoiceDebtFormEvent {
  final String imagePath;

  InvoiceDebtFormGetImage(this.imagePath);
}
