import 'package:flutter/material.dart';
import 'package:mobile/models/device.dart';
import 'package:mobile/models/device_status.dart';
import 'package:mobile/services/device_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Lamp'),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {});
          return Future.value();
        },
        child: FutureBuilder(
          future: DeviceService.findAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasError) {
              return const Center(
                child: Text('Erro ao carregar dispositivos'),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Nenhum dispositivo encontrado'),
              );
            }

            final devices = snapshot.data as List<Device>;

            return ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];

                return SwitchListTile.adaptive(
                  value: device.status == DeviceStatus.ACTIVE,
                  onChanged: (value) {
                    DeviceService.toggleStatus(device.id);
                  },
                  title: Text(device.name),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
