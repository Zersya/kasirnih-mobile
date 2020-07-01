import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ks_bike_mobile/models/item.dart';

part 'summary_event.dart';
part 'summary_state.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  final List<Item> items;

  SummaryBloc(this.items);

  @override
  SummaryState get initialState => SummaryInitial(0, items: items);

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
    }
  }
}
