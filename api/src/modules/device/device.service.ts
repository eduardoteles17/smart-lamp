import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../infra/prisma/prisma.service';
import { Device } from '../../models/device.model';
import { DeviceStatus } from '../../enums/device-status.enum';
import { MqttService } from '../../infra/mqtt/mqtt.service';

@Injectable()
export class DeviceService {
  constructor(
    private readonly mqttService: MqttService,
    private readonly prismaService: PrismaService,
  ) {
    this.mqttService.subscribe('devices/+/status', async (topic, message) => {
      const deviceId = topic.split('/')[1];
      const status = message.toString() as DeviceStatus;

      await this.prismaService.device.update({
        where: { id: deviceId },
        data: { status },
      });
    });
  }

  async findAll(): Promise<Device[]> {
    const devices = await this.prismaService.device.findMany();

    return devices.map((device) => ({
      ...device,
      status: device.status as DeviceStatus,
    }));
  }

  async toggleById(deviceId: string): Promise<Device> {
    const device = await this.prismaService.device.findUnique({
      where: { id: deviceId },
    });

    const newStatus =
      device.status === DeviceStatus.active
        ? DeviceStatus.inactive
        : DeviceStatus.active;

    this.mqttService.publish(`devices/${device.id}/status`, newStatus);

    const toggledDevice = await this.prismaService.device.update({
      where: { id: deviceId },
      data: {
        status: newStatus,
      },
    });

    return {
      ...toggledDevice,
      status: toggledDevice.status as DeviceStatus,
    };
  }
}
