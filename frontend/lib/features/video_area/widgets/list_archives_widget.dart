import 'package:flutter/material.dart';
import 'package:frontend/features/enums/record_type.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:go_router/go_router.dart';

class ListVideoArchivesWidget extends StatelessWidget {
  final RecordType recordType;
  final String archivePath;

  const ListVideoArchivesWidget({
    super.key,
    required this.recordType,
    required this.archivePath,
  });

  @override
  Widget build(BuildContext context) {
    final IconData displayIcon;
    final String subtitleText;

    switch (recordType) {
      case RecordType.RECORD:
        displayIcon = Icons.videocam;
        subtitleText = 'Gravação';
        break;
      case RecordType.CLIP:
        displayIcon = Icons.content_cut;
        subtitleText = 'Clipe';
        break;
    }


    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(displayIcon, size: 40),
            title: Text(archivePath),
            subtitle: Text(subtitleText),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  context.push(
                    '/edit',
                    extra: {
                      'path': 'archivePath',
                      'isNetwork': false,
                    },
                  );
                },
                child: FutureBuilder<Uint8List?>(
                  future: generateThumbnailFromAsset('assets/videos/video.mp4'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        width: 150,
                        height: 150,
                        color: Colors.grey.shade800,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                      return Container(
                        width: 150,
                        height: 150,
                        color: Colors.grey.shade800,
                        child: const Center(child: Icon(Icons.error_outline, color: Colors.red, size: 50)),
                      );
                    }

                    return Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: MemoryImage(snapshot.data!),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  /// Generates a video thumbnail from a video file located in the app's assets.
  ///
  /// This function works by copying the asset file to a temporary directory on the
  /// device's file system, as the thumbnail generator requires a direct file path.
  ///
  /// [assetPath] The full path to the video asset (e.g., 'assets/videos/intro.mp4').
  /// Returns a [Future<Uint8List?>] containing the image bytes of the thumbnail,
  /// or null if an error occurs.
  Future<Uint8List?> generateThumbnailFromAsset(String assetPath) async {
    try {
      // 1. Get the temporary directory from the device's file system.
      // This is a safe location to store files temporarily.
      final tempDir = await getTemporaryDirectory();

      // 2. Create a unique file name to prevent race conditions
      // when this function is called multiple times in parallel.
      final String uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}_${assetPath.split('/').last}';
      final tempFile = File('${tempDir.path}/$uniqueFileName');

      // 3. Load the video file from the app's asset bundle into memory as bytes.
      final ByteData byteData = await rootBundle.load(assetPath);

      // 4. Write the bytes to the temporary file on the device.
      await tempFile.writeAsBytes(
          byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes)
      );

      // 5. Generate the thumbnail from the temporary file's path.
      // The native plugin can now access the file.
      final thumbnailBytes = await VideoThumbnail.thumbnailData(
        video: tempFile.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 200,
        quality: 50,
      );

      // 6. Clean up: delete the temporary file after use to save space.
      await tempFile.delete();

      // 7. Return the generated thumbnail image bytes.
      return thumbnailBytes;

    } catch (e) {
      print('Error generating thumbnail from asset: $e');
      return null;
    }
  }
}