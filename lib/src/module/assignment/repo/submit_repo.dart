import 'package:williamharri/src/core/base/api_handler/base_repository.dart';
import 'package:williamharri/src/core/base/api_handler/request.dart';
import 'package:williamharri/src/module/assignment/model/get_my_scaffold_model.dart';
import 'package:williamharri/src/module/assignment/model/submitit_scaffold.dart';

abstract base class SubmitRepo extends BaseRepository {
  FutureRequest submititScaffold(SubmititScaffoldModel param);

  FutureRequest<List<GetMyScaffoldModel>> myScaffoldList();
}
