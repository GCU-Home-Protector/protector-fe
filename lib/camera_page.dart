//import 'dart:ffi';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:io';
import 'dart:convert';  // json data 처리 패키지 

import 'package:daisy/recommend_music_page.dart';

class CamPage extends StatefulWidget{

  const CamPage(
    {super.key, required this.camera}
    );

    final CameraDescription camera;

  @override
  State<CamPage> createState() => _CamState();
}

class _CamState extends State<CamPage>{

  // camera controller
  late CameraController _camController; // 카메라 초기화에서 사용
  late Future<void> _initializeControllerFuture; // camera 초기화
  // File? _ImgCapture;

  @override
  void initState(){
    super.initState(); // 카메라 초기화 

    _camController = CameraController(
      widget.camera, ResolutionPreset.medium,
      enableAudio: false,
      );
    _initializeControllerFuture = _camController.initialize(); // controller 초기화 
  }

  @override
  void dispose() {
    // camera resource 해제
    _camController.dispose();
    super.dispose();
  }

  // 촬영 버튼 클릭 시 호출될 사진 촬영 및 저장 함수
  Future<void> _CapturePicture() async {
    try{
      await _initializeControllerFuture;
      final XFile image = await _camController.takePicture().timeout(Duration(seconds: 5));
      
      final File imageFile = File(image.path);
      // Base 64 인코딩 과정
      final bytes = await imageFile.readAsBytes();
      final base64Img = base64Encode(bytes);

      // 백엔드에 이미지 전송 함수 호출 및 반환 받기
      final response = await _sendImageToBackend(base64Img);
      // await _sendImageToBackend(base64Img);

      if (mounted){
        Navigator.push(
          context,
          MaterialPageRoute(
            // 백엔드에서 받아올 반환 값을 음악 추천 페이지로 보내기
            builder: (context) => RecomMusicPage(
              songId: response['songId'] as int,
              recommendSong: response['recommendSong'] as String,
              recommendSongUrl: response['recommendSongUrl'] as String,
            ),
          ),
          // context, MaterialPageRoute(builder: (context) => RecomMusicPage()),
        );
      }
      
      // final XFile? image = await _camController.takePicture().timeout(Duration(seconds: 5));
      // if (image == null){
      //   return;
      // }
      // else{
      //   final File imageFile = File(image.path);
      //   // Base 64 인코딩 과정
      //   final bytes = await imageFile.readAsBytes();
      //   final base64Img = base64Encode(bytes);

      //   // 백엔드에 이미지 전송 함수 호출 및 반환 받기
      //   final response = await _sendImageToBackend(base64Img);
      //   // await _sendImageToBackend(base64Img);

      //   if (mounted){
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         // 백엔드에서 받아올 반환 값을 음악 추천 페이지로 보내기
      //         builder: (context) => RecomMusicPage(
      //           songId: response['songId'] as Long,
      //           recommendSong: response['recommendSong'] as String,
      //           recommendSongUrl: response['recommendSongUrl'] as String,
      //           ),
      //         ),
      //       // context, MaterialPageRoute(builder: (context) => RecomMusicPage()),
      //     );
      //   }
      // }
    } catch (e){
      print('오류 발생 : $e');
      if (mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("오류 발생 : ${e.toString()}"),));
      }
    }
  }

  // 백엔드 전송 함수
  Future<Map<String, dynamic>> _sendImageToBackend(String base64Img) async{
    const url = 'http://192.168.142.1:8080/music';  // 백엔드 서버 주소 -> ipconfig 해서 주소 변경 바람
  
    try{
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type' : 'application/json'},
        body: jsonEncode({'image': base64Img}),
      );

      print('서버 응답 : ${response.body}'); // 백엔드 서버 응답답
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return {
          'songId': data['songId'] as int,
          'recommendSong' : data['recommendSong'] as String,
          'recommendSongUrl' : data ['recommendSongUrl'] as String,
        };
      } else {
        throw Exception('서버 오류 : ${response.statusCode}');
      }

    } on http.ClientException catch (e){
      throw Exception("네트워크 오류 발생 : ${e.message}");
    }
  }

  // 사용자가 보는 화면 - 카메라, 촬영버튼
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(child: CameraPreview(_camController)),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40, top: 16),
                  child: ElevatedButton(
                    onPressed: _CapturePicture,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const ui.Size(150, 40),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: const Text('촬영하기'),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

}