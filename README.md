# Cestaria - Tu lista de compra inteligente

Una aplicación móvil que desarrollé para simplificar la experiencia de hacer la compra, tanto de forma individual como colaborativa. Nació de una necesidad real: coordinar las compras del hogar con mi familia sin tener que estar enviando mensajes constantemente preguntando "¿qué hacía falta?".

## El origen del proyecto

La idea surgió cuando me di cuenta de que hacer la compra familiar se había convertido en un caos de mensajes de WhatsApp, notas de papel perdidas y llamadas de última hora desde el supermercado. Necesitaba algo que permitiera a varias personas gestionar la misma lista en tiempo real, ver qué había añadido cada uno y recibir notificaciones cuando alguien marcara un producto como comprado.

Además, quería aprovechar la oportunidad para trabajar con tecnologías modernas y enfrentarme al desafío de construir una arquitectura robusta que integrara múltiples servicios externos.

## ¿Qué problema resuelve?

Cestaria está pensada para dos escenarios principales:

1. **Compra personal**: Gestionar tu propia lista, buscar productos rápidamente y mantener un historial de lo que sueles comprar.

2. **Compra colaborativa**: Compartir listas con familiares o compañeros de piso donde todos pueden añadir productos, marcar lo que ya está en el carrito y recibir notificaciones en tiempo real de los cambios.

## Ingeniería de requisitos

Antes de empezar a programar, dediqué tiempo a definir los requisitos funcionales y no funcionales que debía cumplir la aplicación:

### Requisitos funcionales

- Sistema de autenticación seguro con email/contraseña y Google Sign-In
- Búsqueda de productos en múltiples fuentes (APIs de Mercadona y OpenFoodFacts)
- Creación y gestión de carritos de compra individuales
- Carritos compartidos con sincronización en tiempo real entre usuarios
- Notificaciones push cuando otros usuarios modifican el carrito compartido
- Exportación de listas a PDF y CSV para llevar impreso o compartir
- Historial de compras anteriores para reutilizar listas
- Modo offline con caché local de productos
- Escaneo de códigos de barras para añadir productos rápidamente

### Requisitos no funcionales

- Disponibilidad: Funcionar incluso sin conexión a internet (con limitaciones)
- Seguridad: Datos de usuario encriptados y reglas estrictas en Firestore
- Escalabilidad: Arquitectura preparada para soportar múltiples usuarios simultáneos
- Mantenibilidad: Código limpio siguiendo Clean Architecture

## Stack tecnológico y decisiones de diseño

### Flutter como framework principal

Elegí Flutter porque me permite desarrollar con un único código base y obtener un rendimiento nativo. Aunque inicialmente me centré en Android, la arquitectura está preparada para expandirse a iOS sin demasiado esfuerzo adicional. El hot reload de Flutter aceleró muchísimo el desarrollo durante las fases de diseño de UI.

### Firebase como backend

Opté por Firebase por varias razones:

- **Authentication**: Implementación rápida y segura de login sin tener que gestionar yo mismo el cifrado de contraseñas
- **Firestore**: Base de datos NoSQL en tiempo real perfecta para los carritos compartidos. La sincronización automática mediante streams fue clave para la funcionalidad colaborativa
- **Cloud Messaging**: Sistema de notificaciones push sin montar mi propio servidor
- **Cloud Functions**: Lógica backend serverless para enviar notificaciones cuando cambia un carrito

La integración con Firebase me permitió centrarme en la lógica de negocio en lugar de preocuparme por infraestructura.

### Riverpod para gestión de estado

Decidí usar Riverpod (en lugar de Provider o Bloc) porque ofrece un sistema de gestión de estado más robusto con compile-time safety. Los StateNotifier me permiten separar claramente la lógica de negocio de la UI, y los providers facilitan la inyección de dependencias sin acoplamiento.

### SQLite como caché local

Implementé una base de datos SQLite local para:
- Cachear productos consultados anteriormente
- Permitir funcionalidad offline
- Almacenar borradores de carritos sin sincronizar
- Mantener historial de compras

Esto garantiza que la app siga siendo útil aunque pierdas la conexión a internet en medio del supermercado.

### APIs externas

Integré dos fuentes de datos de productos:

1. **API de Mercadona**: Datos reales de productos españoles con precios actualizados. Priorizo estos resultados porque son más relevantes para el mercado local.

2. **OpenFoodFacts**: Base de datos colaborativa internacional como fallback. Útil para productos que no están en Mercadona o para usuarios fuera de España.

### Otras librerías clave

- **go_router**: Navegación declarativa con redirecciones automáticas según el estado de autenticación
- **freezed**: Generación de modelos inmutables con copyWith y pattern matching
- **mobile_scanner**: Escaneo de códigos de barras usando la cámara
- **pdf & printing**: Exportación de listas a PDF
- **share_plus**: Compartir listas exportadas

## Funcionalidades implementadas

### Autenticación y perfil

- Registro con email y contraseña
- Login con Google (solo en móvil por limitaciones de Firebase en web)
- Recuperación de contraseña
- Gestión de perfil de usuario con foto y nombre
- Cierre de sesión con confirmación

### Búsqueda de productos

- Búsqueda por texto en APIs de Mercadona y OpenFoodFacts
- Entrada manual de código de barras
- Escaneo de códigos con la cámara del dispositivo
- Resultados combinados priorizando productos locales
- Vista de detalles con imagen, precio, marca y cantidad

