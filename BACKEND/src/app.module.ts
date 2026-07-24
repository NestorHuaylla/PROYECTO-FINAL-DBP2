import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PrismaModule } from './prisma/prisma.module';
import { CategoriesModule } from './categories/categories.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }), // lee el .env en toda la app
    PrismaModule,
    CategoriesModule,
    // A medida que avancemos en la Fase 2 se agregan aquí:
    // UsersModule, TransactionsModule, CategorizationRulesModule, GmailModule
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
