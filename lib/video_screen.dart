import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:sagae/core/util/image_b64_decoder.dart';
import 'package:video_player/video_player.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

class MovieTheaterBody extends StatefulWidget {
  final String encodedBytes;

  const MovieTheaterBody({Key key, this.encodedBytes}) : super(key: key);

  @override
  _MovieTheaterBodyState createState() => _MovieTheaterBodyState();
}

class _MovieTheaterBodyState extends State<MovieTheaterBody> {
  Future<VideoPlayerController> _futureController;
  VideoPlayerController _controller;

  Future<VideoPlayerController> createVideoPlayer() async {
    final encodedStr = widget.encodedBytes;
    Uint8List bytes = base64.decode(encodedStr);
    String dir = (await getApplicationDocumentsDirectory()).path;

    File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".mp4");

    await file.writeAsBytes(bytes);

    final VideoPlayerController controller = VideoPlayerController.file(file);
    await controller.initialize();
    await controller.setLooping(true);
    return controller;
  }

  @override
  void initState() {
    _futureController = createVideoPlayer();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _futureController,
        builder: (context, snapshot) {
          //UST: 05/2021 - MovieTheaterBody - id:11 - 2pts - Criação
          if (snapshot.connectionState == ConnectionState.done) {
            _controller = snapshot.data as VideoPlayerController;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                const SizedBox(
                  height: 50,
                ),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        // If the video is paused, play it.
                        _controller.play();
                      }
                    });
                  },
                  backgroundColor: Colors.green[700],
                  child: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                )
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
