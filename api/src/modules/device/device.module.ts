import { Module } from '@nestjs/common';
import { DeviceController } from './device.controller';
import { DeviceService } from './device.service';
import { PrismaModule } from '../../infra/prisma/prisma.module';
import { MqttModule } from '../../infra/mqtt/mqtt.module';

@Module({
  imports: [PrismaModule, MqttModule],
  controllers: [DeviceController],
  providers: [DeviceService],
})
export class DeviceModule {}
