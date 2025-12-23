import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:williamharri/src/core/component/reactive_ui/process_notifier.dart';
import 'package:williamharri/src/core/notifiers/snackbar_notifier.dart';
import 'package:williamharri/src/core/utils/helpers/handle_future_request.dart';
import 'package:williamharri/src/module/home/repo/job_repo.dart';

class PdfDownloadController extends ChangeNotifier{
  final String pdfUrl;
  PdfDownloadController(this.pdfUrl);

  Completer<File?> downloadCompleter = Completer<File?>();
  File? _file = null;
  File? get file => _file;

  ProcessStatusNotifier processStatusNotifier = ProcessStatusNotifier(
    initialStatus: EnabledStatus()
  );

  void downloadPdf({SnackbarNotifier? snackbarNotifier}) async {
    handleFutureRequest(
      futureRequest: () => Get.find<JobRepo>().downloadPdf(pdfUrl),
      processStatusNotifier: processStatusNotifier,
      onSuccess: (file) {
        downloadCompleter.complete(file);
        _file = file;
        notifyListeners();
      },
      successSnackbarNotifier: snackbarNotifier
    );
  }
}  