import 'package:flutter/material.dart';
import 'package:daisy/login_page.dart';
import 'package:daisy/regis_page.dart';

class LoRePage extends StatelessWidget {
  const LoRePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('img/main_logo.png'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(150, 40)),
              child: Text('로그인'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisPage()),
                );
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(150, 40)),
              child: Text('회원 가입'),
            ),
          ],
        ),
      ),
    );
  }
}
