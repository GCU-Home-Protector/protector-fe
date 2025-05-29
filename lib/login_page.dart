import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:daisy/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _pwController = TextEditingController();

  Future<void> login(String userId, String password) async {
    final url = Uri.parse('http://10.0.2.2:8080/user/login'); // ✅ 서버 주소 확인 필요

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'password': password}),
    );

    if (response.statusCode == 200) {
      final accessToken = response.headers['authorization'];
      final refreshToken = response.headers['set-cookie'];

      print('✅ 로그인 성공');
      print('Access Token: $accessToken');
      print('Refresh Token: $refreshToken');

      // HomePage로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage(initInx: 1)),
      );
    } else {
      print('❌ 로그인 실패: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 실패! 아이디 또는 비밀번호를 확인하세요')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: TextFormField(
                  controller: _idController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: '아이디',
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? '아이디를 입력하세요' : null,
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: TextFormField(
                  controller: _pwController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: '비밀번호',
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? '비밀번호를 입력하세요' : null,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    login(_idController.text, _pwController.text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(150, 40),
                ),
                child: Text('로그인'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
