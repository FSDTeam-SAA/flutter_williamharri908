import 'package:williamharri/src/core/base/api_handler/base_repository.dart';
import 'package:williamharri/src/core/base/api_handler/request.dart';
import 'package:williamharri/src/module/assignment/model/get_my_scaffold_model.dart';
import 'package:williamharri/src/module/assignment/model/my_jobs_manager_model.dart';
import 'package:williamharri/src/module/assignment/model/submitit_scaffold.dart';
import 'package:williamharri/src/module/assignment/model/update_staff_scafold.dart';

import '../../../core/base/api_handler/success.dart';

abstract base class ApplicationRepo extends BaseRepository {
  FutureRequest submititScaffold(SubmititScaffoldModel param);

  FutureRequest<List<GetMyScaffoldModel>> myScaffoldList();

  FutureRequest<List<JobModelManager>> myJobsManager();

  FutureRequest<Success> scaffoldUpdate(
    UpdateStaffScafoldParam param,
  );
}
