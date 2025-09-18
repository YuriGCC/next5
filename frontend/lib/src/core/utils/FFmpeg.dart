import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class VideoEditScreen extends StatelessWidget {
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

  void _trimVideo() async {
    String inputFilePath = 'path/to/input/video.mp4';
    String outputFilePath = 'path/to/output/video.mp4';

    // Comando FFmpeg para cortar o vídeo
    String command = '-i $inputFilePath -ss 00:00:10 -to 00:00:20 -c copy $outputFilePath';

    await _flutterFFmpeg.execute(command);
    print('Video trimmed successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Video')),
      body: Center(
        child: ElevatedButton(
          onPressed: _trimVideo,
          child: Text('Trim Video'),
        ),
      ),
    );
  }
}
