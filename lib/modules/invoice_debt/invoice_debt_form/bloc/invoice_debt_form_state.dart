part of 'invoice_debt_form_bloc.dart';

abstract class InvoiceDebtFormState extends Equatable {
  final propss;
  const InvoiceDebtFormState({this.propss});

  @override
  List<Object> get props => propss;
}

class InvoiceDebtFormInitial extends InvoiceDebtFormState {
  final int version;
  final List<Supplier> listSupplier;
  final String imagePath;
  final Supplier supplier;
  final DateTime selectedDate;

  InvoiceDebtFormInitial(
      {this.version = 0,
      this.listSupplier = const [],
      this.imagePath,
      this.supplier,
      this.selectedDate})
      : super(
            propss: [version, listSupplier, imagePath, supplier, selectedDate]);
}

class InvoiceDebtFormSuccessSupplier extends InvoiceDebtFormState {
  final int version;
  final List<Supplier> listSupplier;
  final String imagePath;
  final Supplier supplier;
  final DateTime selectedDate;

  InvoiceDebtFormSuccessSupplier(this.version, this.listSupplier, this.imagePath,
      this.supplier, this.selectedDate)
      : super(
            propss: [version, listSupplier, imagePath, supplier, selectedDate]);
}

class InvoiceDebtFormSuccessInvoice extends InvoiceDebtFormState {
  final int version;
  final List<Supplier> listSupplier;
  final String imagePath;
  final Supplier supplier;
  final DateTime selectedDate;

  InvoiceDebtFormSuccessInvoice(this.version, this.listSupplier, this.imagePath,
      this.supplier, this.selectedDate)
      : super(
            propss: [version, listSupplier, imagePath, supplier, selectedDate]);
}

class InvoiceDebtFormLoading extends InvoiceDebtFormState {
  final int version;
  final List<Supplier> listSupplier;
  final String imagePath;
  final Supplier supplier;
  final DateTime selectedDate;

  InvoiceDebtFormLoading(this.version, this.listSupplier, this.imagePath,
      this.supplier, this.selectedDate)
      : super(
            propss: [version, listSupplier, imagePath, supplier, selectedDate]);
}

