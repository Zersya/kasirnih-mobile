part of 'new_item_facilities_bloc.dart';

abstract class NewItemFacilitiesEvent extends Equatable {
  final propss;
  const NewItemFacilitiesEvent({this.propss});

  @override
  List<Object> get props => this.propss;
}

class NewItemFacilitiesAdd extends NewItemFacilitiesEvent {
  final String itemName;

  NewItemFacilitiesAdd(this.itemName);
}

class NewItemFacilitiesChangeValue extends NewItemFacilitiesEvent {
  final NewItemFacilities item;

  NewItemFacilitiesChangeValue(this.item);
}

class NewItemFacilitiesLoad extends NewItemFacilitiesEvent {}
