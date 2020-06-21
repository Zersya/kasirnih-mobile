part of 'new_item_facilities_bloc.dart';

abstract class NewItemFacilitiesState extends Equatable {
  final propss;
  const NewItemFacilitiesState({this.propss});

  @override
  List<Object> get props => propss;
}

class NewItemFacilitiesStateInitial extends NewItemFacilitiesState {
  final int version;
  final List<NewItemFacilities> listName;
  
  NewItemFacilitiesStateInitial({this.version = 0, this.listName = const []}) : super(propss: [version, listName]);
}

class NewItemFacilitiesStateSuccess extends NewItemFacilitiesState {
  final int version;
  final List<NewItemFacilities> listName;

  NewItemFacilitiesStateSuccess(this.version, this.listName) : super(propss: [version, listName]);
}

class NewItemFacilitiesStateLoading extends NewItemFacilitiesState {
  final int version;
  final List<NewItemFacilities> listName;

  NewItemFacilitiesStateLoading(this.version,this.listName) : super(propss: [version, listName]);
}
