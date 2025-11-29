import 'package:williamharri/src/core/api_handler/request.dart';
import 'package:williamharri/src/core/constants/api_endpoints.dart';
import 'package:williamharri/src/core/services/app_pigeon/app_pigeon.dart';
import 'package:williamharri/src/module/home/model/job_cart_model.dart';
import 'package:williamharri/src/module/home/repo/job_repo.dart';
import 'package:williamharri/src/module/home/model/create_job_model.dart';
import 'package:williamharri/src/module/home/repo/job_repo.dart';

base class JobRepoImpl extends JobRepo {
  JobRepoImpl({required this.appPigeon});

  final AppPigeon appPigeon;

  @override
  FutureRequest<List<JobModel>> getJobs() async {
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
  FutureRequest<List<JobModel>> getStaffJobs() async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.get(
          ApiEndpoints.listAssignedJobsStaffView,
        );
        final body = response.data;

        final jobs = (body['data']['results'] as List)
            .map((e) => JobModel.fromJson(e))
            .toList();

        return jobs;
      },
    );
  }


  @override
  FutureRequest<JobModel> createJob(CreateJobModel data) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.createJob, // POST /jobs/
          data: data.toJson(),
        );

        final body = response.data;
        final job = JobModel.fromJson(body['data']);
        return job;
      },
    );
  }

  @override
  FutureRequest<JobModel> updateJob(String id, CreateJobModel data) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.patch(
          ApiEndpoints.updateJob(id), // PATCH /jobs/{id}
          data: data.toJson(),
        );

        final body = response.data;
        final job = JobModel.fromJson(body['data']);
        return job;
      },
    );
  }

  @override
  FutureRequest<void> deleteJob(String id) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.delete(
          ApiEndpoints.deleteJob(id), // DELETE /jobs/{id}
        );

        // Optional: check response if you want
        final body = response.data;
        final success = body['success'] == true;
        if (!success) {
          // You can throw an error here if asyncTryCatch expects that
          throw Exception(body['message'] ?? 'Failed to delete job');
        }

        // nothing to return (void)
        return;
      },
    );
  }



}
