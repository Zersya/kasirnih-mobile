part of 'invoice_debt_bloc.dart';

abstract class InvoiceDebtState extends Equatable {
  final propss;
  const InvoiceDebtState({this.propss});

  @override
  List<Object> get props => propss;
}

class InvoiceDebtInitial extends InvoiceDebtState {
  final int version;
  final List<Supplier> listSupplier;
  final String imagePath;
  final Supplier supplier;
  final DateTime selectedDate;

  InvoiceDebtInitial({this.version = 0, this.listSupplier = const [], this.imagePath, this.supplier, this.selectedDate})
      : super(propss: [version, listSupplier, imagePath, supplier, selectedDate]);
}

class InvoiceDebtSuccessSupplier extends InvoiceDebtState {
  final int version;
  final List<Supplier> listSupplier;
  final String imagePath;
  final Supplier supplier;
  final DateTime selectedDate;

  InvoiceDebtSuccessSupplier(this.version, this.listSupplier, this.imagePath, this.supplier, this.selectedDate)
      : super(propss: [version, listSupplier, imagePath, supplier, selectedDate]);
}


class InvoiceDebtSuccessInvoice extends InvoiceDebtState {
  final int version;
  final List<Supplier> listSupplier;
  final String imagePath;
  final Supplier supplier;
  final DateTime selectedDate;

  InvoiceDebtSuccessInvoice(this.version, this.listSupplier, this.imagePath, this.supplier, this.selectedDate)
      : super(propss: [version, listSupplier, imagePath, supplier, selectedDate]);
}


class InvoiceDebtLoading extends InvoiceDebtState {
  final int version;
  final List<Supplier> listSupplier;
  final String imagePath;
  final Supplier supplier;
  final DateTime selectedDate;

  InvoiceDebtLoading(this.version, this.listSupplier, this.imagePath, this.supplier, this.selectedDate)
      : super(propss: [version, listSupplier, imagePath, supplier, selectedDate]);
}
