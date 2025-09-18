import 'package:flutter/material.dart';
import 'package:video_trimmer/video_trimmer.dart';

class TrimVideoScreen extends StatefulWidget {
  @override
  _TrimVideoScreenState createState() => _TrimVideoScreenState();
}

class _TrimVideoScreenState extends State<TrimVideoScreen> {
  final Trimmer _trimmer = Trimmer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trim Video')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _trimmer.loadVideo(videoFile: 'path_to_video');
            // Adicionar lógica de corte aqui
          },
          child: Text('Trim Video'),
        ),
      ),
    );
  }
}
