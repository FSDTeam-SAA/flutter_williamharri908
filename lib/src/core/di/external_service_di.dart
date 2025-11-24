import 'package:get/get.dart';
import 'package:williamharri/src/core/constants/api_endpoints.dart';
import 'package:williamharri/src/core/services/app_pigeon/app_pigeon.dart';
import 'package:williamharri/src/core/services/app_pigeon/refresh_token_manager.dart';

void externalServiceDI() {
  // Initialize other external services here
  Get.put(AppPigeon(
    RefreshTokenManager(ApiEndpoints.refreshToken),
    baseUrl: ApiEndpoints.baseUrl,
  ));
}