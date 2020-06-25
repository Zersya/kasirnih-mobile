part of 'form_stock_bloc.dart';

abstract class FormStockState extends Equatable {
  final propss;
  const FormStockState({this.propss});

  @override
  List<Object> get props => propss;
}

class FormStockInitial extends FormStockState {
  final int version;
  final List<Category> listCategory;
  final String imagePath;
  final int indexCategory;

  FormStockInitial(
      {this.version = 0,
      this.listCategory = const [],
      this.imagePath,
      this.indexCategory})
      : super(propss: [version, listCategory, imagePath, indexCategory]);
}

class FormStockLoading extends FormStockState {
  final int version;
  final List<Category> listCategory;
  final String imagePath;
  final int indexCategory;

  FormStockLoading(
      this.version, this.listCategory, this.imagePath, this.indexCategory)
      : super(propss: [version, listCategory, imagePath, indexCategory]);
}

class FormStockSuccessItem extends FormStockState {
  final int version;
  final List<Category> listCategory;
  final String imagePath;
  final int indexCategory;

  FormStockSuccessItem(
      this.version, this.listCategory, this.imagePath, this.indexCategory)
      : super(propss: [version, listCategory, imagePath, indexCategory]);
}

class FormStockSuccessCategory extends FormStockState {
  final int version;
  final List<Category> listCategory;
  final String imagePath;
  final int indexCategory;

  FormStockSuccessCategory(
      this.version, this.listCategory, this.imagePath, this.indexCategory)
      : super(propss: [version, listCategory, imagePath, indexCategory]);
}
