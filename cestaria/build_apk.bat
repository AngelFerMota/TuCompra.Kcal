@echo off
echo ========================================
echo   Cestaria - Compilando APK Release
echo ========================================
echo.

REM Verificar si Flutter esta instalado
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo ERROR: Flutter no encontrado en el PATH
    echo Por favor, instala Flutter o agrega Flutter al PATH del sistema
    pause
    exit /b 1
)

echo Limpiando proyecto...
call flutter clean

echo.
echo Obteniendo dependencias...
call flutter pub get

echo.
echo Generando codigo (Freezed, JsonSerializable)...
call flutter pub run build_runner build --delete-conflicting-outputs

echo.
echo Compilando APK de produccion...
echo (Esto puede tardar varios minutos)
echo.

call flutter build apk --release

if %errorlevel% eq 0 (
    echo.
    echo ========================================
    echo   APK compilado correctamente!
    echo ========================================
    echo.
    echo Ubicacion: build\app\outputs\flutter-apk\app-release.apk
    echo.
    explorer build\app\outputs\flutter-apk
) else (
    echo.
    echo ERROR: Fallo la compilacion del APK
)

pause
