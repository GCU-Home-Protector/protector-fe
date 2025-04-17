import 'package:flutter/material.dart';
import 'package:daisy/log_re_page.dart';


void main() {
  runApp(Daisy()); // Daisy 앱 실행
}

class Daisy extends StatelessWidget {
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daisy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 9, 149, 14)),
        useMaterial3: true,
      ),
      home: LoRePage(),
    );
  }
}