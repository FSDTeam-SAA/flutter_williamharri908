import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:williamharri/src/core/component/reactive_ui/process_notifier.dart';
import 'package:williamharri/src/module/home/controller/pdf_download_controller.dart';


class JobPdfViewerScreen extends StatefulWidget {
  final String title;
  final String url;

  const JobPdfViewerScreen({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<JobPdfViewerScreen> createState() => _JobPdfViewerScreenState();
}

class _JobPdfViewerScreenState extends State<JobPdfViewerScreen> {
  late final PDFViewController pdfController;
  late final PdfDownloadController pdfDownloadController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint(widget.url);
    pdfDownloadController = PdfDownloadController(widget.url);
    pdfDownloadController.downloadPdf();
  }

  
  

  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        // default back arrow will pop and return to JobDetailsUi
      ),
      body: ListenableBuilder(
        listenable: pdfDownloadController.processStatusNotifier,
        builder: (context, child) {
          final processNotifier = pdfDownloadController.processStatusNotifier;
          if(processNotifier.status is LoadingStatus) {
            return Center(child: CircularProgressIndicator());
          } else if(processNotifier.status is SuccessStatus) {
            if(pdfDownloadController.file == null) {
              return Center(child: Text('No file found'));
            }
            return PDFView(
              filePath: pdfDownloadController.file!.path,
            );
          } else if(processNotifier.status is ErrorStatus) {
            return Center(child: Text('Error: ${processNotifier.status.message}'));
          }
          return Container();
        },)

    );
  }
}
