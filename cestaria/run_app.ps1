# Script PowerShell para ejecutar Cestaria
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Cestaria - Ejecutando aplicacion" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar si Flutter está instalado
$flutterPath = Get-Command flutter -ErrorAction SilentlyContinue
if (-not $flutterPath) {
    Write-Host "ERROR: Flutter no encontrado en el PATH" -ForegroundColor Red
    Write-Host "Por favor, instala Flutter o agrega Flutter al PATH del sistema" -ForegroundColor Yellow
    Read-Host "Presiona Enter para salir"
    exit 1
}

Write-Host "Flutter encontrado: $($flutterPath.Source)" -ForegroundColor Green
Write-Host ""

# Verificar dependencias
Write-Host "Verificando dependencias..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Fallo al obtener dependencias" -ForegroundColor Red
    Read-Host "Presiona Enter para salir"
    exit 1
}

Write-Host ""
Write-Host "Ejecutando la aplicacion..." -ForegroundColor Green
Write-Host "(Presiona Ctrl+C para detener)" -ForegroundColor Yellow
Write-Host ""

# Ejecutar Flutter
flutter run

Read-Host "Presiona Enter para salir"
