import 'package:dartz/dartz.dart';

import 'failure.dart';

typedef Request<T> = Either<DataCRUDFailure, T>;

typedef FutureRequest<T> = Future<Request<T>>;