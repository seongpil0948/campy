import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoW extends StatefulWidget {
  final VideoPlayerController controller;
  @override
  _VideoWState createState() => _VideoWState();

  VideoW({required this.controller});
}

class _VideoWState extends State<VideoW> {
  @override
  void initState() {
    super.initState();
    widget.controller
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    var _controller = widget.controller;
    if (_controller.value.isInitialized) {
      _controller.play();
      return InkWell(
        onTap: () => _controller.value.isPlaying
            ? _controller.pause()
            : _controller.play(),
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      );
    } else {
      return Text("SomeThingWrong In Video Widget");
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.dispose();
  }
}
