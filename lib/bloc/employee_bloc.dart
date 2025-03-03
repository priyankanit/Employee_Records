import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../data/models/employee_model.dart';
import '../data/repository/employee_repository.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository repository;

  EmployeeBloc(this.repository) : super(EmployeeLoading()) {
    on<LoadEmployees>((event, emit) async {
      emit(EmployeeLoading()); // Show loading state before fetching data
      try {
        final employees = await repository.getEmployees();
        emit(EmployeeLoaded(employees: employees));
      } catch (e) {
        emit(EmployeeError(e.toString()));
      }
    });

    //  on<AddEmployee>((event, emit) async {
    //   await repository.addEmployee(event.employee);
    //   add(LoadEmployees());
    // });

    on<AddEmployee>((event, emit) async {
      print("Undo triggered: Adding employee back");
      try {
        await repository.addEmployee(event.employee);

        final employees = await repository.getEmployees(); // Fetch updated list

        emit(EmployeeLoaded(employees: employees)); // Emit updated state
      } catch (e, stacktrace) {
        print("Error adding employee: $e\nStackTrace: $stacktrace");
        emit(EmployeeError("Something went wrong: ${e.toString()}"));
      }
    });

    on<UpdateEmployee>((event, emit) async {
      await repository.updateEmployee(event.employee);
      final employees = await repository.getEmployees();
      emit(EmployeeLoaded(employees: employees));
      //add(LoadEmployees());
    });

    on<DeleteEmployee>((event, emit) async {
      print("Deleting Employee with ID: ${event.id}");

      try {
        emit(EmployeeLoading());
        await repository.deleteEmployee(event.id);
        final employees = await repository.getEmployees();
        emit(EmployeeLoaded(employees: employees));
        //add(LoadEmployees());
      } catch (e, stacktrace) {
        print("Error deleting employee: $e\nStackTrace: $stacktrace");
        print("Error deleting employee: $e");
        emit(const EmployeeError("Failed to delete employee"));
      }
    });

    on<UpdateRole>((event, emit) {
      if (state is EmployeeLoaded) {
        final updatedState =
            (state as EmployeeLoaded).copyWith(role: event.role);
        emit(updatedState);
      }
    });

    on<SaveEmployee>((event, emit) async {
      try {
        await repository.addEmployee(event.employee);
        final employees = await repository.getEmployees();
        emit(EmployeeLoaded(employees: employees));
      } catch (e) {
        emit(EmployeeError("Failed to save employee: ${e.toString()}"));
      }
    });

    on<ResetEmployeeForm>((event, emit) {
      if (state is EmployeeLoaded) {
        final currentEmployees = (state as EmployeeLoaded).employees;
        emit(EmployeeLoaded(employees: currentEmployees, role: null));
      } else {
        emit(const EmployeeLoaded(employees: [], role: null));
      } // Reset role and other fields
    });
  }
}
