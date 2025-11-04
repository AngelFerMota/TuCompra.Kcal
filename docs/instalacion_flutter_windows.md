# Guía de instalación: Flutter + Dart en Windows (VS Code)

Esta guía te lleva paso a paso para instalar Flutter (que ya incluye Dart), configurar Android Studio/SDK, y dejar listo Visual Studio Code en Windows 10/11 usando PowerShell.

> Recomendado: usar una ventana de PowerShell con permisos de usuario normal. Abre una nueva terminal después de cambiar variables de entorno.

## Requisitos
- Windows 10/11 de 64 bits
- 10+ GB de espacio libre (Android SDK y emuladores consumen bastante)
- Conexión a Internet estable
- VS Code instalado: https://code.visualstudio.com/

---

## Opción A (rápida): Instalación con winget

1) Instala prerequisitos
```powershell
winget install -e --id Git.Git
winget install -e --id Microsoft.OpenJDK.17
winget install -e --id Google.AndroidStudio
```

2) Instala Flutter SDK (incluye Dart)
```powershell
winget install -e --id Google.Flutter
```

3) Configura variables de entorno Android SDK y PATH

Android Studio suele instalar el SDK en:
- `%LOCALAPPDATA%\Android\Sdk`

Configúralo (ejecuta y luego abre una nueva terminal):
```powershell
setx ANDROID_SDK_ROOT "$env:LOCALAPPDATA\Android\Sdk"
setx ANDROID_HOME "$env:LOCALAPPDATA\Android\Sdk"
setx PATH "$env:PATH;$env:LOCALAPPDATA\Android\Sdk\platform-tools"
```

Si Flutter no quedó automáticamente en el PATH (instalado por winget), añade:
- `%LOCALAPPDATA%\Programs\Flutter\bin`
```powershell
setx PATH "$env:PATH;$env:LOCALAPPDATA\Programs\Flutter\bin"
```

Cierra esta terminal y abre una nueva para que los cambios apliquen.

4) Instala extensiones de VS Code
- Abre VS Code y busca e instala:
  - "Flutter" (id: Dart-Code.flutter)
  - "Dart" (id: Dart-Code.dart-code)

Si tienes `code` en el PATH, puedes usar:
```powershell
code --install-extension Dart-Code.flutter
code --install-extension Dart-Code.dart-code
```

5) Verifica y acepta licencias
```powershell
flutter --version
flutter doctor
flutter doctor --android-licenses
flutter doctor
```

En Android Studio > SDK Manager, asegúrate de tener instalados:
- Android SDK Platform-Tools
- Android SDK Build-Tools
- Android Emulator
- Al menos una plataforma (por ejemplo, Android 14 o 15)

---

## Opción B (manual): Instalación sin winget

1) Git y JDK 17
- Git: https://git-scm.com/download/win
- Microsoft OpenJDK 17: https://learn.microsoft.com/java/openjdk/download

2) Flutter SDK
- Descarga el ZIP estable: https://docs.flutter.dev/get-started/install/windows
- Extrae en `C:\src\flutter` (recomendado)
- Agrega `C:\src\flutter\bin` al PATH de usuario:
  - Panel de control > Sistema > Configuración avanzada > Variables de entorno > Editar PATH (usuario) > Agregar ruta

3) Android Studio + SDK
- Instala: https://developer.android.com/studio
- Abre Android Studio > SDK Manager y selecciona:
  - SDK Platforms: al menos una versión (Android 14/15)
  - SDK Tools: Platform-Tools, Build-Tools, Emulator
- Variables de entorno (ajusta TU_USUARIO):
  - `ANDROID_SDK_ROOT = C:\Users\TU_USUARIO\AppData\Local\Android\Sdk`
  - Añade `C:\Users\TU_USUARIO\AppData\Local\Android\Sdk\platform-tools` al PATH

4) Extensiones de VS Code y verificación
- Instala las extensiones de Flutter y Dart (ver Opción A)
- Ejecuta:
```powershell
flutter --version
flutter doctor
flutter doctor --android-licenses
flutter doctor
```

---

## Crear y ejecutar un proyecto de ejemplo

1) Crea el proyecto
```powershell
flutter create hello_kcal
cd hello_kcal
```

2) Inicia un emulador o conecta un dispositivo
- Android Studio > Device Manager > Create device > Start
- O conecta un equipo físico con Depuración USB habilitada

3) Verifica dispositivos y ejecuta
```powershell
flutter devices
flutter run
```

Si todo está correcto, verás la app de ejemplo corriendo.

---

## (Opcional) Desarrollo para Windows Desktop

Para compilar y ejecutar Flutter para Windows:
1) Instala Visual Studio 2022 con "Desktop development with C++" o "Build Tools" equivalentes.
2) Activa el soporte en Flutter:
```powershell
flutter config --enable-windows-desktop
flutter doctor -v
```
3) Ejecuta en Windows:
```powershell
flutter run -d windows
```

---

## Solución de problemas

- PATH no aplicado: `setx` afecta solo nuevas sesiones. Cierra y abre PowerShell.
- Licencias Android: ejecuta `flutter doctor --android-licenses` y acepta todas.
- Falta `cmdline-tools`: en Android Studio > SDK Manager > SDK Tools, marca "Android SDK Command-line Tools".
- `adb` no se reconoce: revisa que `...\Android\Sdk\platform-tools` esté en PATH.
- Emulador lento: activa "Windows Hypervisor Platform" en "Activar o desactivar características de Windows".
- Problemas con Gradle/Proxy: configura proxy del sistema o `gradle.properties` según tu red.
- Flutter no encuentra SDK: en VS Code, Settings > busca `flutterSdkPath` o usa `where flutter` para confirmar ruta.

---

## Actualización y desinstalación

- Actualizar Flutter:
```powershell
flutter upgrade
```
- Actualizar con winget:
```powershell
winget upgrade --all
```
- Desinstalar Flutter (winget):
```powershell
winget uninstall Google.Flutter
```

---

## Rutas típicas de instalación (referencia)
- Flutter (winget): `%LOCALAPPDATA%\Programs\Flutter\bin`
- Android SDK: `%LOCALAPPDATA%\Android\Sdk`
- Emuladores: `%LOCALAPPDATA%\Android\Sdk\emulator`

---

¿Necesitas que prepare un script de PowerShell que automatice todo con `winget` y valide con `flutter doctor` automáticamente? Puedo añadirlo a este repositorio.
