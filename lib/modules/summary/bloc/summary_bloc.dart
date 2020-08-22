import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kasirnih_mobile/models/item.dart';
import 'package:kasirnih_mobile/utils/key.dart';

part 'summary_event.dart';
part 'summary_state.dart';
part 'summary_repository.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  final SummaryRepository _repo = SummaryRepository();

  SummaryBloc(SummaryState initialState) : super(initialState);

  @override
  Stream<SummaryState> mapEventToState(
    SummaryEvent event,
  ) async* {
    if (event is SummaryChangeQty) {
      int version = state.props[0];
      version++;
      final List<Item> selectedItems = state.props[1];
      selectedItems[event.index].qty = event.qty;
      selectedItems[event.index].sellPrice = event.price;
      if (event.qty == 0) {
        selectedItems.removeAt(event.index);
      }
      yield SummaryInitial(version, items: selectedItems);
    } else if (event is SummaryAddDiscount) {
      int version = state.props[0];
      version++;
      yield SummaryInitial(version,
          items: state.props[1], discount: event.discount);
    } else if (event is SummaryLoad) {
      final streamCodeTrx = await _repo.loadTrx();
      int version = state.props[0];
      version++;
      yield SummaryInitial(
        version,
        items: state.props[1],
        discount: state.props[2],
        streamCodeTrx: streamCodeTrx,
      );
    }
  }
}
