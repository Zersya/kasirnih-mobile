part of 'range_picker_cubit.dart';

abstract class RangePickerState extends Equatable {
  const RangePickerState();
}

class RangePickerInitial extends RangePickerState {
  final DateTime start;
  final DateTime end;

  RangePickerInitial({this.start, this.end});
  @override
  List<Object> get props => [start, end];
}
