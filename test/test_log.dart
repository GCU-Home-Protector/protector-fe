import 'package:flutter/material.dart';

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
            mainAxisAlignment: MainAxisAlignment.center, // ㄱ운데로 정렬
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
              ElevatedButton(onPressed: (){
                if (_formKey.currentState!.validate()){
                  // '로그인' 버튼 클릭 시, DB의 id, pw 확인 과정
                  // 1. 이미 존재하는 회원 : 환영합니다! 와 함께 메인으로 이동
                  // 2. id 혹은 pw가 일치하지 않는 회원 : '아이디 혹은 비밀번호가 일치하지 않습니다.'
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