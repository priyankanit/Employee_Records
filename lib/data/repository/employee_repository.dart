import '../../core/database_helper.dart';
import '../models/employee_model.dart';

class EmployeeRepository {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  Future<List<Employee>> getEmployees() async {
    final employees = await dbHelper.fetchEmployees();
     print("Fetched Employees: ${employees.length}");
     return employees;
  }

  Future<void> addEmployee(Employee employee) async {
    await dbHelper.insertEmployee(employee);
     print("Employee Added: ${employee.name}, Role: ${employee.position}");
  }

  Future<void> updateEmployee(Employee employee) async {
    await dbHelper.updateEmployee(employee);
    print("Employee Updated: ${employee.name}");
  }

  Future<void> deleteEmployee(int id) async {
    await dbHelper.deleteEmployee(id);
    print(" Employee Deleted: ID $id");
  }
}
