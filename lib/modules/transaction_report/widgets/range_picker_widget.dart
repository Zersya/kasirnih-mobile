import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/range_picker_cubit.dart';

class RangePickerWidget extends StatelessWidget {
  const RangePickerWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(child: BlocBuilder<RangePickerCubit, RangePickerState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RangePicker(
              selectedPeriod: DatePeriod(state.props[0] ?? DateTime.now(),
                  state.props[1] ?? DateTime.now()),
              onChanged: (period) {
                context
                    .bloc<RangePickerCubit>()
                    .changePeriod(period.start, period.end);
              },
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            ),
            FlatButton(
              child: Text('Kembali'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    ));
  }
}
