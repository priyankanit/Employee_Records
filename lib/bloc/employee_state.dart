part of 'employee_bloc.dart';

@immutable
sealed class EmployeeState {
  final String? name;
  final String? role;
  final DateTime? joiningDate;
  final DateTime? endingDate;

 const  EmployeeState({this.name, this.role, this.joiningDate, this.endingDate});
}
class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<Employee> employees;
  const  EmployeeLoaded({required this.employees, super.role});

      EmployeeLoaded copyWith({List<Employee>? employees, String? role}) {
    return EmployeeLoaded(
      employees: employees ?? this.employees,
      role: role ?? this.role,
    );
  }
  
}

class EmployeeError extends EmployeeState {
  final String message;
 const  EmployeeError(this.message);
}

class EmployeeRoleUpdated extends EmployeeState {
 const  EmployeeRoleUpdated(String role) : super(role: role);
}

class EmployeeSaved extends EmployeeState {}