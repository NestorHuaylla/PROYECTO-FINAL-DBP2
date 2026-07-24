# Tarea Fase 2 (compañero)

Replicar exactamente el patrón de `src/categories/` pero para el modelo
`CategorizationRule` del schema.prisma.

Archivos a crear (mismo orden que en categories/):
1. dto/create-categorization-rule.dto.ts   (campos: keyword, categoryId, priority)
2. dto/update-categorization-rule.dto.ts   (extiende el create con PartialType)
3. categorization-rules.service.ts         (create/findAll/findOne/update/remove)
4. categorization-rules.controller.ts      (mismos 5 endpoints REST)
5. categorization-rules.module.ts

No olvides:
- Registrar el nuevo módulo en `src/app.module.ts` (imports)
- Probar los endpoints con Postman o Thunder Client antes de avisar que está listo
