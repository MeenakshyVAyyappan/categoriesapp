import 'package:category/Home/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Category Products',
      home: const MyHomePage(title: 'Home'),
      debugShowCheckedModeBanner: false,
    );
  }
}
