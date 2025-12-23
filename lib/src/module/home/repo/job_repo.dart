import 'dart:io';

import 'package:williamharri/src/core/api_handler/base_repository.dart';
import 'package:williamharri/src/core/api_handler/request.dart';
import 'package:williamharri/src/core/api_handler/success.dart';
import 'package:williamharri/src/module/home/model/job_cart_model.dart';
import 'package:williamharri/src/module/home/model/create_job_model.dart';

abstract base class JobRepo extends BaseRepository {
  FutureRequest<List<JobModel>> getJobs();

  FutureRequest<List<JobModel>> getStaffJobs();

  FutureRequest<JobModel> createJob(CreateJobModel data);

  FutureRequest<JobModel> updateJob(String id, CreateJobModel data);

  FutureRequest<void> deleteJob(String id);

  FutureRequest<Success<File>> downloadPdf(String url);
  
}
