// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';

// class PdfViewerScreen extends StatelessWidget {
//   final String pdfUrl;
//   final String title;

//   const PdfViewerScreen({super.key, required this.pdfUrl, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//       ),
//       body: PDFView(
//         filePath: pdfUrl,
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PdfViewerScreen extends StatelessWidget {
  final String url;
  final String title;

  const PdfViewerScreen({super.key, required this.url, required this.title});

  @override
  Widget build(BuildContext context) {
    final pdfUrl = "https://docs.google.com/gview?embedded=true&url=$url";

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(pdfUrl)),
      ),
    );
  }
}

