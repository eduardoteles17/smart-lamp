import 'package:mobile/infra/dio.dart';
import 'package:mobile/models/device.dart';

abstract class DeviceService {
  static Future<List<Device>> findAll() async {
    final resp = await dio.get<List<dynamic>>("/device");

    return (resp.data ?? [])
        .map(
          (device) => Device(
            id: device["id"],
            name: device["name"],
            status: device["status"],
          ),
        )
        .toList();
  }

  static Future<void> toggleStatus(String id) async {
    await dio.post("/device/$id/toggle");
  }
}
