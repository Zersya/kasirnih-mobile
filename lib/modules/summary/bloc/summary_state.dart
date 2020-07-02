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
  final Stream<String> streamCodeTrx;

  SummaryInitial(this.version, {this.items, this.discount = 0, this.streamCodeTrx})
      : super(propss: [version, items, discount, streamCodeTrx]);
}
