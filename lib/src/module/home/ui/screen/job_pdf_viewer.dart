import 'package:flutter/material.dart';


class JobPdfViewerScreen extends StatelessWidget {
  final String title;
  final String url;

  const JobPdfViewerScreen({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        // default back arrow will pop and return to JobDetailsUi
      ),
      // body: SfPdfViewer.network(url),
    );
  }
}
