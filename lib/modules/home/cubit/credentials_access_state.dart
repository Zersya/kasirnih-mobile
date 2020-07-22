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
  final bool isHasStore;

  CredentialsAccessInitial(
      {this.isDebtInvoiceAllowed = false,
      this.isAddNewItemAllowed = false,
      this.isItemStockAllowed = false,
      this.isPosAllowed = false,
      this.isTrxReportAllowed = false,
      this.isOwnerAllowed = false,
      this.isHasStore = false});

  @override
  List<Object> get props => [
        isAddNewItemAllowed,
        isDebtInvoiceAllowed,
        isItemStockAllowed,
        isOwnerAllowed,
        isPosAllowed,
        isTrxReportAllowed,
        isHasStore
      ];
}

class CredentialsAccessLoaded extends CredentialsAccessState {
  final bool isAddNewItemAllowed;
  final bool isDebtInvoiceAllowed;
  final bool isItemStockAllowed;
  final bool isOwnerAllowed;
  final bool isPosAllowed;
  final bool isTrxReportAllowed;
  final bool isHasStore;

  CredentialsAccessLoaded(
      this.isDebtInvoiceAllowed,
      this.isAddNewItemAllowed,
      this.isItemStockAllowed,
      this.isPosAllowed,
      this.isTrxReportAllowed,
      this.isOwnerAllowed,
      this.isHasStore);

  @override
  List<Object> get props => [
        isAddNewItemAllowed,
        isDebtInvoiceAllowed,
        isItemStockAllowed,
        isOwnerAllowed,
        isPosAllowed,
        isTrxReportAllowed,
        isHasStore,
      ];
}

class CredentialsAccessLoading extends CredentialsAccessState {
  final bool isAddNewItemAllowed;
  final bool isDebtInvoiceAllowed;
  final bool isItemStockAllowed;
  final bool isOwnerAllowed;
  final bool isPosAllowed;
  final bool isTrxReportAllowed;
  final bool isHasStore;

  CredentialsAccessLoading(
      this.isDebtInvoiceAllowed,
      this.isAddNewItemAllowed,
      this.isItemStockAllowed,
      this.isPosAllowed,
      this.isTrxReportAllowed,
      this.isOwnerAllowed,
      this.isHasStore);

  @override
  List<Object> get props => [
        isAddNewItemAllowed,
        isDebtInvoiceAllowed,
        isItemStockAllowed,
        isOwnerAllowed,
        isPosAllowed,
        isTrxReportAllowed,
        isHasStore,
      ];
}
