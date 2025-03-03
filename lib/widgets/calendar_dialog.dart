import 'package:employee_records/utils/constants/text_constants.dart';
import 'package:employee_records/utils/theme/app_pallete.dart';
import 'package:employee_records/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarDialog extends StatefulWidget {
  final DateTime? initialDate;
  final List<Map<String, DateTime?>> quickSelectionOptions;
  final ScrollController? scrollController;
  final Function(DateTime)? onDateSelected;

  const CalendarDialog({
    super.key,
    this.initialDate,
    this.scrollController,
    required this.quickSelectionOptions,
    required this.onDateSelected,
  });

  @override
  _CalendarDialogState createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double maxHeight = constraints.maxHeight * 0.97;
      return Container(
        width: double.infinity,
        height: maxHeight,
        decoration: const BoxDecoration(
          color: AppPallete.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),

              // Dynamic Quick Selection Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: widget.quickSelectionOptions.map((option) {
                    String label = option.keys.first;
                    DateTime? date = option.values.first;
                    return _quickSelectButton(label, date);
                  }).toList(),
                ),
              ),

              const SizedBox(height: 12),

              // Calendar Widget
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TableCalendar(
                      firstDay: DateTime(2020),
                      lastDay: DateTime(2030),
                      focusedDay: _selectedDate ?? DateTime.now(),
                      selectedDayPredicate: (day) =>
                          isSameDay(day, _selectedDate),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDate = selectedDay;
                        });
                      },
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: GoogleFonts.roboto(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppPallete.primaryBlue, width: 2),
                        ),
                        selectedDecoration: const BoxDecoration(
                          color: AppPallete.primaryBlue,
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: GoogleFonts.roboto(
                          color: AppPallete.primaryBlue,
                          fontWeight: FontWeight.w400,
                        ),
                        selectedTextStyle: GoogleFonts.roboto(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Selected Date Display
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppPallete.bgGrey, width: 1),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              color: AppPallete.primaryBlue),
                          const SizedBox(width: 8),
                          Text(
                            (widget.quickSelectionOptions.any((option) => option
                                        .containsKey(TextConstants.noDate)) &&
                                    _selectedDate == null)
                                ? TextConstants.noDate
                                : DateFormat("d MMM yyyy")
                                    .format(_selectedDate ?? DateTime.now()),
                            style: GoogleFonts.roboto(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                          const Spacer(),
                          CustomButton(
                            text: TextConstants.cancel,
                            onPressed: () => Navigator.pop(
                                context, _selectedDate ?? widget.initialDate),
                            //Navigator.pop(context, null),
                            borderRadius: 6,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 36,
                            width: 68,
                          ),
                          const SizedBox(width: 12),
                          CustomButton(
                            text: TextConstants.save,
                            onPressed: () =>
                                Navigator.pop(context, _selectedDate),
                            borderRadius: 6,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 36,
                            width: 68,
                            color: AppPallete.primaryBlue,
                            textColor: AppPallete.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _quickSelectButton(String label, DateTime? date) {
    bool isSelected =
        date == null ? _selectedDate == null : isSameDay(_selectedDate, date);
    return CustomButton(
      text: label,
      onPressed: () => setState(() => _selectedDate = date),
      height: 34,
      width: 120,
      borderRadius: 4,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      isSelected: isSelected,
    );
  }
}
