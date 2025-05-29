import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:daisy/camera_page.dart';
import 'package:daisy/playlist_page.dart';
import 'package:daisy/setting_page.dart';

class HomePage extends StatefulWidget {
  // final CameraDescription camera;
  final int initInx; // 로그인 시, 카메라 페이지가 기본으로 오도록 하기 위함. 

  const HomePage({super.key, required this.initInx,});

  @override
  _HomeState createState() => _HomeState(); 
}

class _HomeState extends State<HomePage>{

  late int _curInx;
  
  @override
  void initState() {
    super.initState();
    _curInx = widget.initInx;
    _initCamera();
  } // 네비게이션 메뉴들의 인덱스 지정 및 색상 변경을 위함

  List<Widget> _navPages = [];
  late CameraDescription _camera;
  // final _navPages = [
  //   PlayListPage(), CamPage(), SettingPage(),
  // ];

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty){
      _camera = cameras.first;
      setState(() {
        _navPages=[
          const PlayListPage(),
          CamPage(camera: _camera),
          const SettingPage(),
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: _navPages[_curInx],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // 아이콘과 라벨이 밀려 안보이는 것을 방지하기 위함
        currentIndex: _curInx,
        onTap: (index) => setState(() {
         _curInx = index; 
        }),
        items: [
          // 1. 음악 리스트
          BottomNavigationBarItem(
            icon: Icon(Icons.queue_music,
            // 클릭 시 색상 변경 설정
            color: _curInx == 0 ? const Color.fromARGB(255, 9, 149, 14) : Colors.grey),
            label: '리스트',
          ),
            // 2. 카메라 
          BottomNavigationBarItem(
            icon: Icon(Icons.camera,
            // 클릭 시 색상 변경 설정
            color: _curInx == 1 ? const Color.fromARGB(255, 9, 149, 14) : Colors.grey),
            label: '촬영',
          ),
            // 3. 설정 페이지
          BottomNavigationBarItem(
            icon: Icon(Icons.settings,
            // 클릭 시 색상 변경 설정
            color: _curInx == 2 ? const Color.fromARGB(255, 9, 149, 14) : Colors.grey),
            label: '설정',
          ),
        ],
      ),
    );
  }
}