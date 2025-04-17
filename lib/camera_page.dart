import 'package:flutter/material.dart';
import 'package:daisy/recommend_music_page.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';  // json data 처리 패키지 

// face detection을 위한 패키지 import
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;


class CamPage extends StatefulWidget{

  const CamPage(
    {super.key, required this.camera}
    );

    final CameraDescription camera;

  @override
  _CamState createState() => _CamState();
}

class _CamState extends State<CamPage>{

  // camera controller
  late CameraController _camController; // 카메라 초기화에서 사용
  late Future<void> _initializeControllerFuture; // camera 초기화

  // face detection
  late FaceDetector _faceDetector;

  // File? _imageFile;

  @override
  void initState(){
    super.initState(); // 카메라 초기화 

    _camController = CameraController(widget.camera, ResolutionPreset.medium,);
    _initializeControllerFuture = _camController.initialize(); // controller 초기화 
    
    // face detector 초기화 
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.accurate,
        enableContours: true,));
  }


  // 촬영 버튼 클릭 시 호출될 사진 촬영 및 저장 함수
  Future<void> _Picture() async {
    try{
      await _initializeControllerFuture;
      final XFile? image = await _camController.takePicture();

      if (image != null){
        // 얼굴 감지
        final imagePath = image.path;
        final inputImage = InputImage.fromFilePath(imagePath);
        final babyface = await _faceDetector.processImage(inputImage);
        
        if (babyface.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("얼굴을 감지하지 못했습니다."))
          );
        }

        final firstFace = babyface.first;
        final File croppedFile = await _cropAndSaveImage(  // 이미지 크롭 합수 호출
          File(imagePath),
          firstFace.boundingBox
        );

        // Base 64 인코딩 과정
        final bytes = await croppedFile.readAsBytes();
        final base64Img = base64Encode(bytes);

        // 백엔드에 이미지 전송 함수 호출
        // await _sendImageToBackend(base64Img, firstFace.baundingBox);
      }

    } catch (e){
      print('Error: $e'); 
    }
  }

  // 이미지 크롭 함수 
  Future<File> _cropAndSaveImage(File originalFile, Rect bounds) async {
    final originalImg = img.decodeImage(
      await originalFile.readAsBytes()
    )!;
    final croppedImage = img.copyCrop(
      originalImg, 
      x: bounds.left.toInt(), y: bounds.top.toInt(), 
      width: bounds.width.toInt(), height: bounds.height.toInt(),);

    // file 저장 경로 설정
    final tempDirectory = await getTemporaryDirectory();
    final file = File(
      '${tempDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await file.writeAsBytes(img.encodeJpg(croppedImage));
    return file;
  }

  // 백엔드 전송 함수
  Future<void> _sendImageToBackend(String base64Img, Rect bounds) async{
    final url = Uri.parse('http://백엔드url.com/엔드포인트');
    final response = await http.post(
      url,
      headers: {'Content-Type' : 'application/json'},
      body: jsonEncode({
        'image' : base64Img,
        'metadata' : {
          'bounding_box' : {
            'left' : bounds.left,
            'top' : bounds.top,
            'width' : bounds.width,
            'height' : bounds.height
          },
          'timestamp' : DateTime.now().toIso8601String()
        }
      })
    );

    if (response.statusCode == 200){
      Navigator.push(context, 
      MaterialPageRoute(builder: (context) => RecomMusicPage()),);
    } else{
      print("백엔드 서버에 이미지 전송을 실패하였습니다.");
    }
    // var request = http.MultipartRequest('POST', url);

  }

   @override
  void dispose() {
    // camera resource 해제
    _camController.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build (BuildContext context){
    return Scaffold(
      body: Column(
        children: <Widget>[
          FutureBuilder<void>(
            future: _initializeControllerFuture, 
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.done){
                return CameraPreview(_camController);
              } else {
                return const Center(child: CircularProgressIndicator(),);
              }
            }),
            const SizedBox(height: 20,),
          ElevatedButton(
              onPressed: () {
              // '촬영하기' 버튼 클릭 시, RecomMusicPaeg()로 이동. 이 페이지는 추천된 음악 재생 화면을 뜻함.
              // 백엔드와 연결 시, 버튼 클릭과 동시에 백엔드에 base64 인코딩하여 보내기 (추가해야 함)
              // _Picture, crop, send 함수 아직 미사용
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context)=> RecomMusicPage()),);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(150, 40)
            ),
            child: const Text('촬영하기'),
          ),
          
        ],
      ),
      // Press
    ); 
  }
}