import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Habilita CORS para que la app Flutter y el panel Vue
  // (que corren en otros orígenes/puertos) puedan llamar a esta API.
  app.enableCors();

  // Valida y limpia automáticamente el body de cada request
  // según las reglas definidas en los DTOs (class-validator).
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true, // elimina campos que no están en el DTO
      transform: true, // convierte tipos automáticamente (ej. string -> number)
    }),
  );

  const port = process.env.PORT ?? 3000;
  await app.listen(port);
  console.log(`Backend corriendo en http://localhost:${port}`);
}
bootstrap();
