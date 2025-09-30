import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PreciseTimeLineWidget extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final Function(Duration) onSeek;

  const PreciseTimeLineWidget({
    super.key,
    required this.videoPlayerController,
    required this.onSeek,
  });

  @override
  State<PreciseTimeLineWidget> createState() {
    return _PreciseTimeLineWidgetState();
  }
}

class _PreciseTimeLineWidgetState extends State<PreciseTimeLineWidget> {
  final ScrollController _scrollController = ScrollController();
  final double _pixelsPerSecond = 100;

  void _scrollListener() {
    final newPosition = Duration(milliseconds: (_scrollController.offset / _pixelsPerSecond * 1000).round());
    widget.onSeek(newPosition);
  }

  @override
  void initState() {
    super.initState();
    widget.videoPlayerController.addListener(_syncScrollWithVideo);

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.videoPlayerController.removeListener(_syncScrollWithVideo);
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _syncScrollWithVideo() {
    final videoPosition = widget.videoPlayerController.value.position;
    final scrollPosition = videoPosition.inMilliseconds / 1000.0 * _pixelsPerSecond;
    _scrollController.animateTo(
      scrollPosition,
      duration: const Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final horizontalPadding = screenWidth / 2;

        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            final newPosition = _scrollController.offset + details.delta.dx;
            final newDuration = Duration(milliseconds: (newPosition / _pixelsPerSecond * 1000).round());
            widget.videoPlayerController.seekTo(newDuration);
          },
          onTapDown: (details) {
            final tapPosition = _scrollController.offset + details.localPosition.dx - horizontalPadding;
            final newDuration = Duration(milliseconds: (tapPosition / _pixelsPerSecond * 1000).round());
            widget.videoPlayerController.seekTo(newDuration);
          },
          child: Container(
            height: 60,
            color: Colors.black.withOpacity(0.3),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: CustomPaint(
                    size: Size(
                      (widget.videoPlayerController.value.duration.inMilliseconds / 1000.0 * _pixelsPerSecond) + screenWidth,
                      60,
                    ),
                    painter: _TimelinePainter(
                      duration: widget.videoPlayerController.value.duration,
                      pixelsPerSecond: _pixelsPerSecond,
                      horizontalPadding: horizontalPadding,
                    ),
                  ),
                ),
                Container(
                  width: 2,
                  height: 60,
                  color: const Color(0xFFFFC107),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TimelinePainter extends CustomPainter {
  final Duration duration;
  final double pixelsPerSecond;
  final double horizontalPadding;

  _TimelinePainter({
    required this.duration,
    required this.pixelsPerSecond,
    required this.horizontalPadding,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white54
      ..strokeWidth = 1.0;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final totalSeconds = duration.inMilliseconds / 1000.0;

    for (double second = 0; second <= totalSeconds; second += 0.1) {
      final x = horizontalPadding + second * pixelsPerSecond;

      // Se for um segundo inteiro (ex: 1.0, 2.0)
      if ((second * 10).round() % 10 == 0) {
        // Desenha uma marcação maior e o número do segundo
        canvas.drawLine(Offset(x, 15), Offset(x, 45), paint..strokeWidth = 2.0);

        textPainter.text = TextSpan(
          text: '${second.toInt()}s',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x - (textPainter.width / 2), 0));

      } else { // Se for um milissegundo (ex: 1.1, 1.2)
        // Desenha uma marcação menor
        canvas.drawLine(Offset(x, 25), Offset(x, 35), paint..strokeWidth = 1.0);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}