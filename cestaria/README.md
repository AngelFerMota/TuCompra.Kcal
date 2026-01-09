# 🛒 Cestaria
**Tu compra, más sana. Más inteligente.**

---

## 📱 Proyecto Flutter: Aplicación de Listas de Compra Inteligentes

**Cestaria** es una aplicación móvil desarrollada íntegramente en **Flutter** para Android. Su objetivo es ayudar a los usuarios a gestionar sus compras de forma eficiente y saludable, con foco en productos de **Mercadona** enriquecidos con datos nutricionales provenientes de **OpenFoodFacts**.

La app permite:

✅ Buscar y escanear productos  
✅ Añadir productos al carrito con información nutricional completa  
✅ Consultar el precio total y el resumen nutricional global  
✅ Exportar la lista en PDF o CSV  
✅ Mantener un historial de compras anteriores  
✅ Todo almacenado localmente sin necesidad de conexión constante  

---

## 🚀 Funcionalidades principales


### 🔍 1. Búsqueda de productos
- Consulta de productos de **Mercadona** (imagen, precio, descripción)
- Información nutricional y **Nutri-Score** desde **OpenFoodFacts**
- Entrada manual de códigos de barras
- **Escaneo con la cámara** usando ML Kit

### 🛒 2. Gestión del carrito
- Añadir o eliminar productos con facilidad
- **Precio total** calculado en tiempo real
- **Resumen nutricional** del carrito: calorías, proteínas, carbohidratos y grasas
- Marcar productos como comprados
- Modificar cantidades con botones +/-
- Vaciar carrito completo

### 📂 3. Historial de compras
- Guardado automático de compras finalizadas
- Reutilización de carritos anteriores
- Vista cronológica con detalles expandibles

### 📋 4. Exportación
- Exportar lista en **PDF** con formato profesional
- Exportar en **CSV** para Excel/Sheets
- Compartir por WhatsApp, correo, etc.

### ⚙️ 5. Persistencia local
- Base de datos **SQLite** para almacenamiento offline
- Sincronización instantánea sin necesidad de backend
- Datos siempre disponibles

---

## 🧰 Tecnologías utilizadas

| Área | Tecnología |
|------|------------|
| **Frontend** | Flutter 3.24.5 |
| **Lenguaje** | Dart 3.5.4 |
| **Base de datos** | SQLite (sqflite 2.3.0) |
| **Gestión de estado** | Riverpod 2.6.1 |
| **APIs externas** | Mercadona API (no oficial), OpenFoodFacts |
| **Navegación** | go_router 13.0.0 |
| **Escaneo de códigos** | mobile_scanner 3.5.5 (ML Kit) |
| **Generación de documentos** | pdf 3.10.7, csv 5.1.1 |
| **Compartir archivos** | share_plus 7.2.1 |
| **Code generation** | freezed 2.4.5, json_serializable 6.7.1 |
| **Diseño** | Material Design 3 |

---

## 🎯 Objetivos del proyecto

✅ Optimizar la experiencia de compra cotidiana  
✅ Fomentar decisiones alimentarias saludables con información nutricional  
✅ Ofrecer una visualización clara del impacto nutricional y económico de la compra  
✅ Implementar arquitectura limpia y mantenible  
✅ Aplicar conceptos de desarrollo móvil moderno  

---

## 📅 Estado actual y roadmap

- [x] Definición de alcance y diseño de funcionalidades
- [x] Estructura del proyecto en Flutter
- [x] UI/UX con Material Design 3
- [x] Integración de APIs (Mercadona + OpenFoodFacts)
- [x] Búsqueda y detalle de productos
- [x] Escaneo de códigos de barras
- [x] Gestión de carrito con SQLite
- [x] Resumen nutricional agregado
- [x] Historial de compras
- [x] Exportación a PDF y CSV
- [ ] Modo oscuro
- [ ] Filtros saludables (NutriScore, bajo azúcar, etc.)
- [ ] Gráficas de distribución de macronutrientes
- [ ] Múltiples listas activas
- [ ] Notificaciones inteligentes
- [ ] Testing unitario y de integración

