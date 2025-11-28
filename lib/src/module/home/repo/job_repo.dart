import 'package:williamharri/src/core/base/api_handler/base_repository.dart';
import 'package:williamharri/src/core/base/api_handler/request.dart';
import 'package:williamharri/src/module/home/model/job_cart_model.dart';

abstract base class JobRepo extends BaseRepository {
  FutureRequest<List<JobModel>> getJobs();

  FutureRequest<List<JobModel>> getStaffJobs();

  
}
