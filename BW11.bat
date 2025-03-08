@echo off
title BW11 - Windows 11 Bypass
mode 80,25
color 0A
cls

REM Autor: Nuntius Dev (Optimizado)
REM GitHub: https://github.com/nuntius-dev
REM Bypass Windows 11 System Requirements

:: Verificar permisos de administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Este script debe ejecutarse como administrador.
    pause
    exit /b
)

:: Backup del registro antes de modificarlo
echo Creando backup del registro...
reg export "HKEY_LOCAL_MACHINE\SYSTEM\Setup" "backup_registro.reg" /y >nul
echo Backup guardado como backup_registro.reg

:menu
cls
echo ==================================================
echo         BW11 - Bypass Windows 11 Checks
echo ==================================================
echo 1. Omitir requisitos de Windows 11
echo 2. Restaurar backup del registro
echo 3. Salir
echo ==================================================
set /p choice=Seleccione una opcion: 

if "%choice%"=="1" goto bypass
if "%choice%"=="2" goto restore
if "%choice%"=="3" exit

echo [ERROR] Opción no válida. Intente de nuevo.
pause
goto menu

:bypass
cls
echo Aplicando modificaciones...

:: Verificar si las claves ya existen antes de agregarlas
for %%K in (BypassCPUCheck BypassStorageCheck BypassRAMCheck BypassTPMCheck BypassSecureBootCheck BypassNRO OOBEBypassNRO BypassMSARequirement) do (
    reg query "HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig" /v %%K >nul 2>&1
    if errorlevel 1 (
        reg add "HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig" /v %%K /f /t REG_DWORD /d 1
        echo [+] %%K agregado.
    ) else (
        echo [!] %%K ya existe, no se realizaron cambios.
    )
)

:: Omitir el chequeo de TPM y CPU en la actualización
reg add "HKEY_LOCAL_MACHINE\SYSTEM\Setup\MoSetup" /v AllowUpgradesWithUnsupportedTPMOrCPU /f /t REG_DWORD /d 1
echo [+] Permitir actualizaciones con CPU/TPM no compatibles.

echo ==================================================
echo [✔] Todos los cambios han sido aplicados.
echo Reinicie su PC para que los cambios surtan efecto.
pause
goto menu

:restore
cls
echo Restaurando backup del registro...
reg import backup_registro.reg
echo [✔] Registro restaurado. Reinicie su PC.
pause
goto menu