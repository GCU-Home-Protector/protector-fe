import 'package:flutter/material.dart';

class RegisPage extends StatefulWidget {
  @override
  _RegisPageState createState() => _RegisPageState();
}

class _RegisPageState extends State<RegisPage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isIdAvailable = true;

  // ID 중복 체크
  void _checkIdAvailability() async {
    
    // HTTP 요청을 통해 백엔드에 ID 중복 체크 요청
    // final response = await http.get(Uri.parse('http://백엔드URI.com/idcheck/${_idController.text}'));

    // if (response.statusCode == 200) {
    //   final jsonData = jsonDecode(response.body);
    //   setState(() {
    //     _isIdAvailable = jsonData['available'];
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left: 50, right: 50, top: 15),
                child: TextFormField(
                  controller: _idController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Color.fromARGB(255, 9, 149, 14)),
                    ),
                    labelText: 'ID',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '아이디를 입력하세요.';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 50, right: 50, top: 15),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: _checkIdAvailability,
                      child: Text('중복 체크'),
                    ),
                    SizedBox(width: 5),
                    Text(_isIdAvailable ? '사용 가능한 ID' : '사용 불가 ID'),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 50, right: 50, top: 15),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Color.fromARGB(255, 9, 149, 14)),
                    ),
                    labelText: '비밀번호',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력하세요.';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // '회원 가입 및 로그인' 클릭 시, DB에 id, pw 저장
                    // 백엔드에 회원 가입 요청
                    // final response = http.post(
                    //   Uri.parse('http://your-backend-url.com/register'),
                    //   headers: {
                    //     'Content-Type': 'application/json; charset=UTF-8',
                    //   },
                    //   body: jsonEncode({
                    //     'id': _idController.text,
                    //     'password': _passwordController.text,
                    //     'email': _emailController.text,
                    //   }),
                    // );

                    // if (response.statusCode == 200) {
                    //   // 회원 가입 완료료
                    // } else {
                    //   // 회원 가입 불가가
                    // }
                  }
                },
                child: Text('회원 가입 및 로그인'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}