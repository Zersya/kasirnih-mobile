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

  InvoiceDebtInitial({this.version = 0, this.listSupplier = const []})
      : super(propss: [version, listSupplier]);
}

class InvoiceDebtSuccess extends InvoiceDebtState {
  final int version;
  final List<Supplier> listSupplier;

  InvoiceDebtSuccess(this.version, this.listSupplier)
      : super(propss: [version, listSupplier]);
}

class InvoiceDebtLoading extends InvoiceDebtState {
  final int version;
  final List<Supplier> listSupplier;

  InvoiceDebtLoading(this.version, this.listSupplier)
      : super(propss: [version, listSupplier]);
}
