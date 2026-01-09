@echo off
echo ========================================
echo   Cestaria - Ejecutando aplicacion
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

echo Verificando dependencias...
call flutter pub get
if %errorlevel% neq 0 (
    echo ERROR: Fallo al obtener dependencias
    pause
    exit /b 1
)

echo.
echo Ejecutando la aplicacion...
echo (Presiona Ctrl+C para detener)
echo.

call flutter run

pause
