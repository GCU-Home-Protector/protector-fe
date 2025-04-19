import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
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
  File? _ImgCapture;

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
      final XFile? image = await _camController.takePicture();

      if (image != null){
        final File imageFile = File(image.path);
        // Base 64 인코딩 과정
        final bytes = await imageFile.readAsBytes();
        final base64Img = base64Encode(bytes);

        // 백엔드에 이미지 전송 함수 호출
        // await _sendImageToBackend(base64Img);

        if (mounted){
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => RecomMusicPage()),
          );
        }
      }
    } catch (e){
      if (mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("이미지 촬영에 실패하였습니다. ${e.toString()}"),));
      }
    }
  }

  // 백엔드 전송 함수
  Future<void> _sendImageToBackend(String base64Img) async{
    final url = Uri.parse('http://백엔드url.com/엔드포인트');  
    http.MultipartRequest('POST', url);
    
    try{
      final response = await http.post(
        url,
        headers: {'Content-Type' : 'application/json'},
        body: jsonEncode({'image': base64Img}),
      );

      if (response.statusCode != 200) {
        throw Exception('서버 응답 없음 : ${response.statusCode}');
      }

    } on http.ClientException catch (e){
      throw Exception("${e.message}");
    }
  }

  // 사용자가 보는 화면 - 카메라, 촬영버튼
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done){
            return Stack(
              children: [
                CameraPreview(_camController),
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: _CapturePicture,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 40),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15,
                        ),
                        ),
                        child: const Text("촬영하기"),
                      ),
                    ),
                  ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      )
    );
  }
}