import 'package:flutter/material.dart';

class PlayListPage extends StatefulWidget{
  const PlayListPage({super.key});

  @override
  _PlayState createState() => _PlayState();
}

class _PlayState extends State<PlayListPage>{
  @override
  Widget build (BuildContext context){
    return const Scaffold(
      // 음악 리스트 
      // 사용자 기반 음악 리스트 이므로, 
      // 백엔드 연결과 연관
    );    
  }
}