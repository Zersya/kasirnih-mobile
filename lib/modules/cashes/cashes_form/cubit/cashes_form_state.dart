part of 'cashes_form_cubit.dart';

abstract class CashesFormState extends Equatable {
  const CashesFormState();
}

class CashesFormInitial extends CashesFormState {
  final int type;

  CashesFormInitial({this.type});
  @override
  List<Object> get props => [type];
}

class CashesFormSuccess extends CashesFormState {
  final int type;

  CashesFormSuccess(this.type);
  @override
  List<Object> get props => [type];
}

class CashesFormLoading extends CashesFormState {
  final int type;

  CashesFormLoading(this.type);
  @override
  List<Object> get props => [type];
}
