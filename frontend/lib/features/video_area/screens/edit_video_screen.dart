import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:frontend/features/video_area/widgets/precise_timeline_widget.dart';

class EditVideoScreen extends StatefulWidget {
  final bool isNetwork;
  final String path;


  const EditVideoScreen({super.key, required this.path, this.isNetwork = false});

  @override
  State<EditVideoScreen> createState() => _EditVideoScreenState();
}

class _EditVideoScreenState extends State<EditVideoScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  late String timer;

  void _listener() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    // if (widget.isNetwork) {
    //   _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.path));
    // } else {
    //   _videoPlayerController = VideoPlayerController.file(File(widget.path));
    // }

    _videoPlayerController = VideoPlayerController.asset(
        'assets/videos/video.mp4'
    );

    _videoPlayerController.addListener(_listener);

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
    );

    _videoPlayerController.initialize().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.removeListener(_listener);
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  String _formatPreciseDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String threeDigits(int n) => n.toString().padLeft(3, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final milliseconds = threeDigits(duration.inMilliseconds.remainder(1000));
    return "$minutes:$seconds.$milliseconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modo Edição'),),
      body: Column(
        children: [
          _videoPlayerController.value.isInitialized
              ?
                AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: Chewie(controller: _chewieController),
                )
              :
                const AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Center(child: CircularProgressIndicator(),),
                ),
          const SizedBox(height: 24,),
          PreciseTimeLineWidget(
              videoPlayerController: _videoPlayerController,
              onSeek: (newDuration) {
                if (!_videoPlayerController.value.isPlaying) {
                  _videoPlayerController.seekTo(newDuration);
                }
              },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _formatPreciseDuration(_videoPlayerController.value.position),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(height: 24,),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: const Text('nome arquivo'),
          ),
          const SizedBox(height: 8,),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Time line',
              style: TextStyle(fontSize: 16),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Gerar Clip'),
            ),
          ),
        ],
      ),
    );
  }
}