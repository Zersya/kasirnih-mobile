part of 'cashes_list_cubit.dart';

abstract class CashesListState extends Equatable {
  const CashesListState();
}

class CashesListInitial extends CashesListState {
  final int version;
  final Stream data;

  CashesListInitial({this.version = 0, this.data});

  @override
  List<Object> get props => [version, data];
}

class CashesListLoading extends CashesListState {
  final int version;
  final Stream data;

  CashesListLoading(this.version, this.data);

  @override
  List<Object> get props => [version, data];
}
