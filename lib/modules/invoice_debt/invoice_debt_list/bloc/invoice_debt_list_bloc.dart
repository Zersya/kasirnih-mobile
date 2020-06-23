import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:ks_bike_mobile/models/invoice.dart';
import 'package:ks_bike_mobile/utils/key.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'invoice_debt_list_event.dart';
part 'invoice_debt_list_state.dart';
part 'invoice_debt_list_repository.dart';

class InvoiceDebtListBloc
    extends Bloc<InvoiceDebtListEvent, InvoiceDebtListState> {
  final InvoiceDebtListRepository _repo = InvoiceDebtListRepository();

  @override
  InvoiceDebtListState get initialState => InvoiceDebtListInitial();

  @override
  Stream<InvoiceDebtListState> mapEventToState(
    InvoiceDebtListEvent event,
  ) async* {
    yield InvoiceDebtListLoading(state.props[0], state.props[1], state.props[2]);
    if (event is InvoiceDebtListLoadInvoice) {
      yield* loadSupplier(event, state);
    }
  }

  Stream<InvoiceDebtListState> loadSupplier(
      InvoiceDebtListLoadInvoice event, InvoiceDebtListState state) async* {
    List<Invoice> result = await _repo.loadInvoices();
    int total = await _repo.loadTotal();

    final int version = state.props[0];
    yield InvoiceDebtListInitial(
      version: version + 1,
      listInvoice: result,
      total: total,
    );
  }
}
