import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateRangePicker {
  static void show(
    BuildContext context, {
    bool isLimitMaxDate = true,
    required Function(DateTime)? onDateSelected,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: _DateRangePickerView(
            isLimitMaxDate: isLimitMaxDate,
            onDateSelected: onDateSelected,
          ),
        );
      },
    );
  }
}

class _DateRangePickerView extends StatefulWidget {
  const _DateRangePickerView({this.onDateSelected, this.isLimitMaxDate = true});

  final Function(DateTime)? onDateSelected;
  final bool isLimitMaxDate;

  @override
  State<_DateRangePickerView> createState() => __DateRangePickerViewState();
}

class __DateRangePickerViewState extends State<_DateRangePickerView> {
  DateTime? _selectedDate;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      width: 300,
      child: Column(
        children: [
          Text(_selectedDate?.jiffyFormatToString('dd/MM/yyyy') ?? ''),
          const SizedBox(height: 10),
          Expanded(
            child: SfDateRangePicker(
              maxDate: widget.isLimitMaxDate ? DateTime.now() : null,
              enableMultiView: true,
              initialDisplayDate: DateTime.now(),
              headerStyle: const DateRangePickerHeaderStyle(
                backgroundColor: Colors.white,
              ),
              navigationDirection: DateRangePickerNavigationDirection.vertical,
              selectionMode: DateRangePickerSelectionMode.single,
              monthViewSettings: const DateRangePickerMonthViewSettings(
                enableSwipeSelection: false,
              ),
              backgroundColor: Colors.lightGreen.withValues(alpha: 0.3),
              showActionButtons: true,
              showTodayButton: true,
              showNavigationArrow: true,
              onCancel: () => Navigator.pop(context),
              onSelectionChanged: (value) {
                setState(() {
                  if (value.value is DateTime) {
                    _selectedDate = value.value;
                  }
                });
              },

              onSubmit: (value) {
                if (value == null) return;
                if (value is DateTime) {
                  widget.onDateSelected?.call(value);
                  Navigator.pop(context);
                  return;
                }
              },
              navigationMode: DateRangePickerNavigationMode.scroll,
            ),
          ),
        ],
      ),
    );
  }
}

extension DateTimes on DateTime {
  String jiffyFormatToString(String? pattern) {
    try {
      return Jiffy.parse(toString()).format(pattern: pattern);
    } catch (e) {
      return '';
    }
  }

  Jiffy toJiffy({String? pattern}) {
    try {
      return Jiffy.parse(toString(), pattern: pattern);
    } catch (e) {
      return Jiffy.now();
    }
  }
}
