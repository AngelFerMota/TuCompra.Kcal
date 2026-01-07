# Cloud Functions - TuCompra.Kcal

Cloud Functions para notificaciones push y lógica backend del carrito compartido.

## Estructura

```
functions/
├── src/
│   └── index.ts          # Funciones principales
├── package.json          # Dependencias Node.js
├── tsconfig.json        # Configuración TypeScript
└── .eslintrc.js         # Configuración ESLint
```

## Funciones

### `sendCartNotification` (Firestore Trigger)
Trigger automático cuando se actualiza un carrito en Firestore.

**Eventos detectados:**
- Producto marcado como comprado
- Producto eliminado del carrito
- Producto añadido al carrito

**Comportamiento:**
1. Detecta el tipo de cambio comparando before/after
2. Obtiene el nombre del usuario que hizo el cambio
3. Consulta tokens FCM de todos los participantes
4. Envía notificación multicast (excepto al usuario que hizo el cambio)
5. Limpia tokens inválidos automáticamente

### `sendManualNotification` (HTTP Callable)
Función invocable para pruebas manuales de notificaciones.

**Parámetros:**
- `cartId`: ID del carrito
- `title`: Título de la notificación
- `body`: Cuerpo de la notificación

**Seguridad:** Requiere autenticación y ser participante del carrito.

## Despliegue

### 1. Instalar dependencias

```bash
cd functions
npm install
```

### 2. Configurar Firebase

Asegúrate de tener Firebase CLI instalado:

```bash
npm install -g firebase-tools
firebase login
```

Inicializa el proyecto (si aún no lo has hecho):

```bash
firebase init
# Selecciona: Functions, Firestore
```

### 3. Desplegar

**Desplegar todo:**
```bash
firebase deploy
```

**Solo Functions:**
```bash
firebase deploy --only functions
```

**Solo Firestore Rules:**
```bash
firebase deploy --only firestore:rules
```

### 4. Verificar despliegue

Revisa los logs:
```bash
firebase functions:log
```

O filtra por función específica:
```bash
firebase functions:log --only sendCartNotification
```

## Desarrollo Local

### Emuladores

Para probar localmente sin desplegar:

```bash
firebase emulators:start
```

Esto iniciará:
- Functions Emulator (puerto 5001)
- Firestore Emulator (puerto 8080)
- UI de emuladores (puerto 4000)

### Conectar app Flutter a emuladores

En `main.dart`:

```dart
if (kDebugMode) {
  FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
}
```

## Testing

### Probar trigger automático

1. Abre Firestore en Firebase Console
2. Edita un documento en `carts/{cartId}`
3. Cambia `isPurchased` de un item
4. Revisa logs: `firebase functions:log`

### Probar función manual

Desde Flutter:

```dart
final callable = FirebaseFunctions.instance.httpsCallable('sendManualNotification');
await callable.call({
  'cartId': 'test_cart_123',
  'title': '🧪 Test',
  'body': 'Prueba de notificación',
});
```

## Troubleshooting

### Error: "Could not find firebase-admin"

```bash
cd functions
npm install firebase-admin firebase-functions
```

### Error: "TypeScript not found"

```bash
cd functions
npm install typescript --save-dev
```

### Error: "Permission denied"

Verifica que las reglas de Firestore permitan acceso:

```bash
firebase deploy --only firestore:rules
```

### Notificaciones no llegan

1. Verifica que el token FCM esté guardado en Firestore:
   - Colección: `users/{userId}`
   - Campo: `fcmToken`

2. Revisa logs de Cloud Functions:
   ```bash
   firebase functions:log --only sendCartNotification
   ```

3. Verifica que el usuario esté en `participantIds` del carrito

4. Comprueba permisos de notificación en el dispositivo

## Monitoreo

### Ver métricas

Firebase Console → Functions → Ver métricas de cada función

**Métricas importantes:**
- Invocaciones por minuto
- Tiempo de ejecución
- Errores
- Costo estimado

### Alertas

Configura alertas en Firebase Console para:
- Tasa de errores > 5%
- Tiempo de ejecución > 10s
- Fallos de facturación

## Costos

**Plan Spark (Gratis):**
- 125,000 invocaciones/mes
- 40,000 GB-segundo
- 40,000 CPU-segundo

**Plan Blaze (Pago por uso):**
- $0.40 por millón de invocaciones
- $0.0000025 por GB-segundo
- $0.0000100 por GHz-segundo

**Estimación para 1000 usuarios activos:**
- ~10,000 notificaciones/día = 300k/mes
- Costo: ~$0.12/mes (muy económico)

## Seguridad

### Firestore Rules

Las reglas de seguridad están en `firestore.rules`:

- Solo participantes pueden leer carritos
- Solo el owner puede crear/eliminar carritos
- Solo participantes pueden actualizar carritos
- Usuarios solo pueden modificar su propio token FCM

### Validación en Functions

Las Cloud Functions validan:
- Usuario autenticado (Firebase Auth)
- Usuario es participante del carrito
- Tokens FCM válidos

## Próximos pasos

- [ ] Añadir notificaciones para invitaciones a carrito
- [ ] Implementar notificaciones programadas (recordatorios)
- [ ] Analytics de uso de carritos compartidos
- [ ] Función para limpiar carritos antiguos
- [ ] Rate limiting para evitar spam

## Referencias

- [Firebase Cloud Functions Docs](https://firebase.google.com/docs/functions)
- [Firebase Admin SDK](https://firebase.google.com/docs/admin/setup)
- [FCM HTTP v1 API](https://firebase.google.com/docs/cloud-messaging/http-server-ref)
