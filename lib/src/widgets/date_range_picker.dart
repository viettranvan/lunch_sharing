import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lunch_sharing/src/widgets/index.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateRangePicker {
  static void show(
    BuildContext context, {
    required DateTime? startDate,
    required DateTime? endDate,
    bool isLimitMaxDate = true,
    required Function(DateTime, DateTime)? onRangeDateSelected,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: _DateRangePickerView(
            startDate: startDate,
            endDate: endDate,
            onRangeDateSelected: onRangeDateSelected,
            isLimitMaxDate: isLimitMaxDate,
          ),
        );
      },
    );
  }
}

class _DateRangePickerView extends StatefulWidget {
  const _DateRangePickerView({
    this.startDate,
    this.endDate,
    this.onRangeDateSelected,
    this.isLimitMaxDate = true,
  });

  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime, DateTime)? onRangeDateSelected;
  final bool isLimitMaxDate;

  @override
  State<_DateRangePickerView> createState() => __DateRangePickerViewState();
}

class __DateRangePickerViewState extends State<_DateRangePickerView> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    startDate = widget.startDate;
    endDate = widget.endDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      width: 300,
      child: Column(
        children: [
          Text(_renderDateRangeText()),
          const SizedBox(height: 10),
          Expanded(
            child: SfDateRangePicker(
              maxDate: widget.isLimitMaxDate ? DateTime.now() : null,
              enableMultiView: true,
              initialDisplayDate: startDate,
              initialSelectedRange: PickerDateRange(startDate, endDate),
              headerStyle: const DateRangePickerHeaderStyle(
                backgroundColor: Colors.white,
              ),
              navigationDirection: DateRangePickerNavigationDirection.vertical,
              selectionMode: DateRangePickerSelectionMode.range,
              monthViewSettings: const DateRangePickerMonthViewSettings(
                enableSwipeSelection: false,
              ),
              backgroundColor: Colors.amberAccent.withValues(alpha: 0.5),
              showActionButtons: true,
              showTodayButton: true,
              showNavigationArrow: true,
              onCancel: () => Navigator.pop(context),
              onSelectionChanged: (range) {
                if (range.value is PickerDateRange) {
                  setState(() {
                    startDate = range.value.startDate;
                    endDate = range.value.endDate;
                  });
                }
              },
              onSubmit: (value) {
                if (value is PickerDateRange) {
                  final DateTime? start = value.startDate;
                  final DateTime? end = value.endDate;
                  if (start != null) {
                    Navigator.pop(context);
                    widget.onRangeDateSelected?.call(start, end ?? start);
                  }
                } else {
                  EasyLoading.showError(
                    'Please select a specific date or date range to apply!',
                  );
                }
              },
              navigationMode: DateRangePickerNavigationMode.scroll,
            ),
          ),
        ],
      ),
    );
  }

  String _renderDateRangeText() {
    if (startDate != null && endDate != null) {
      return '${startDate!.jiffyFormatToString('dd/MM/yyyy')} - ${endDate!.jiffyFormatToString('dd/MM/yyyy')}';
    } else if (startDate != null) {
      return startDate!.jiffyFormatToString('dd/MM/yyyy');
    } else {
      return 'Select Date Range';
    }
  }
}
