import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';

import '../constants/theme.dart';

class Calendar extends StatelessWidget {
  Calendar({super.key});

  final List<DateTime?> _rangeDatePickerValueWithDefaultValue = [
    DateTime(2024, 8, 11),
    DateTime(2024, 8, 15),
  ];

  @override
  Widget build(BuildContext context) {
    final config = CalendarDatePicker2Config(
      centerAlignModePicker: true,
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: AppColors.primary,
      weekdayLabelTextStyle: AppText.matter,
      controlsTextStyle: AppText.matter,
      dynamicCalendarRows: true,
      modePickerBuilder: ({required monthDate, isMonthPicker}) {
        return Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            margin: const EdgeInsets.all(8),
            child: Text(
                isMonthPicker == true
                    ? getLocaleShortMonthFormat(const Locale('en'))
                    .format(monthDate)
                    : monthDate.year.toString(),
                style: AppText.matter
            ),
          ),
        );
      },
      weekdayLabelBuilder: ({required weekday, isScrollViewTopHeader}) {
        if (weekday == DateTime.wednesday) {
          return const Center(
            child: Text('W',
                style: AppText.primaryHead
            ),
          );
        }
        return null;
      },
      disabledDayTextStyle: AppText.matter,
      selectableDayPredicate: (day) {
        if (_rangeDatePickerValueWithDefaultValue.isEmpty ||
            _rangeDatePickerValueWithDefaultValue.length == 2) {
          // exclude Wednesday
          return day.weekday != DateTime.wednesday;
        } else {
          // Make sure range does not contain any Wednesday
          final firstDate = _rangeDatePickerValueWithDefaultValue.first;
          final range = [firstDate!, day]..sort();
          for (var date = range.first;
          date.compareTo(range.last) <= 0;
          date = date.add(const Duration(days: 1))) {
            if (date.weekday == DateTime.wednesday) {
              return false;
            }
          }
        }
        return true;
      },
    );
    return Container(
      color: AppColors.backGroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 18,),
          CalendarDatePicker2(
            config: config,
            value: _rangeDatePickerValueWithDefaultValue,
            ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }

String _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
    ) {
  values =
      values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
  var valueText = (values.isNotEmpty ? values[0] : null)
      .toString()
      .replaceAll('00:00:00.000', '');

  if (datePickerType == CalendarDatePicker2Type.multi) {
    valueText = values.isNotEmpty
        ? values
        .map((v) => v.toString().replaceAll('00:00:00.000', ''))
        .join(', ')
        : 'null';
  } else if (datePickerType == CalendarDatePicker2Type.range) {
    if (values.isNotEmpty) {
      final startDate = values[0].toString().replaceAll('00:00:00.000', '');
      final endDate = values.length > 1
          ? values[1].toString().replaceAll('00:00:00.000', '')
          : 'null';
      valueText = '$startDate to $endDate';
    } else {
      return 'null';
    }
  }

  return valueText;
}
}

class timeSelector extends StatefulWidget {
  final Function(dynamic)? callBack;
  const timeSelector({super.key, required this.callBack});

  @override
  State<timeSelector> createState() => _timeSelectorState();
}

class _timeSelectorState extends State<timeSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),

        child: EasyDateTimeLine(
          initialDate: DateTime.now(),
          onDateChange: widget.callBack,
          headerProps: const EasyHeaderProps(
            monthPickerType: MonthPickerType.dropDown,
            dateFormatter: DateFormatter.fullDateDMY(),
          ),
          activeColor: AppColors.primary,
          dayProps: const EasyDayProps(
            landScapeMode: true,
            activeDayStyle: DayStyle(
              borderRadius: 48.0,
            ),
            dayStructure: DayStructure.dayStrDayNum,
          ),
        ),
      );
  }
}
