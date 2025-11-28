import 'package:williamharri/src/core/base/api_handler/request.dart';
import 'package:williamharri/src/core/base/api_handler/success.dart';
import 'package:williamharri/src/core/constants/api_endpoints.dart';
import 'package:williamharri/src/core/services/app_pigeon/app_pigeon.dart';
import 'package:williamharri/src/module/assignment/model/submitit_scaffold.dart';
import 'package:williamharri/src/module/assignment/repo/submit_repo.dart';
import 'package:williamharri/src/module/home/model/job_cart_model.dart';

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
  FutureRequest<List<JobModel>> myScaffoldList() async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.get(ApiEndpoints.myScaffoldList);
        final body = response.data;

        final jobs = (body['data']['results'] as List)
            .map((e) => JobModel.fromJson(e))
            .toList();

        return jobs;
      },
    );
  }
}
