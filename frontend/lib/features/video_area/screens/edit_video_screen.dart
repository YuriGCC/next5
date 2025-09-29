import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class FutsalVideoPlayer extends StatefulWidget {
  final bool isNetwork;
  final String path;

  const FutsalVideoPlayer({super.key, required this.path, this.isNetwork = false});

  @override
  State<FutsalVideoPlayer> createState() => _FutsalVideoPlayerState();
}

class _FutsalVideoPlayerState extends State<FutsalVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    if (widget.isNetwork) {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.path));
    } else {
      _videoPlayerController = VideoPlayerController.file(File(widget.path));
    }

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(controller: _chewieController);
  }
}