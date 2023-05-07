import 'package:flutter/material.dart';
import 'CalendarView.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
const AUTH0_REDIRECT_URI = "edu.cpp.katie.spring_app://";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting().then((_) => runApp(const Braindump()));
}

class Braindump extends StatelessWidget {
  const Braindump({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Braindump',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: CalendarView(),
    );
  }
}