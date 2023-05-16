import 'package:flutter/material.dart';
import 'package:safe_messages/app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        appBarTheme: const AppBarTheme(
            centerTitle: true,
            titleTextStyle:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
      ),
      home: const App(),
    );
  }
}
