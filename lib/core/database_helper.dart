import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../data/models/employee_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('employees.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    try{ 
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
    
  }catch (e) {
    throw Exception("Database initialization failed: $e");
  }
}

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE employees (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        position TEXT NOT NULL,
        joiningDate TEXT,
        endingDate TEXT
      )
    ''');
  }

  Future<int> insertEmployee(Employee employee) async {
    final db = await database;
    return await db.insert('employees', employee.toMap());
  }

  Future<List<Employee>> fetchEmployees() async {
    final db = await database;
    final result = await db.query('employees');
    print(result);

    return result.map((e) => Employee.fromMap(e)).toList();
  }

  Future<int> updateEmployee(Employee employee) async {
    final db = await database;
    return await db.update(
      'employees',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  Future<int> deleteEmployee(int id) async {
    final db = await database;
    return await db.delete('employees', where: 'id = ?', whereArgs: [id]);
  }
}
