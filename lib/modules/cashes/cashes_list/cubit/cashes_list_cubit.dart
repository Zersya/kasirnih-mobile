import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kasirnih_mobile/models/cashes.dart';

import 'package:kasirnih_mobile/models/transaction.dart' as trx;
import 'package:kasirnih_mobile/utils/key.dart';
import 'package:rxdart/rxdart.dart';

part 'cashes_list_state.dart';
part 'cashes_list_repository.dart';

class CashesListCubit extends Cubit<CashesListState> {
  final CashesListRepository _repo = CashesListRepository();

  CashesListCubit() : super(CashesListInitial());

  void loadTransaction() async {
    emit(CashesListLoading(state.props[0], state.props[1]));

    final transactions = await _repo.loadTransaction();
    final cashes = await _repo.loadCashes();
    final totalTrx = await _repo.loadTotal();

    final data = Rx.combineLatest3(transactions, cashes, totalTrx,
            (a, b, c) => {'transactions': a, 'cashes': b, 'totalTrx': c})
        .asBroadcastStream();

    int version = state.props[0];
    version++;

    emit(await CashesListInitial(version: version, data: data));
  }
}
