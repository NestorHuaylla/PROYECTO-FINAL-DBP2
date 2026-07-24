# Tarea Fase 2 (Manito)

El corazón del producto: integración OAuth con Gmail API y parsing de
correos de confirmación de compra. Requiere más experiencia, la toma Manito.

Pendiente:
- gmail-auth.controller.ts: endpoints /auth/gmail y /auth/gmail/callback (OAuth2)
- gmail-sync.service.ts: usa googleapis para leer correos, filtra por
  remitentes/asuntos conocidos (Amazon, MercadoLibre, Netflix, etc.)
- email-parser.util.ts: extrae monto, comercio y fecha del cuerpo del correo
- Al detectar un correo válido, crear una Transaction con source="gmail"
  y aplicar las CategorizationRule (buscar keyword en el texto del correo)
