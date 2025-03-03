import 'package:employee_records/bloc/employee_bloc.dart';
import 'package:employee_records/data/models/employee_model.dart';
import 'package:employee_records/screens/edit_employee_details_screen.dart';
import 'package:employee_records/utils/constants/text_constants.dart';
import 'package:employee_records/utils/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EmployeeTile extends StatelessWidget {
  final Employee employee;

  const EmployeeTile({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
       final result =  await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  EditEmployeeDetailsScreen(employee:employee),
          ),
        );

        //Refresh list if an employee was edited
        if (result == true) {
           print("Reloading Employees after Editing");
          context.read<EmployeeBloc>().add(LoadEmployees());
        }
      },
      child: Dismissible(
        key: Key(employee.id.toString()),
        direction: DismissDirection.endToStart,
        background: Container(
          color: AppPallete.delete,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.delete_outline_sharp, color: AppPallete.white),
        ),
        onDismissed: (direction) {
      final employeeBloc = context.read<EmployeeBloc>(); // Store context reference before widget removal
  final deletedEmployee = employee; // Store the deleted employee locally
  
      employeeBloc.add(DeleteEmployee(employee.id!)); // Delete employee
  employeeBloc.add(LoadEmployees()); // Refresh the list
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:  Text(TextConstants.empDataDeleted),
              action: SnackBarAction(
                label: TextConstants.undo,
                textColor: AppPallete.primaryBlue,
                onPressed: () {
                  print("Undoing deletion: ${employee.name}");
                  
                  employeeBloc.add(AddEmployee(deletedEmployee));
          employeeBloc.add(LoadEmployees()); // Refresh list
                   
                },
              ),
            ),
    );
           
        },
        child: ListTile(
          contentPadding: const EdgeInsets.all(8),
          tileColor: Colors.white,
          shape: const RoundedRectangleBorder(
            //borderRadius: BorderRadius.circular(1),
            side: BorderSide(color: AppPallete.bgGrey),
          ),
          title: Text(
            employee.name,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500, fontSize: 16, color: AppPallete.secTextColor),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(employee.position, style: GoogleFonts.roboto(
                fontSize: 14, fontWeight: FontWeight.w400, color: AppPallete.priTextColor)),
              Text(
                //_getEmployeeDuration(employee),
                employee.endingDate == null
                    ? "From ${DateFormat("d MMM, yyyy").format(DateTime.parse(employee.joiningDate))}"
                    : "${DateFormat("d MMM, yyyy").format(DateTime.parse(employee.joiningDate))} - ${DateFormat("d MMM, yyyy").format(DateTime.parse(employee.endingDate!))}",
                style: GoogleFonts.roboto(
                  fontSize: 12, 
                  fontWeight: FontWeight.w400,
                  color: AppPallete.priTextColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


