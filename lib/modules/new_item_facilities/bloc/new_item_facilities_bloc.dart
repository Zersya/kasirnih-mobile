import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ks_bike_mobile/models/new_item_facilities.dart';
import 'package:ks_bike_mobile/utils/key.dart';
import 'package:ks_bike_mobile/utils/toast.dart';

part 'new_item_facilities_event.dart';
part 'new_item_facilities_state.dart';
part 'new_item_facilities_repository.dart';

class NewItemFacilitiesBloc
    extends Bloc<NewItemFacilitiesEvent, NewItemFacilitiesState> {
  final NewItemFacilitiesRepository _repo = NewItemFacilitiesRepository();

  NewItemFacilitiesBloc(NewItemFacilitiesState initialState)
      : super(initialState);

  @override
  Stream<NewItemFacilitiesState> mapEventToState(
    NewItemFacilitiesEvent event,
  ) async* {
    if (event is NewItemFacilitiesLoad) {
      yield NewItemFacilitiesStateLoading(state.props[0], state.props[1]);

      List<NewItemFacilities> result = await _repo.loadListNewFacilities();

      final int version = state.props[0];
      yield NewItemFacilitiesStateInitial(
          version: version + 1, listName: result);
    } else if (event is NewItemFacilitiesAdd) {
      yield NewItemFacilitiesStateLoading(state.props[0], state.props[1]);

      await _repo.addNewFacilities(event);

      final int version = state.props[0];
      yield NewItemFacilitiesStateSuccess(version + 1, state.props[1]);
    } else if (event is NewItemFacilitiesChangeValue) {
      yield NewItemFacilitiesStateLoading(state.props[0], state.props[1]);
      await _repo.updateValue(event);

      final int version = state.props[0];
      yield NewItemFacilitiesStateSuccess(version + 1, state.props[1]);
    }
  }
}
