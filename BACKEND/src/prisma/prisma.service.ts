import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

// Este servicio envuelve al PrismaClient para poder inyectarlo
// en cualquier módulo de Nest (ej. en TransactionsService, UsersService, etc.)
// Se conecta cuando arranca el módulo y se desconecta cuando se apaga la app.
@Injectable()
export class PrismaService
  extends PrismaClient
  implements OnModuleInit, OnModuleDestroy
{
  async onModuleInit() {
    await this.$connect();
  }

  async onModuleDestroy() {
    await this.$disconnect();
  }
}
