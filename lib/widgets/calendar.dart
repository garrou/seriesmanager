import 'package:flutter/material.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AppCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final String text;
  final Function(DateRangePickerSelectionChangedArgs args) callback;
  const AppCalendar(
      {Key? key,
      required this.callback,
      required this.selectedDate,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          Text(text, style: minTextStyle),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: SfDateRangePicker(
              headerHeight: 20,
              minDate: DateTime.utc(2000),
              maxDate: DateTime.now(),
              todayHighlightColor: Colors.black,
              selectionColor: Colors.black,
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.single,
              onSelectionChanged: callback,
              headerStyle:
                  const DateRangePickerHeaderStyle(textAlign: TextAlign.center),
            ),
          ),
        ],
      );
}
