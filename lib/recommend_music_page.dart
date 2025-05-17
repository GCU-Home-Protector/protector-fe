// import 'dart:ffi';

import 'package:flutter/material.dart';
// import 'package:image/image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RecomMusicPage extends StatefulWidget{
  // final String base64String;
  // const RecomMusicPage({Key? key, required this.base64String}) : super (key: key);

  final int songId;
  final String recommendSong;
  final String recommendSongUrl;

  const RecomMusicPage({
    super.key,
    required this.songId,
    required this.recommendSong,
    required this.recommendSongUrl,
  });

  @override
  State<RecomMusicPage> createState() => _RecomMusicState();  
}

class _RecomMusicState extends State<RecomMusicPage>{
  // youtube player 선언
  late YoutubePlayerController _youtubeController;
  
  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.recommendSongUrl) ?? '';
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true, // 자동 재생
        mute: true,
      ), 
    );
  }

  @override
  Widget build (BuildContext context){
    // base64 인코딩된 string이 길다면 앞부분만 간략히 표시
    // final displayString = widget.base64String.length > 200
    // / ? widget.base64String.substring(0, 200) + '...'
    // : widget.base64String;

    return Scaffold(
      appBar: AppBar(title: Text(widget.recommendSong)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            YoutubePlayer(
              controller: _youtubeController,
              showVideoProgressIndicator: true,
            ),
            ElevatedButton(onPressed: () => _youtubeController.unMute(), 
            child: const Text('음소거 해제'),
            ),
          ],),
        )
      // 실제 : 백엔드에서 반환하는 음악 화면
    ); 
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }
}