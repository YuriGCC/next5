import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isRecording = false;

  Timer? _timer;
  int _recordDuration = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // --- Init Camera Logic ---
  Future<void> _initializeCamera() async {
    // Permition before using the camera
    if (await Permission.camera.request() != PermissionStatus.granted) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Precisamos da permissão para usar a câmera!')),
      );
      return;
    }

    _cameras = await availableCameras();
    if (_cameras.isEmpty) {
      return;
    }

    _controller = CameraController(
      _cameras.first,
      ResolutionPreset.veryHigh,
      enableAudio: true,
    );

    try {
      await _controller!.initialize();
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print("Erro ao inicializar a câmera: $e");
    }
  }

  // --- Record Logic ---
  void _toggleRecording() async {
    if (!_isCameraInitialized || _controller == null) return;

    if (_isRecording) {
      // Stop record
      final file = await _controller!.stopVideoRecording();
      _stopTimer();
      setState(() { _isRecording = false; });

      // Save on gallery
      // await GallerySaver.saveVideo(file.path);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vídeo salvo na galeria: ${file.path}')),
      );

    } else {
      // Start Record
      await _controller!.startVideoRecording();
      _startTimer();
      setState(() { _isRecording = true; });
    }
  }

  // --- Timer Logic ---
  void _startTimer() {
    _recordDuration = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordDuration++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).floor().toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  // --- UI ---
  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Layer 1: Camera preview
          AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: CameraPreview(_controller!),
          ),

          // Layer 2: Inferior Control Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildControlBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildControlBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.black.withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Timer
          _isRecording
              ? Row(
            children: [
              Container(
                width: 12, height: 12,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDuration(_recordDuration),
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          )
              : const SizedBox(width: 80),

          // Record button
          GestureDetector(
            onTap: _toggleRecording,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: Icon(
                _isRecording ? Icons.stop : Icons.fiber_manual_record,
                color: _isRecording ? Colors.black : Colors.red,
                size: 40,
              ),
            ),
          ),

          // Change camera button
          IconButton(
            icon: const Icon(Icons.flip_camera_ios_outlined, color: Colors.white, size: 32),
            onPressed: _isRecording ? null : () { /* no implement */ },
          ),
        ],
      ),
    );
  }
}