#  Guía de Despliegue Rápido - Push Notifications

##  Checklist de Implementación

### 1. Instalar dependencias de Cloud Functions

```powershell
cd functions
npm install
```

### 2. Desplegar a Firebase

```powershell
# Desplegar Functions y Reglas de Firestore
firebase deploy --only functions,firestore:rules

# O desplegar todo
firebase deploy
```

### 3. Verificar despliegue

```powershell
# Ver logs en tiempo real
firebase functions:log

# Ver estado de las funciones
firebase functions:list
```

##  Configuración Flutter

### main.dart

El servicio ya está inicializado, pero falta pasar el userId real cuando tengas Firebase Auth:

```dart
// En main.dart, después de inicializar Firebase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Cuando implementes Firebase Auth:
  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (user != null) {
      // Inicializar push notifications con userId real
      final pushService = PushNotificationService();
      pushService.initialize(userId: user.uid);
    }
  });
  
  runApp(const ProviderScope(child: MyApp()));
}
```

### Actualizar shared_cart_provider.dart

El provider ya tiene el campo `lastModifiedBy`, solo falta usar el userId real:

**Busca en el código:**
```dart
'current_user_id' 
```

**Reemplaza con:**
```dart
FirebaseAuth.instance.currentUser?.uid ?? 'anonymous'
```

##  Testing

### Test 1: Verificar token FCM guardado

1. Abre Firebase Console → Firestore
2. Ve a colección `users`
3. Busca tu documento de usuario
4. Verifica que tenga el campo `fcmToken`

### Test 2: Probar notificación manual

Desde Flutter (después de autenticarte):

```dart
final callable = FirebaseFunctions.instance.httpsCallable('sendManualNotification');
try {
  await callable.call({
    'cartId': 'tu_cart_id_aqui',
    'title': ' Test de notificación',
    'body': 'Si ves esto, funciona!',
  });
} catch (e) {
  print('Error: $e');
}
```

### Test 3: Probar trigger automático

1. Abre la app en 2 dispositivos (o web + móvil)
2. Comparte un carrito entre ambos
3. En dispositivo A: añade un producto
4. Dispositivo B debería recibir notificación "➕ {Nombre} añadió {Producto}"

5. En dispositivo A: marca producto como comprado
6. Dispositivo B debería recibir " {Nombre} compró {Producto}"

7. En dispositivo A: elimina un producto
8. Dispositivo B debería recibir " {Nombre} eliminó {Producto}"

##  Verificar que funciona

### Check logs de Cloud Functions

```powershell
firebase functions:log --only sendCartNotification
```

Deberías ver:
```
 Enviando notificación a 2 participantes...
 Notificación enviada: 2 exitosos, 0 fallidos
```

### Si algo falla

**Token no guardado:**
```dart
// Verifica en lib/core/services/push_notification_service.dart
debugPrint('📱 FCM Token: $_fcmToken');
debugPrint('👤 User ID: $_currentUserId');
```

**Notificación no llega:**
1. Revisa permisos en el dispositivo
2. Verifica que el carrito tenga `participantIds` correctos
3. Comprueba logs: `firebase functions:log`
4. Verifica Firestore Rules: `firebase deploy --only firestore:rules`

**Cloud Function falla:**
```powershell
# Ver errores detallados
firebase functions:log --only sendCartNotification

# Ver stack trace completo
firebase functions:log --only sendCartNotification --limit 50
```

## 🎯 Siguiente paso: Firebase Auth

Para tener userIds reales en lugar de 'current_user_id':

1. Activa Firebase Auth en Firebase Console
2. Crea screens de login/registro
3. Implementa FirebaseAuth.instance.signInWithEmailAndPassword()
4. Reemplaza todos los 'current_user_id' con user.uid
5. Guarda token FCM en login: `pushService.setUserId(user.uid)`
6. Limpia token en logout: `pushService.clearUserId()`

##  Notas importantes

- **Emuladores:** Usa `firebase emulators:start` para desarrollo local
- **Costos:** Plan gratuito incluye 125,000 invocaciones/mes
- **Límites:** FCM soporta hasta 500 tokens por mensaje multicast
- **Limpieza:** La función limpia automáticamente tokens inválidos
- **Debugging:** Usa `firebase functions:log` para troubleshooting

##  Funcionalidades listas

-  Notificación cuando alguien compra producto
-  Notificación cuando alguien elimina producto
-  Notificación cuando alguien añade producto
-  Limpieza automática de tokens expirados
-  Excluye al usuario que hizo la acción
-  Nombres de usuario en las notificaciones
-  Emojis para mejor UX
-  Soporte Android (high priority, custom channel)
-  Soporte iOS (APNS con sound y badge)

##  ¡Listo!

Una vez desplegado y configurado, tu app tendrá notificaciones push reales funcionando end-to-end.
