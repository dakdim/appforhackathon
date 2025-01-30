// import 'package:cleanapp/view/homepage.dart';
import 'package:cleanapp/view/profile/login.dart';
import 'package:flutter/material.dart';
// import 'package:cleanapp/view/expense.dart';

void main() {
  runApp(const MyApp()); // Root widget
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), // Use HomePage from homepage.dart as the home screen
    );
  }
}
