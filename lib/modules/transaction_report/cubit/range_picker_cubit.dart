import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'range_picker_state.dart';

class RangePickerCubit extends Cubit<RangePickerState> {
  RangePickerCubit() : super(RangePickerInitial());

  void changePeriod(DateTime start, DateTime end) {
    emit(RangePickerInitial(start: start, end: end));
  }
}
