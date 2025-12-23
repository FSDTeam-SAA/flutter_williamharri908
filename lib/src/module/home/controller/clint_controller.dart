import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/module/home/model/clint_model.dart';

class ClientController extends GetxController {
  final Dio dio = Dio();

  var isLoading = false.obs;
  var clients = <ClientModel>[].obs;
  var selectedClient = Rxn<ClientModel>();

  @override
  void onInit() {
    super.onInit();
    fetchClients();
  }

  Future<void> fetchClients() async {
    try {
      isLoading(true);
      final response = await dio.get(
        'https://api.williamjamesscaffoldingapp.com/api/clients',
      );

      final List results = response.data['data']['results'];
      clients.value =
          results.map((e) => ClientModel.fromJson(e)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load clients');
    } finally {
      isLoading(false);
    }
  }

  void selectClient(ClientModel? client) {
    selectedClient.value = client;
  }
}
