import 'package:dio/dio.dart';
import 'package:shipment/models/shipment_model.dart';

class ApiServices {
  static const String baseUrl = 'http://192.168.18.223:8000';
  static String createHistory(String id) => '/shipment/$id/history';
  static String delete(String id) => '/shipment/$id';
  static String update(String id) => '/shipment/$id';
  static String create = '/shipment';
  static String getShipments() => '/shipment/list';
  static String getShipment(String id) => '/shipment/$id';
  static String getShipmentStatus = '/shipment-status';

  late Dio dio;
  late BaseOptions options;
  ApiServices() {
    options = getOptions();
    dio = Dio(options);
    dio.httpClientAdapter = HttpClientAdapter();
  }

  BaseOptions getOptions() => Dio().options
    ..baseUrl = baseUrl
    ..connectTimeout = Duration(seconds: 30)
    ..receiveTimeout = Duration(seconds: 30)
    ..receiveDataWhenStatusError = true
    ..followRedirects = true;

  Future<ShipmentModel> fetchShipment(String id) async {
    try {
      final response = await dio.get(
        getShipment(id),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.data['status'] == true) {
        return Future.value(ShipmentModel.fromJson(response.data['data']));
      } else {
        return Future.error('Shipment not found');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<ShipmentModel>> fetchShipments() async {
    try {
      final response = await dio.get(getShipments());

      if (response.data['success']) {
        if (response.data['data'] == null) {
          return Future.value([]);
        } else {
          var result = List<ShipmentModel>.from(
            response.data['data'].map((x) => ShipmentModel.fromJson(x)),
          );
          return Future.value(result);
        }
      } else {
        return Future.error('No shipments found');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> deleteShipments(String id) async {
    try {
      final response = await dio.delete(delete(id));
      if (response.data['success']) {
        return Future.value(true);
      } else {
        return Future.error('Failed to delete shipment');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> createShipment({
    required String item,
    required String expedition,
    required String status,
  }) async {
    try {
      final response = await dio.post(
        create,
        data: {
          'item': item,
          'expedition': expedition,
          'status': status,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.data['success']) {
        return Future.value(true);
      } else {
        return Future.error('Failed to create shipment');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> updateShipment({
    required String id,
    required String status,
  }) async {
    try {
      final response = await dio.put(
        update(id),
        data: {
          'status': status,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.data['success']) {
        return Future.value(true);
      } else {
        return Future.error('Failed to update shipment');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> addHistory({
    required String id,
    required String description,
  }) async {
    try {
      final response = await dio.post(
        createHistory(id),
        data: {
          'description': description,
          'time': DateTime.now().toIso8601String(),
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.data['success']) {
        return Future.value(true);
      } else {
        return Future.error('Failed to create history');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> addHistoryWithImage({
    required String id,
    required String description,
    required String imagePath,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'description': description,
        'time': DateTime.now().toIso8601String(),
        'image': await MultipartFile.fromFile(imagePath),
      });
      final response = await dio.post(
        createHistory(id),
        data: formData,
      );

      if (response.data['status']) {
        return Future.value(true);
      } else {
        return Future.error('Failed to create history');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
