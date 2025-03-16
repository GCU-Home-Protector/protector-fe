import 'package:flutter/material.dart';
import 'package:daisy/login_page.dart';
import 'package:daisy/regis_page.dart';

class LoRePage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Column(
          // 중앙에 위치하도록 center 설정정
          mainAxisAlignment: MainAxisAlignment.center,
          // 로그인, 회원가입 버튼 생성
          children: <Widget>[
            Image.asset('img/main_logo.png'),
            ElevatedButton(
              onPressed: () {
              // '로그인' 버튼 클릭 시, Login page로 이동동 
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context)=> LoginPage()),);
            },
            child: Text('로그인'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(150, 40)
            ),
            ),
            SizedBox(width: 10,),
            // 위의 로그인 버튼과 동일 작성
            ElevatedButton(
            onPressed: () {
              // '로그인' 버튼 클릭 시, Register page로 이동동 
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context)=> RegisPage()),);
            },
            child: Text('회원 가입'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(150, 40)
            ),
            ),
          ],),),
    );
  }
}