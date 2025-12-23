 import 'package:williamharri/src/core/api_handler/success.dart';
import 'package:williamharri/src/core/utils/utils.dart';

import '../../api_handler/failure.dart';
import '../../component/reactive_ui/process_notifier.dart';
import '../../notifiers/snackbar_notifier.dart';
import '../../services/debug/debug_service.dart';

Future<T?> handleFutureRequest<T>({
    required FutureRequest<Success<T>> Function() futureRequest,
    Debugger? debugger,
    ProcessStatusNotifier? processStatusNotifier,
    SnackbarNotifier? errorSnackbarNotifier,
    SnackbarNotifier? successSnackbarNotifier,
    void Function(T data)? onSuccess,
    void Function(DataCRUDFailure failure)? onError,
  }) async{
    final either = await futureRequest();
    return either.fold(
      (failure) {
        debugger?.dekhao(failure.toString());
        processStatusNotifier?.setEnabled();
        errorSnackbarNotifier?.notifyError(message: failure.uiMessage);
        if(onError != null) onError(failure);
        return null;
      },
      (result) {
        processStatusNotifier?.setSuccess(
          message: (result as Success).message
        );
        successSnackbarNotifier?.notifySuccess(
          message: (result as Success).message
        );
        if(onSuccess != null && result.data is T) onSuccess(result.data as T);
        debugger?.dekhao("Success:: ${(result as Success).message}");
        return result.data;
      },
    );
  }