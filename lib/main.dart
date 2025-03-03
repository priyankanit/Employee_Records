import 'package:employee_records/bloc/employee_bloc.dart';
import 'package:employee_records/data/repository/employee_repository.dart';
import 'package:employee_records/screens/employee_list_screen.dart';
import 'package:employee_records/utils/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppPallete.bgBlue,
    //statusBarIconBrightness: Brightness.light,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeBloc(EmployeeRepository())..add(LoadEmployees()),
      child: const MaterialApp(
        title: 'Employee Records',
        debugShowCheckedModeBanner: false,
        home:EmployeeListScreen(),
      ),
    );
  }
}

