import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:chewie_video_demo_corner/app/theme.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayerDemo extends StatefulWidget {
  const PlayerDemo({
    Key? key,
    this.title = '',
  }) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _PlayerDemoState();
  }
}

class _PlayerDemoState extends State<PlayerDemo> {
  TargetPlatform? _platform;
  late VideoPlayerController _videoPlayerController1;
  ChewieController? _chewieController;
  int? bufferDelay;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  List<String> srcs = [
    "https://assets.mixkit.co/videos/preview/mixkit-spinning-around-the-earth-29351-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4"
  ];

  Future<void> initializePlayer() async {
    _videoPlayerController1 =
        VideoPlayerController.network(srcs[currPlayIndex]);
    await Future.wait([
      _videoPlayerController1.initialize(),
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    // 자막 세팅
    final subtitles = [
      Subtitle(
        index: 0,
        start: Duration.zero,
        end: const Duration(seconds: 10),
        text: const TextSpan(
          children: [
            TextSpan(
              text: '자막1',
              style: TextStyle(color: Colors.red, fontSize: 22),
            ),
          ],
        ),
      ),
    ];

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: true,
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,

      // 설정 셋업
      additionalOptions: (context) {
        return <OptionItem>[
          OptionItem(
            onTap: toggleVideo,
            iconData: Icons.live_tv_sharp,
            title: '비디오 전환',
          ),
        ];
      },
      // 자막 세팅
      subtitle: Subtitles(subtitles),
      subtitleBuilder: (context, dynamic subtitle) => Container(
        padding: const EdgeInsets.all(10.0),
        child: subtitle is InlineSpan
            ? RichText(
                text: subtitle,
              )
            : Text(
                subtitle.toString(),
                style: const TextStyle(color: Colors.black),
              ),
      ),

      // controls 숨김 타이머
      hideControlsTimer: const Duration(seconds: 3),

      // 플레이어 옵션:
      showControls: true,

      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.red,
        backgroundColor: Colors.black,
        bufferedColor: Colors.grey,
      ),
      placeholder: Container(
        color: Colors.black,
      ),
      // autoInitialize: true,
    );
  }

  int currPlayIndex = 0;

  Future<void> toggleVideo() async {
    await _videoPlayerController1.pause();
    currPlayIndex += 1;
    if (currPlayIndex >= srcs.length) {
      currPlayIndex = 0;
    }
    await initializePlayer();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      theme: AppTheme.dark.copyWith(
        platform: _platform ?? Theme.of(context).platform,
      ),
      home: Scaffold(
        appBar: null,
        body: Column(
          children: <Widget>[
            Expanded(
                child: Center(
              child: _chewieController != null &&
                      _chewieController!.videoPlayerController.value.isInitialized
                  ? Chewie(
                      controller: _chewieController!,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text('로딩중..'),
                      ],
                    ),
            )),
            TextButton(
              onPressed: () {
                _chewieController?.enterFullScreen();
              },
              child: const Text('Fullscreen'),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        if (_platform == TargetPlatform.windows) {
                          _platform = Theme.of(context).platform;
                        } else {
                          _platform = TargetPlatform.windows;
                        }
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text("커스텀 컨트롤"),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                      onPressed: toggleVideo, child: const Text('비디오 전환')),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
