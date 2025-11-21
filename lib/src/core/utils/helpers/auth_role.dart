import 'package:get/utils.dart';

import '../../services/debug/debug_service.dart';
import '../../services/app_pigeon/app_pigeon.dart';

enum AccountType {
  driver("driver"),
  doctor("doctor"),
  restaurantService("restaurantService"),
  beautyAndSpaService("beautyAndSpaService"),
  constractionWorker("constructionWorker"),
  autoRepairService("autoRepairService"),
  user("user"), 
  unknown("");
  final String label;

  const AccountType(this.label);

  
  factory AccountType.fromString(String name) {
    final AccountType? parsedType = AccountType.values.firstWhereOrNull(
      (element) => element.label == name,
    );
    return parsedType ?? AccountType.unknown;
  }
}

extension ExtraAuth on Auth {
  String get userId => data["userId"];
  AccountType get accountType {
    try {
      if(data["role"] == null) return AccountType.unknown;
        AuthDebugger().dekhao("has role");
        switch (data["role"]) {
          case "provider":
            return AccountType.driver;
          case "user":
            return AccountType.user;
          default:
            return AccountType.unknown;
        }
    } catch (e) {
      return AccountType.unknown;
    }
  }
}