import 'package:williamharri/src/core/base/api_handler/request.dart';
import 'package:williamharri/src/core/constants/api_endpoints.dart';
import 'package:williamharri/src/core/services/app_pigeon/app_pigeon.dart';
import 'package:williamharri/src/module/home/model/job_cart_model.dart';
import 'package:williamharri/src/module/home/repo/job_repo.dart';

base class JobRepoImpl extends JobRepo {
  JobRepoImpl({required this.appPigeon});
  final AppPigeon appPigeon;

  @override
FutureRequest<List<JobModel>> getJobs(JobModel param) async {
  return await asyncTryCatch(
    tryFunc: () async {
      final response = await appPigeon.get(ApiEndpoints.jobList);
      final body = response.data;

      final jobs = (body['data']['results'] as List)
          .map((e) => JobModel.fromJson(e))
          .toList();

      return jobs;
    },
  );
}

  @override
  FutureRequest<List<JobModel>> getStaffJobs(JobModel param) async {
    return await asyncTryCatch(
    tryFunc: () async {
      final response = await appPigeon.get(ApiEndpoints.listAssignedJobsStaffView);
      final body = response.data;

      final jobs = (body['data']['results'] as List)
          .map((e) => JobModel.fromJson(e))
          .toList();

      return jobs;
    },
  );
  }

}
