part of 'summary_bloc.dart';

abstract class SummaryState extends Equatable {
  final propss;
  const SummaryState({this.propss});
  @override
  List<Object> get props => propss;
}

class SummaryInitial extends SummaryState {
  final int version;
  final List<Item> items;
  final int discount;

  SummaryInitial(this.version, {this.items, this.discount = 0})
      : super(propss: [version, items, discount]);
}
