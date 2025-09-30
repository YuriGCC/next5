import 'package:flutter/material.dart';
import 'package:frontend/features/video_area/widgets/list_archives_widget.dart';
import 'package:frontend/features/enums/record_type.dart';

class VideoAreaScreen extends StatefulWidget {
  @override
  State<VideoAreaScreen> createState() {
    return _VideoAreaScreenState();
  }
}

class _VideoAreaScreenState extends State<VideoAreaScreen> {
   late List<ListVideoArchivesWidget> videos = _generateArchives();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Meus vídeos'),
        Expanded(
          child: ListView.builder(
            itemCount: videos.length,
            itemBuilder: (BuildContext context, int index) {
              return videos[index];
            },
          ),
        ),
      ],
    );
  }

  List<ListVideoArchivesWidget> _generateArchives() {
    return [
      ListVideoArchivesWidget(recordType: RecordType.RECORD, archivePath: 'C:/nome'),
      ListVideoArchivesWidget(recordType: RecordType.RECORD, archivePath: 'C:/nome'),
      ListVideoArchivesWidget(recordType: RecordType.RECORD, archivePath: 'C:/nome'),
      ListVideoArchivesWidget(recordType: RecordType.RECORD, archivePath: 'C:/nome'),
      ListVideoArchivesWidget(recordType: RecordType.RECORD, archivePath: 'C:/nome'),
      ListVideoArchivesWidget(recordType: RecordType.RECORD, archivePath: 'C:/nome'),
      ListVideoArchivesWidget(recordType: RecordType.RECORD, archivePath: 'C:/nome'),
      ListVideoArchivesWidget(recordType: RecordType.RECORD, archivePath: 'C:/nome'),
      ListVideoArchivesWidget(recordType: RecordType.RECORD, archivePath: 'C:/nome'),
      ListVideoArchivesWidget(recordType: RecordType.RECORD, archivePath: 'C:/nome'),

    ];
  }


}