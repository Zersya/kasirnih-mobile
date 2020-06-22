import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:ks_bike_mobile/models/supplier.dart';
import 'package:ks_bike_mobile/utils/key.dart';
import 'package:ks_bike_mobile/utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'invoice_debt_event.dart';
part 'invoice_debt_state.dart';
part 'invoice_debt_repository.dart';

class InvoiceDebtBloc extends Bloc<InvoiceDebtEvent, InvoiceDebtState> {
  final InvoiceDebtRepository _repo = InvoiceDebtRepository();

  @override
  InvoiceDebtState get initialState => InvoiceDebtInitial();

  @override
  Stream<InvoiceDebtState> mapEventToState(
    InvoiceDebtEvent event,
  ) async* {
    if (event is InvoiceDebtLoad) {
      yield InvoiceDebtLoading(state.props[0], state.props[1]);

      List<Supplier> result = await _repo.loadSupplier();

      final int version = state.props[0];
      yield InvoiceDebtInitial(version: version + 1, listSupplier: result);
    } else if (event is InvoiceDebtAddSupplier) {
      yield InvoiceDebtLoading(state.props[0], state.props[1]);

      await _repo.addSupplier(event);

      final int version = state.props[0];
      yield InvoiceDebtSuccess(version + 1, state.props[1]);
    }
  }
}
