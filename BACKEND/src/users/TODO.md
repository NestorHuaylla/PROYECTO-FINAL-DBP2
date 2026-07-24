# Tarea Fase 2 (Manito)

Este módulo incluye el registro/login de usuarios y JWT, por eso lo toma
Manito (seguridad = no es terreno para prueba y error de aprendizaje).

Pendiente:
- create-user.dto.ts (name, email, password en texto plano -> se hashea con bcrypt)
- users.service.ts (hash de password con bcrypt antes de guardar)
- auth.module.ts con estrategia JWT (@nestjs/jwt, @nestjs/passport, passport-jwt)
- Guard de autenticación reutilizable para proteger otros endpoints
