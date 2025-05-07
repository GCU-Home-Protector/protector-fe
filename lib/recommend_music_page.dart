import 'package:flutter/material.dart';

class RecomMusicPage extends StatefulWidget{
  final String base64String;
  const RecomMusicPage({Key? key, required this.base64String}) : super (key: key);

  @override
  State<RecomMusicPage> createState() => _RecomMusicState();  
}

class _RecomMusicState extends State<RecomMusicPage>{
  @override

  // 인코딩된 이미지 확인하기 위한 코드
  void initState() {
    // TERMINAL에 base64 문자열 출력하기
    print("base64 String : ${widget.base64String}");
  }


  @override
  Widget build (BuildContext context){
    // base64 인코딩된 string이 길다면 앞부분만 간략히 표시
    final displayString = widget.base64String.length > 200
    ? widget.base64String.substring(0, 200) + '...'
    : widget.base64String;

    return Scaffold(
      appBar: AppBar(title: const Text("Base64 인코딩 결과")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: SelectableText(
          displayString,
          style: const TextStyle(fontSize: 15),
        ),
        ),
      // 실제 : 백엔드에서 반환하는 음악 화면
    );    
  }
}