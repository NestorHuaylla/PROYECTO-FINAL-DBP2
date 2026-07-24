# Tarea Fase 2 (Manito + compañero, pareados)

Manito lidera la lógica de filtros (por fecha, por categoría, por mes/año
para las gráficas comparativas). El compañero escribe el CRUD base
siguiendo el patrón de categories/.

Pendiente:
- create-transaction.dto.ts / update-transaction.dto.ts
- transactions.service.ts:
  - CRUD base (compañero)
  - findByDateRange(userId, from, to) (Manito)
  - findGroupedByMonth(userId, year) para alimentar las gráficas (Manito)
- transactions.controller.ts con query params ?from=&to=&categoryId=
- transactions.module.ts