---

## 🏗️ Arquitectura del proyecto

```
lib/
├── core/                       # Código compartido
│   ├── providers/              # Providers de Riverpod
│   ├── router/                 # Rutas (go_router)
│   ├── services/               # APIs y SQLite
│   ├── utils/                  # Exportación PDF/CSV
│   └── widgets/                # Widgets reutilizables
├── features/                   # Módulos por funcionalidad
│   ├── cart/                   # Carrito de compra
│   ├── product_search/         # Búsqueda de productos
│   ├── product_detail/         # Detalle de producto
│   ├── nfc_scan/               # Escaneo de códigos
│   ├── history/                # Historial de compras
│   └── settings/               # Configuración
├── models/                     # Modelos inmutables (freezed)
├── app.dart                    # MaterialApp config
└── main.dart                   # Entry point
```

---

## 🗄️ Base de datos SQLite

### Tabla `products`
- `barcode` (PK), `name`, `brand`, `image_url`
- `price`, `quantity`, `nutriscore`
- `calories`, `proteins`, `carbohydrates`, `fats`
- `allergens` (JSON)

### Tabla `cart_items`
- `id` (PK), `barcode` (FK), `quantity`, `is_purchased`, `added_at`

### Tabla `purchase_history`
- `id` (PK), `total_price`, `completed_at`

### Tabla `purchase_items`
- `id` (PK), `purchase_id` (FK), `barcode`, `product_name`, `price`, `quantity`, `nutritional_info` (JSON)

---

## 🚀 Cómo ejecutar el proyecto

### Requisitos previos

- **Flutter SDK** >= 3.24.0
- **Dart SDK** >= 3.5.0
- **Android Studio** con Android SDK
- Emulador Android o dispositivo físico

### Pasos de instalación

> **💡 Recomendación para prueba rápida:**  
> La aplicación viene precargada con productos de ejemplo (Nutella, Coca-Cola, Leche, Pan integral) que muestran el potencial completo de la app.  
> 
> **Productos ideales para búsqueda:**
> - **Nutella** - Excelente información nutricional completa
> - **Coca-Cola** - Muestra Nutri-Score E y valores de azúcar
> - **Leche** - Producto básico con buen balance nutricional
> - Cualquier producto de Mercadona también funciona bien

1️⃣ **Clona el repositorio**
```bash
git clone https://github.com/tu-usuario/cestaria.git
cd cestaria
```

2️⃣ **Instala las dependencias**
```bash
flutter pub get
```

3️⃣ **Genera código con build_runner**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4️⃣ **Ejecuta la aplicación**
```bash
flutter run
```

### Compilar APK de producción

```bash
flutter build apk --release
```

El APK estará en `build/app/outputs/flutter-apk/app-release.apk`

### Ejecutar en dispositivo físico

1. Habilita **Opciones de desarrollador** en tu dispositivo Android
2. Activa **Depuración USB**
3. Conecta el dispositivo por USB
4. Ejecuta `flutter devices` para verificar que se detectó
5. Ejecuta `flutter run`

---

## 🧠 ¿Te gustaría colaborar o sugerir mejoras?

Tu feedback es bienvenido. Puedes:

- 🐛 Abrir un **Issue** para reportar bugs o sugerir funcionalidades
- 🔄 Enviar un **Pull Request** con mejoras
- ⭐ Dar una estrella al proyecto si te resulta útil
- 📧 Contactar para discutir ideas o colaboraciones

---

## 📚 Lo que aprendí

Este proyecto me permitió profundizar en:

- Gestión de estado con **Riverpod**
- Integración de **APIs REST** (HTTP, parsing JSON)
- **SQLite** en Flutter (diseño de esquemas, queries con JOIN)
- **Arquitectura limpia** (separación de capas, repository pattern)
- **Code generation** (Freezed, json_serializable)
- Navegación declarativa con **go_router**
- Generación de **PDFs** y **CSVs**
- **Material Design 3** y mejores prácticas de UX
- Escaneo de códigos con **mobile_scanner**

---

## 📝 Licencia

Este es un proyecto académico

---