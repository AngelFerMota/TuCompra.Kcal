# TuCompra.Kcal
# 🛒 Proyecto: Aplicación Multiplataforma de Listas de la Compra

##  Descripción

El proyecto consiste en el desarrollo de una **aplicación multiplataforma** diseñada con **Flutter** (para el cliente) y un **backend en C# (ASP.NET Core)**.  
El objetivo es permitir a los usuarios **crear y gestionar listas de la compra** de forma **individual o colaborativa**.


La aplicación se centrará en productos de **Mercadona**, obtenidos a través de su **API no oficial**, y complementados con datos de la **API de OpenFoodFacts** para enriquecer la información nutricional (calorías, macronutrientes y **NutriScore**).

El sistema permitirá:
- Añadir productos a un carrito.
- Consultar el **precio total** y el **resumen nutricional** global.
- **Exportar** la lista de productos en formatos **PDF o CSV**.
- Permitir la **colaboración en tiempo real** entre varios usuarios sobre un mismo carrito.

---

##  Funcionalidades principales

### 1.  Búsqueda de productos
- Consultar el catálogo de productos de **Mercadona** (precio, imagen, descripción).
- Completar los datos con información nutricional y **NutriScore** desde la **API de OpenFoodFacts**.

---

### 2.  Gestión del carrito de compra
- Añadir o eliminar productos del carrito.
- Mostrar en tiempo real el **precio total** de la compra.
- Calcular automáticamente **calorías** y **macronutrientes globales**.

---

### 3.  Historial de compras
- Guardar carritos finalizados.
- Reabrir y reutilizar listas anteriores.

---

### 4.  Productos favoritos
- Marcar productos frecuentes como favoritos.
- Acceso rápido a ellos para añadirlos al carrito.

---

### 5.  Filtros saludables
- Filtrar productos por **NutriScore** o por bajo contenido en **azúcares** y **grasas**.
- Facilitar **elecciones más saludables** al usuario.

---

### 6.  Visualización gráfica
- Mostrar gráficas con la **distribución de macronutrientes** del carrito.
- Permitir interpretar la compra de forma **visual e intuitiva**.

---

### 7.  Múltiples listas de la compra
- Crear diferentes carritos activos (por ejemplo: *“Compra semanal”*, *“Fiesta”*).

####  Carrito colaborativo
- Compartir un mismo carrito entre varios usuarios.
- Sincronización en **tiempo real**, para que todos vean los cambios instantáneamente.

---

### 8.  Exportación de listas
- Generar archivos en **PDF o CSV** con la lista de compra.
- Compartir fácilmente por **WhatsApp**, **correo** u otras aplicaciones.

---

### 9.  Notificaciones inteligentes
- Recordatorios de **carritos sin terminar**.
- Alertas cuando el **gasto supera un límite** definido por el usuario.

---

##  Tecnologías previstas

| Área | Tecnología |
|------|-------------|
| **Frontend** | Flutter |
| **Backend** | C# (ASP.NET Core) |
| **APIs externas** | Mercadona (no oficial), OpenFoodFacts |
| **Base de datos** | Por definir (PostgreSQL, MongoDB, etc.) |

---

##  Objetivos del proyecto
- Ofrecer una **herramienta práctica y visual** para la gestión de listas de la compra.
- Promover **hábitos de compra saludables** mediante información nutricional integrada.
- Implementar **colaboración en tiempo real** entre usuarios.

---

##  Estado actual y próximos pasos
- [x] Definición del alcance inicial del proyecto  
- [ ] Diseño de arquitectura backend (C# / ASP.NET Core)  
- [ ] Diseño del frontend (Flutter)  
- [ ] Integración de APIs (Mercadona + OpenFoodFacts)  
- [ ] Implementación de funcionalidades colaborativas en tiempo real  

---

##  Fecha

 *Última actualización:* **28 de octubre de 2025**
