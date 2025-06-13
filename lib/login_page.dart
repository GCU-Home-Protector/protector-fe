import 'package:flutter/material.dart';
import 'package:daisy/home_page.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget{

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _pwController = TextEditingController();

  @override
  Widget build (BuildContext context){
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 가운데로 정렬
            children: <Widget>[
              Container(margin: EdgeInsets.only(left: 50, right: 50, top: 15),
                child: TextFormField(
                  controller: _idController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: Color.fromARGB(255, 9, 149, 14)),
                    ),
                    labelText: '아이디'
                  ),
                  // id 자리 비어있으면 '입력 경고 문자 뜨기'
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '아이디를 입력하세요';
                    }
                    return null;
                  },
                ),
              ),
              Container(margin: EdgeInsets.only(left: 50, right: 50, top: 15),
                child: TextFormField(
                  controller: _pwController,
                  obscureText: true, // 비밀번호 입력 시각 효과 숨기기
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: Color.fromARGB(255, 9, 149, 14)),
                    ),
                    labelText: '비밀번호'
                  ),
                  // pw 자리 비어있으면 '입력 경고 문자 뜨기'
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력하세요';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                if (_formKey.currentState!.validate()){
                  
                  // '로그인' 버튼 클릭 시, DB의 id, pw 확인 과정
                  // 1. 이미 존재하는 회원 : 환영합니다! 와 함께 메인으로 이동
                  // 2. id 혹은 pw가 일치하지 않는 회원 : '아이디 혹은 비밀번호가 일치하지 않습니다.' -> 백엔드 

                  // 우선, 백엔드 연결 전에, 로그인 버튼 클릭 시 메인 화면으로 이동하는 것으로 하여 다른 페이지 구현을 진행
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(initInx: 1,))); // initInx : 1 ==> 카메라 화면면
                  // 추후에 백엔드 연결하면 로그인 성공 시 코드로 이동...
                  // pushReplacement : 로그인 후 이전 화면으로 다시 back 불가가
                }
              }, 
              child: Text('로그인'),
              style: 
                ElevatedButton.styleFrom(
                  minimumSize: Size(150, 40),
                ),
              )
            ],
            ),
          )
        
      ),
    );
  }
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:daisy/home_page.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _idController = TextEditingController();
//   final _pwController = TextEditingController();

//   Future<void> login(String userId, String password) async {
//     final url = Uri.parse('http://10.0.2.2:8080/user/login'); // ✅ 서버 주소 확인 필요

//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'userId': userId, 'password': password}),
//     );

//     if (response.statusCode == 200) {
//       final accessToken = response.headers['authorization'];
//       final refreshToken = response.headers['set-cookie'];

//       print('✅ 로그인 성공');
//       print('Access Token: $accessToken');
//       print('Refresh Token: $refreshToken');

//       // HomePage로 이동
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HomePage(initInx: 1)),
//       );
//     } else {
//       print('❌ 로그인 실패: ${response.body}');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('로그인 실패! 아이디 또는 비밀번호를 확인하세요')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
//                 child: TextFormField(
//                   controller: _idController,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     labelText: '아이디',
//                   ),
//                   validator: (value) =>
//                       value == null || value.isEmpty ? '아이디를 입력하세요' : null,
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
//                 child: TextFormField(
//                   controller: _pwController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     labelText: '비밀번호',
//                   ),
//                   validator: (value) =>
//                       value == null || value.isEmpty ? '비밀번호를 입력하세요' : null,
//                 ),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     login(_idController.text, _pwController.text);
//                   }
//                 },
//                 child: Text('로그인'),
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: Size(150, 40),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