### Gestión de carrito personal

- Añadir productos desde la búsqueda
- Modificar cantidad con botones +/-
- Marcar productos como comprados (con checkbox)
- Eliminar productos deslizando
- Cálculo automático del total
- Vaciar carrito completo

### Carrito compartido

- Crear carritos y generar ID único para compartir
- Unirse a carritos usando el ID
- Sincronización en tiempo real de cambios
- Ver quién está en el carrito (participantes)
- Añadir productos manualmente al carrito compartido
- Notificaciones push cuando alguien añade, elimina o compra productos

### Exportación y compartir

- Exportar listas a PDF con formato profesional
- Exportar a CSV para usar en Excel u otras apps
- Diálogo de selección de formato
- Compartir archivo generado por WhatsApp, email, etc.

### Historial

- Registro automático de compras finalizadas
- Vista de carritos anteriores con fecha
- Detalle expandible de cada compra
- Estadísticas de productos más comprados (pendiente de UI)

### Configuración

- Gestión de permisos de notificaciones
- Vista del email del usuario actual
- Botón de cierre de sesión con confirmación
- (Futuro: preferencias de tienda, modo oscuro, etc.)

## Arquitectura del proyecto

Seguí los principios de Clean Architecture organizando el código en capas:

```
lib/
├── core/              # Código compartido
│   ├── firebase/      # Inicialización Firebase
│   ├── providers/     # Providers globales
│   ├── router/        # Configuración de rutas
│   ├── services/      # Servicios (APIs, DB local)
│   ├── utils/         # Utilidades (export, mock data)
│   └── widgets/       # Widgets reutilizables
├── features/          # Características por módulo
│   ├── auth/          # Autenticación
│   ├── cart/          # Carrito personal
│   ├── shared_cart/   # Carrito colaborativo
│   ├── product_search/# Búsqueda y escaneo
│   ├── history/       # Historial de compras
│   └── settings/      # Configuración
└── models/            # Modelos de datos (freezed)
```

Cada feature tiene su propia pantalla, provider y repository cuando es necesario. Esto facilita el testing y el mantenimiento a largo plazo.

## Desafíos técnicos que enfrenté

1. **Sincronización en tiempo real**: Lograr que múltiples usuarios vean los cambios instantáneamente sin conflictos fue complejo. Resolví esto usando streams de Firestore y gestionando cuidadosamente los estados de carga.

2. **Notificaciones contextuales**: Enviar notificaciones solo a los participantes relevantes y excluir al usuario que hace el cambio requirió Cloud Functions con lógica personalizada.

3. **Modo offline**: Decidir qué cachear, cuándo sincronizar y cómo resolver conflictos entre versión local y remota fue todo un desafío de arquitectura.

4. **Integración de múltiples APIs**: Combinar resultados de Mercadona y OpenFoodFacts sin duplicados y priorizando correctamente llevó varias iteraciones.

5. **Performance en listas grandes**: Optimizar el renderizado de listas con muchos productos usando ListView.builder y controlando los rebuilds innecesarios.

## Instalación y configuración

### Requisitos previos

- Flutter SDK >= 3.3.5
- Android Studio con Android SDK
- Cuenta de Firebase (para backend)
- Emulador Android o dispositivo físico

### Pasos para ejecutar

1. Clona el repositorio
```bash
git clone [tu-repo]
cd cestaria
```

2. Instala dependencias
```bash
flutter pub get
```

3. Configura Firebase (opcional pero recomendado)
- Crea un proyecto en Firebase Console
- Añade una app Android con el package `com.tucompra.kcal.cestaria`
- Descarga `google-services.json` y colócalo en `android/app/`
- Activa Authentication (Email/Password y Google)
- Crea base de datos Firestore

4. Ejecuta la app
```bash
flutter run
```

## Lo que aprendí

Este proyecto me permitió profundizar en:

- Gestión de estado compleja con Riverpod y StateNotifier
- Integración de Firebase con todas sus piezas (Auth, Firestore, FCM, Functions)
- Arquitectura escalable y mantenible
- Testing de widgets y lógica de negocio
- Optimización de rendimiento en Flutter
- Trabajar con TypeScript para Cloud Functions
- Implementación de features en tiempo real
- Diseño de UX/UI con Material Design 3

Además, me enfrenté a problemas reales de producción como gestionar estados asíncronos, manejar errores de red, implementar retry logic y asegurar que la app funcione en condiciones adversas.

## Próximos pasos

Aunque la app está completamente funcional, tengo algunas ideas para expandirla:

- Añadir comparación de precios entre diferentes supermercados
- Implementar sugerencias inteligentes basadas en historial
- Sistema de notificaciones cuando productos bajan de precio
- Modo oscuro completo
- Soporte para listas temáticas (desayunos, cenas de la semana, etc.)
- Widget para la pantalla de inicio de Android
- Versión web full-featured

## Conclusión

Cestaria es más que una simple lista de compras. Es un proyecto donde puse en práctica conceptos avanzados de desarrollo móvil, arquitectura de software y diseño de sistemas distribuidos. Me permitió experimentar con tecnologías modernas y resolver problemas reales de forma escalable y mantenible.

El código está organizado siguiendo buenas prácticas, lo que facilita añadir nuevas características o corregir bugs. Y lo más importante: resuelve un problema real que yo mismo tenía, lo cual siempre es la mejor motivación para desarrollar algo.

---

*Desarrollado con Flutter, Firebase y mucho café.*

