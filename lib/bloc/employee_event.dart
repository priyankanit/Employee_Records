part of 'employee_bloc.dart';

@immutable
sealed class EmployeeEvent {}

class LoadEmployees extends EmployeeEvent {}

class AddEmployee extends EmployeeEvent {
  final Employee employee;
  AddEmployee(this.employee);
}

class UpdateEmployee extends EmployeeEvent {
  final Employee employee;
  UpdateEmployee(this.employee);
}

class DeleteEmployee extends EmployeeEvent {
  final int id;
  DeleteEmployee(this.id);
}

class UpdateRole extends EmployeeEvent {
  final String role;
  UpdateRole(this.role);
}

class SaveEmployee extends EmployeeEvent {
  final Employee employee;
  SaveEmployee(this.employee);
}

class ResetEmployeeForm extends EmployeeEvent {}
