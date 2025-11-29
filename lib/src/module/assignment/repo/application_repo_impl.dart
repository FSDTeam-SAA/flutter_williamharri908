import 'package:williamharri/src/core/base/api_handler/request.dart';
import 'package:williamharri/src/core/base/api_handler/success.dart';
import 'package:williamharri/src/core/constants/api_endpoints.dart';
import 'package:williamharri/src/core/services/app_pigeon/app_pigeon.dart';
import 'package:williamharri/src/module/assignment/model/get_my_scaffold_model.dart';
import 'package:williamharri/src/module/assignment/model/my_jobs_manager_model.dart';
import 'package:williamharri/src/module/assignment/model/submitit_scaffold.dart';
import 'package:williamharri/src/module/assignment/model/update_staff_scafold.dart';
import 'package:williamharri/src/module/assignment/repo/application_repo.dart';

base class SubmitRepoImpl extends SubmitRepo {
  final AppPigeon appPigeon;
  SubmitRepoImpl({required this.appPigeon});

  @override
  FutureRequest<Success> submititScaffold(SubmititScaffoldModel param) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.submitScaffold,
          data: param.toJson(),
        );
        return Success(message: extractSuccessMessage(response));
      },
    );
  }

  @override
  FutureRequest<List<GetMyScaffoldModel>> myScaffoldList() async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.get(ApiEndpoints.myScaffoldList);
        final body = response.data;

        final jobs = (body['data']['results'] as List)
            .map((e) => GetMyScaffoldModel.fromJson(e))
            .toList();

        return jobs;
      },
    );
  }

  @override
  FutureRequest<List<JobModelManager>> myJobsManager() async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.get(ApiEndpoints.myJobs);
        final body = response.data;

        final jobs = (body['data']['results'] as List)
            .map((e) => JobModelManager.fromJson(e))
            .toList();

        return jobs;
      },
    );
  }

  @override
  FutureRequest<UpdateStaffScafold> scaffoldUpdate(
    String id,
    UpdateStaffScafold param,
  ) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.patch(
          ApiEndpoints.scaffoldUpdate(id),
          data: param.toJson(),
        );
        return UpdateStaffScafold.fromJson(
          response.data['data'],
        );
      },
    );
  }
}
