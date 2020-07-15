part of 'credentials_access_cubit.dart';

abstract class CredentialsAccessState extends Equatable {
  const CredentialsAccessState();
}

class CredentialsAccessInitial extends CredentialsAccessState {
  final bool isAddNewItemAllowed;
  final bool isDebtInvoiceAllowed;
  final bool isItemStockAllowed;
  final bool isOwnerAllowed;
  final bool isPosAllowed;
  final bool isTrxReportAllowed;

  CredentialsAccessInitial(
      {this.isDebtInvoiceAllowed = false,
      this.isAddNewItemAllowed = false,
      this.isItemStockAllowed = false,
      this.isPosAllowed = false,
      this.isTrxReportAllowed = false,
      this.isOwnerAllowed = false});

  @override
  List<Object> get props => [
        isAddNewItemAllowed,
        isDebtInvoiceAllowed,
        isItemStockAllowed,
        isOwnerAllowed,
        isPosAllowed,
        isTrxReportAllowed,
      ];
}

class CredentialsAccessLoaded extends CredentialsAccessState {
  final bool isAddNewItemAllowed;
  final bool isDebtInvoiceAllowed;
  final bool isItemStockAllowed;
  final bool isOwnerAllowed;
  final bool isPosAllowed;
  final bool isTrxReportAllowed;

  CredentialsAccessLoaded(
      this.isDebtInvoiceAllowed,
      this.isAddNewItemAllowed,
      this.isItemStockAllowed,
      this.isPosAllowed,
      this.isTrxReportAllowed,
      this.isOwnerAllowed);

  @override
  List<Object> get props => [
        isAddNewItemAllowed,
        isDebtInvoiceAllowed,
        isItemStockAllowed,
        isOwnerAllowed,
        isPosAllowed,
        isTrxReportAllowed,
      ];
}

class CredentialsAccessLoading extends CredentialsAccessState {
 final bool isAddNewItemAllowed;
  final bool isDebtInvoiceAllowed;
  final bool isItemStockAllowed;
  final bool isOwnerAllowed;
  final bool isPosAllowed;
  final bool isTrxReportAllowed;

  CredentialsAccessLoading(
      this.isDebtInvoiceAllowed,
      this.isAddNewItemAllowed,
      this.isItemStockAllowed,
      this.isPosAllowed,
      this.isTrxReportAllowed,
      this.isOwnerAllowed);

  @override
  List<Object> get props => [
        isAddNewItemAllowed,
        isDebtInvoiceAllowed,
        isItemStockAllowed,
        isOwnerAllowed,
        isPosAllowed,
        isTrxReportAllowed,
      ];
}
