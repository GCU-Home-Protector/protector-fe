import 'package:flutter/material.dart';
import 'package:daisy/log_re_page.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const Daisy());
}

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(Daisy());
// }

class Daisy extends StatelessWidget {
  const Daisy({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daisy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 9, 149, 14)),
        useMaterial3: true,
      ),
      home: const LoRePage(),
    );
  }
}