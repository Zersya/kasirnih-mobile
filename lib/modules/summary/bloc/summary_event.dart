part of 'summary_bloc.dart';

abstract class SummaryEvent extends Equatable {
  final propss;
  const SummaryEvent({this.propss});

  @override
  List<Object> get props => propss;
}

class SummaryLoad extends SummaryEvent {}

class SummaryChangeQty extends SummaryEvent {
  final int index;
  final int qty;
  final int price;

  SummaryChangeQty(this.index, this.qty, this.price);
}

class SummaryAddDiscount extends SummaryEvent {
  final int discount;

  SummaryAddDiscount(this.discount);
}
