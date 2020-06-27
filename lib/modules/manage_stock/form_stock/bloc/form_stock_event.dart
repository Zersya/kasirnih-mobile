part of 'form_stock_bloc.dart';

abstract class FormStockEvent extends Equatable {
  final propss;
  const FormStockEvent({this.propss});

  @override
  List<Object> get props => propss;
}

class FormStockLoadCategory extends FormStockEvent {}

class FormStockChooseCategory extends FormStockEvent {
  final int indexCategory;

  FormStockChooseCategory(this.indexCategory);
}

class FormStockAddCategory extends FormStockEvent {
  final String categoryName;

  FormStockAddCategory(this.categoryName);
}


class FormStockLoadSupplier extends FormStockEvent {}

class FormStockChooseSupplier extends FormStockEvent {
  final int indexSupplier;

  FormStockChooseSupplier(this.indexSupplier);
}

class FormStockAddSupplier extends FormStockEvent {
  final String supplierName;

  FormStockAddSupplier(this.supplierName);
}

class FormStockAddItem extends FormStockEvent {
  final String itemName;
  final int totalStock;
  final int buyPrice;
  final int sellPrice;

  FormStockAddItem(
      this.itemName, this.totalStock, this.buyPrice, this.sellPrice);
}

class FormStockGetImage extends FormStockEvent {
  final String imagePath;

  FormStockGetImage(this.imagePath);
}
