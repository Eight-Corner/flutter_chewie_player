import 'package:flutter/material.dart';
import 'package:flutter_test_app/component/chewie_list_item.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'video player chewie package Demo',
      theme: ThemeData.light().copyWith(
        platform: TargetPlatform.iOS,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('video player chewie package Demo'),
      ),
      body: ListView(
        children: <Widget>[
          ChewieListItem(
            videoPlayerController: VideoPlayerController.asset(
              'instagram_video.mp4',
            ),
            looping: true,
          ),
          ChewieListItem(
              videoPlayerController: VideoPlayerController.network(
                  'https://player.live24.app/vod/2420521/10364'),
              looping: true)
        ],
      ),
    );
  }
}
