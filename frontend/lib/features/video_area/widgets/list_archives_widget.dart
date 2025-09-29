import 'package:flutter/material.dart';
import 'package:frontend/features/enums/record_type.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:io';
import 'dart:typed_data';

class ListVideoArchivesWidget extends StatelessWidget {
  final RecordType recordType;
  final String archiveName;

  const ListVideoArchivesWidget({
    super.key,
    required this.recordType,
    required this.archiveName,
  });

  @override
  Widget build(BuildContext context) {
    final IconData displayIcon;
    final String subtitleText;

    switch (recordType) {
      case RecordType.RECORD:
        displayIcon = Icons.videocam;
        subtitleText = 'Gravação Completa';
        break;
      case RecordType.CLIP:
        displayIcon = Icons.content_cut;
        subtitleText = 'Clipe Gerado';
        break;
    }


    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(displayIcon, size: 40,),
            title: Text(archiveName),
            subtitle: Text(subtitleText),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  image: DecorationImage(
                    image: AssetImage('/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Uint8List?> generateThumbnailFromAsset(String assetPath) async {
    // Find a temporary directory in the device
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/${assetPath.split('/').last}');

    // Load bytes in a temporary file in the device
    final ByteData byteData = await rootBundle.load(assetPath);
    // Write the bytes  in a temporary file on device
    await tempFile.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    // Generate thumbnail from temporary file PATH
    final thumbnailBytes = await VideoThumbnail.thumbnailData(
      video: tempFile.path,
      imageFormat: ImageFormat.PNG,
      maxWidth: 200,
      quality: 50
    );

    // Delete the file after use
    await tempFile.delete();

    return thumbnailBytes;
  }

  void _goEdit() {}
}