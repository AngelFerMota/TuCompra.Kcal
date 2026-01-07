# Firebase Authentication - Guía de Implementación

## Implementado

Sistema completo de autenticación con Firebase Auth que incluye:

### Funcionalidades

#### 1. Registro y Login
- Registro con email/contraseña
- Login con email/contraseña
- Login con Google (OAuth)
- Recuperación de contraseña
- Verificación de email

#### 2. Gestión de Sesión
- Stream de estado de autenticación
- Persistencia automática de sesión
- Cierre de sesión seguro
- Re-autenticación para operaciones sensibles

#### 3. Perfil de Usuario
- Visualización de información del usuario
- Edición de nombre de usuario
- Cambio de contraseña
- Verificación de email
- Eliminación de cuenta

#### 4. Integración con Firestore
- Creación automática de documento de usuario
- Sincronización de datos de perfil
- Gestión de tokens FCM para notificaciones

## Estructura de Archivos

```
lib/features/auth/
├── auth_provider.dart      # Provider y servicio de autenticación
├── login_screen.dart        # Pantalla de inicio de sesión
├── register_screen.dart     # Pantalla de registro
└── profile_screen.dart      # Pantalla de perfil de usuario
```

## Uso

### 1. Configurar rutas en GoRouter

```dart
final router = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isLoginRoute = state.matchedLocation == '/login' || 
                         state.matchedLocation == '/register';

    // Si no hay usuario y no está en login/register, redirigir a login
    if (user == null && !isLoginRoute) {
      return '/login';
    }

    // Si hay usuario y está en login/register, redirigir a home
    if (user != null && isLoginRoute) {
      return '/';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    // ... otras rutas
  ],
);
```

### 2. Envolver la app con ProviderScope

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

### 3. Usar el estado de autenticación

```dart
class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        }
        return HomeScreen(user: user);
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}
```

### 4. Obtener usuario actual en cualquier widget

```dart
class CartScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.read(authServiceProvider);
    final currentUser = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de ${currentUser?.displayName ?? "Usuario"}'),
      ),
      body: ...,
    );
  }
}
```

## Configuración de Google Sign-In

### Android

1. Añadir en `android/app/build.gradle`:
```gradle
android {
    defaultConfig {
        // ...
        manifestPlaceholders = [
            'appAuthRedirectScheme': 'com.example.cestaria'
        ]
    }
}
```

2. El SHA-1 y SHA-256 ya deben estar configurados en Firebase Console

### iOS

1. Añadir en `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
        </array>
    </dict>
</array>
```

Reemplaza `YOUR-CLIENT-ID` con el ID del archivo `GoogleService-Info.plist`

### Web

Ya está configurado automáticamente con Firebase.

## Manejo de Errores

El servicio `AuthService` traduce automáticamente los errores de Firebase a mensajes legibles:

```dart
try {
  await ref.read(authServiceProvider).signInWithEmail(
    email: email,
    password: password,
  );
} catch (e) {
  // e contiene un mensaje de error legible en español
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(e.toString())),
  );
}
```

## Ownership de Carritos

Para asociar carritos con usuarios:

```dart
Future<void> createCart(String cartName) async {
  final user = ref.read(authServiceProvider).currentUser;
  if (user == null) throw Exception('Usuario no autenticado');

  final cart = Cart(
    id: uuid.v4(),
    name: cartName,
    ownerId: user.uid,  // Usuario actual es el dueño
    participantIds: [user.uid],
    items: [],
    createdAt: DateTime.now(),
  );

  await firestoreService.saveCart(cart);
}
```

## Verificar Ownership

```dart
bool isOwner(Cart cart) {
  final user = ref.read(authServiceProvider).currentUser;
  return user != null && cart.ownerId == user.uid;
}

// Uso en UI
if (isOwner(cart)) {
  // Mostrar opciones de administrador
  IconButton(
    icon: Icon(Icons.delete),
    onPressed: () => deleteCart(cart.id),
  )
}
```

## Notificaciones Push con Auth

Las notificaciones se configuran automáticamente al iniciar sesión:

```dart
// En AuthService.signInWithEmail():
await _pushService.initialize(userId: credential.user!.uid);

// En AuthService.signOut():
await _pushService.clearUserId();
```

## Seguridad

### Firestore Rules

Actualizar las reglas de seguridad en `firestore.rules`:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Usuarios solo pueden leer/escribir sus propios datos
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Carritos - solo participantes pueden leer
    match /carts/{cartId} {
      allow read: if request.auth != null && 
        request.auth.uid in resource.data.participantIds;
      
      // Solo el owner puede crear/eliminar
      allow create: if request.auth != null && 
        request.auth.uid == request.resource.data.ownerId;
      allow delete: if request.auth != null && 
        request.auth.uid == resource.data.ownerId;
      
      // Solo participantes pueden actualizar
      allow update: if request.auth != null && 
        request.auth.uid in resource.data.participantIds;
    }
  }
}
```

Desplegar las reglas:
```bash
firebase deploy --only firestore:rules
```

## Testing

### Crear usuario de prueba

```dart
await ref.read(authServiceProvider).registerWithEmail(
  email: 'test@example.com',
  password: 'password123',
  displayName: 'Usuario de Prueba',
);
```

### Cerrar sesión

```dart
await ref.read(authServiceProvider).signOut();
```

## Próximos Pasos

1. Implementar autenticación con otros proveedores (Apple, Facebook)
2. Añadir autenticación de dos factores
3. Implementar roles y permisos personalizados
4. Agregar límites de tasa de autenticación
5. Implementar sesiones en múltiples dispositivos
