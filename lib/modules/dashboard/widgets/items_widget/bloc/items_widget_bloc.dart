import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:ks_bike_mobile/models/category.dart';
import 'package:ks_bike_mobile/models/item.dart';
import 'package:ks_bike_mobile/utils/key.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'items_widget_event.dart';
part 'items_widget_state.dart';
part 'items_widget_repository.dart';

class ItemsWidgetBloc extends Bloc<ItemsWidgetEvent, ItemsWidgetState> {
      final ItemsWidgetRepository _repo = ItemsWidgetRepository();
  @override
  ItemsWidgetState get initialState => ItemsWidgetInitial();

  @override
  Stream<ItemsWidgetState> mapEventToState(
    ItemsWidgetEvent event,
  ) async* {
    if(event is ItemsWidgetLoad){
      final result = await _repo.loadItems(event, state);
      final int version = state.props[0];
      yield ItemsWidgetInitial(version: version + 1, items: result);
    }
  }
}
