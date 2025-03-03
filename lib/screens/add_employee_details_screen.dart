import 'package:employee_records/bloc/employee_bloc.dart';
import 'package:employee_records/data/models/employee_model.dart';
import 'package:employee_records/utils/constants/text_constants.dart';
import 'package:employee_records/utils/theme/app_pallete.dart';
import 'package:employee_records/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../widgets/calendar_dialog.dart';

class AddEmployeeDetailsScreen extends StatefulWidget {
  const AddEmployeeDetailsScreen({super.key});

  @override
  State<AddEmployeeDetailsScreen> createState() =>
      _AddEmployeeDetailsScreenState();
}

class _AddEmployeeDetailsScreenState extends State<AddEmployeeDetailsScreen> {
  final TextEditingController nameController = TextEditingController();

  DateTime? selectedDate;
  String? selectedRole;
  DateTime? joiningDate = DateTime.now();
  DateTime? endingDate;

  final List<String> _roles = [
    "Product Designer",
    "Flutter Developer",
    "QA Tester",
    "Product Owner"
  ];

  @override
  void initState() {
    super.initState();
    selectedRole = null;
    selectedDate = null;
  }

  void _saveEmployee() {
    if (nameController.text.isNotEmpty && selectedRole != null) {
      // Save employee data
      final employee = Employee(
        name: nameController.text,
        position: selectedRole!,
        joiningDate: DateFormat('yyyy-MM-dd').format(joiningDate!),
        endingDate: endingDate != null
            ? DateFormat('yyyy-MM-dd').format(endingDate!)
            : null,
      );

      context.read<EmployeeBloc>().add(SaveEmployee(employee));
      context.read<EmployeeBloc>().add(LoadEmployees());
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(TextConstants.fillAllFields)),
      );
    }
  }

  Future<void> showCalendarDialog(
    BuildContext context, {
    DateTime? initialDate,
    required Function(DateTime?) onDateSelected,
    bool onlyBasicSelection = false,
  }) async {
    final DateTime? selectedDate = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: CalendarDialog(
            onDateSelected: onDateSelected,
            quickSelectionOptions: onlyBasicSelection
                ? [
                    {TextConstants.noDate: null},
                    {TextConstants.today: DateTime.now()},
                  ]
                : [
                    {TextConstants.today: DateTime.now()},
                    {TextConstants.nextMonday: _getNextMonday()},
                    {TextConstants.nextTuesday: _getNextTuesday()},
                    {
                      TextConstants.afterOneWeek:
                          DateTime.now().add(const Duration(days: 7))
                    },
                  ],
          ),
        );
      },
    );

    // If the user selects a date and confirms
    if (selectedDate != null) {
      onDateSelected(selectedDate);
    } else {
      onDateSelected(null);
    }
    //onDateSelected(selectedDate);
  }

// Helper functions
  DateTime _getNextMonday() {
    DateTime now = DateTime.now();
    return now.add(Duration(days: (8 - now.weekday) % 7));
  }

  DateTime _getNextTuesday() {
    DateTime now = DateTime.now();
    return now.add(Duration(days: (9 - now.weekday) % 7));
  }

  void _showRoleSelector(BuildContext context, EmployeeBloc bloc) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Wrap(
          children: [
            const SizedBox(height: 10),
            Column(
              children: List.generate(_roles.length, (index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        bloc.add(UpdateRole(_roles[index]));
                        setState(() {
                          selectedRole = _roles[index];
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          _roles[index],
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppPallete.secTextColor,
                          ),
                        ),
                      ),
                    ),
                    if (index < _roles.length - 1)
                      const Divider(
                        color: AppPallete.bgGrey,
                        thickness: 1,
                        height: 1,
                      ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 10), // Space at the bottom
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.white,
      appBar: AppBar(
        title: Text(
          TextConstants.addEmpDetails,
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppPallete.white,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppPallete.primaryBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              cursorColor: AppPallete.primaryBlue,
              //cursorHeight: 20,
              controller: nameController,
              decoration: InputDecoration(
                labelText: TextConstants.empName,
                labelStyle: const TextStyle(color: AppPallete.priTextColor),
                prefixIcon: const Icon(
                  Icons.person_2_outlined,
                  color: AppPallete.primaryBlue,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide:
                      BorderSide(color: AppPallete.borderColor, width: 1),
                ),
                focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppPallete.borderColor, width: 1)),
              ),
            ),
            const SizedBox(height: 16),

            BlocBuilder<EmployeeBloc, EmployeeState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () =>
                      _showRoleSelector(context, context.read<EmployeeBloc>()),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      //labelText: "Select role",
                      prefixIcon: Icon(Icons.work_outline,
                          color: AppPallete.primaryBlue),
                      suffixIcon: Icon(Icons.arrow_drop_down,
                          color: AppPallete.primaryBlue),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppPallete.borderColor, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppPallete.borderColor, width: 1)),
                    ),
                    child: Text(
                      state.role ?? TextConstants.selectRole,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: (state.role != null && state.role!.isNotEmpty)
                            ? AppPallete
                                .secTextColor 
                            : AppPallete.priTextColor,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showCalendarDialog(context, initialDate: DateTime.now(),
                          onDateSelected: (selectedDate) {
                        setState(() {
                          joiningDate = selectedDate;
                        });
                      });
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        //labelText: "Joining Date",
                        prefixIcon: Icon(
                          Icons.calendar_today_outlined,
                          color: AppPallete.primaryBlue,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                              color: AppPallete.borderColor,
                              width: 1,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppPallete.borderColor, width: 1)),
                      ),
                      child: Text(
                       
                        joiningDate != null &&
                                DateFormat('d MMM yyyy').format(joiningDate!) ==
                                    DateFormat('d MMM yyyy')
                                        .format(DateTime.now())
                            ? TextConstants.today
                            : DateFormat('d MMM yyyy').format(joiningDate!),
                        style: GoogleFonts.roboto(
                            color: joiningDate != null
                                ? AppPallete.secTextColor
                                : AppPallete.priTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(
                  Icons.arrow_forward_sharp,
                  color: AppPallete.primaryBlue,
                  size: 20,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () => showCalendarDialog(context,
                        initialDate: DateTime.now(), onlyBasicSelection: true,
                        onDateSelected: (selectedDate) {
                      setState(() {
                        endingDate = selectedDate;
                      });
                    }),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        //labelText: "Ending Date",
                        prefixIcon: Icon(
                          Icons.calendar_today_outlined,
                          color: AppPallete.primaryBlue,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                            color: AppPallete.borderColor,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppPallete.borderColor, width: 1)),
                      ),
                      child: Text(
                        endingDate != null
                            ? DateFormat('d MMM yyyy').format(endingDate!)
                            : TextConstants.noDate,
                        style: GoogleFonts.roboto(
                            color: endingDate != null
                                ? AppPallete.secTextColor
                                : AppPallete.priTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(
                  color: AppPallete.bgGrey,
                  width: 2,
                ))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomButton(
                            text: TextConstants.cancel,
                            onPressed: () => Navigator.pop(context),
                            width: 73,
                            height: 40,
                            color: AppPallete.lightBlue,
                            textColor: AppPallete.primaryBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            borderRadius: 6),
                        const SizedBox(
                          width: 20,
                        ),
                        CustomButton(
                            text: TextConstants.save,
                            onPressed: _saveEmployee,
                            width: 73,
                            height: 40,
                            color: AppPallete.primaryBlue,
                            textColor: AppPallete.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            borderRadius: 6),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
