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
  final int indexSupplier;
  final List<Supplier> listSupplier;

  FormStockInitial(
      {this.version = 0,
      this.listCategory = const [],
      this.listSupplier = const [],
      this.imagePath,
      this.indexCategory,
      this.indexSupplier})
      : super(propss: [
          version,
          listCategory,
          imagePath,
          indexCategory,
          indexSupplier,
          listSupplier
        ]);
}

class FormStockLoading extends FormStockState {
  final int version;
  final List<Category> listCategory;
  final String imagePath;
  final int indexCategory;
  final int indexSupplier;
  final List<Supplier> listSupplier;

  FormStockLoading(this.version, this.listCategory, this.imagePath,
      this.indexCategory, this.indexSupplier, this.listSupplier)
      : super(propss: [
          version,
          listCategory,
          imagePath,
          indexCategory,
          indexSupplier,
          listSupplier,
        ]);
}

class FormStockSuccessItem extends FormStockState {
  final int version;
  final List<Category> listCategory;
  final String imagePath;
  final int indexCategory;
  final int indexSupplier;
  final List<Supplier> listSupplier;

  FormStockSuccessItem(this.version, this.listCategory, this.imagePath,
      this.indexCategory, this.indexSupplier, this.listSupplier)
      : super(propss: [
          version,
          listCategory,
          imagePath,
          indexCategory,
          indexSupplier,
          listSupplier
        ]);
}

class FormStockSuccessCategory extends FormStockState {
  final int version;
  final List<Category> listCategory;
  final String imagePath;
  final int indexCategory;
  final int indexSupplier;
  final List<Supplier> listSupplier;

  FormStockSuccessCategory(this.version, this.listCategory, this.imagePath,
      this.indexCategory, this.indexSupplier,this.listSupplier)
      : super(propss: [
          version,
          listCategory,
          imagePath,
          indexCategory,
          indexSupplier,
          listSupplier
        ]);
}


class FormStockSuccessSupplier extends FormStockState {
  final int version;
  final List<Category> listCategory;
  final String imagePath;
  final int indexCategory;
  final int indexSupplier;
  final List<Supplier> listSupplier;

  FormStockSuccessSupplier(this.version, this.listCategory, this.imagePath,
      this.indexCategory, this.indexSupplier,this.listSupplier)
      : super(propss: [
          version,
          listCategory,
          imagePath,
          indexCategory,
          indexSupplier,
          listSupplier
        ]);
}