import 'package:employee_records/bloc/employee_bloc.dart';
import 'package:employee_records/screens/add_employee_details_screen.dart';
import 'package:employee_records/utils/constants/image_constants.dart';
import 'package:employee_records/utils/constants/text_constants.dart';
import 'package:employee_records/utils/theme/app_pallete.dart';
import 'package:employee_records/widgets/employee_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.bgGrey,
      appBar: AppBar(
        title: Text(
          TextConstants.empList,
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppPallete.white,
          ),
        ),
        backgroundColor: AppPallete.primaryBlue,
      ),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeeLoaded) {
            print("UI Employee List: ${state.employees}");
            if (state.employees.isEmpty) {
              return _buildEmptyState();
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      TextConstants.currentEmp,
                      style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppPallete.primaryBlue),
                    ),
                  ),

                  ...state.employees
                      .where((e) => e.endingDate == null)
                      .map((employee) => EmployeeTile(employee: employee)),
                      //.toList(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      TextConstants.previousEmp,
                      style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppPallete.primaryBlue),
                    ),
                  ),
                  // List of Previous Employees (Has endDate)
                  ...state.employees
                      .where((e) => e.endingDate != null)
                      .map((employee) => EmployeeTile(employee: employee)),
                      //.toList(),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10),
                    child: Text(
                      TextConstants.swipeLeftToDelete,
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        color: AppPallete.priTextColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text(TextConstants.sthWentWrong));
          }
        },
      ),
      floatingActionButton: SizedBox(
        height: 50,
        width: 50,
        child: FloatingActionButton(
          onPressed: () async {
            context.read<EmployeeBloc>().add(ResetEmployeeForm());
            // Navigate to Add Employee Screen
            final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddEmployeeDetailsScreen()));
            // Refresh employee list when a new employee is added
            if (result == true) {
              context.read<EmployeeBloc>().add(LoadEmployees());
            }
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: AppPallete.primaryBlue,
          child: const Icon(
            Icons.add,
            color: AppPallete.white,
            size: 25,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImageConstants.nodata,
            width: 200,
          ),
          const SizedBox(height: 5),
          Text(
            TextConstants.noRecordFound,
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppPallete.secTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
