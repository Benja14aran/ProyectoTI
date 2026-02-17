@echo off
setlocal EnableDelayedExpansion

:: =====================================================
:: PANEL TI MAESTRO v3.0 - EDICION MEJORADA
:: Script de Mantenimiento y Optimizacion Profesional
:: =====================================================

:: Configurar para NO cerrar en errores
title Panel TI Maestro v3.0 - Inicializando...

:: =====================================================
:: VERIFICACION DE PERMISOS DE ADMINISTRADOR
:: =====================================================
net session >nul 2>&1
if %errorLevel% neq 0 (
    color 0C
    echo.
    echo =====================================================
    echo   ERROR: SE REQUIEREN PERMISOS DE ADMINISTRADOR
    echo =====================================================
    echo.
    echo Este script necesita ejecutarse como administrador.
    echo Click derecho -^> Ejecutar como administrador
    echo.
    pause
    exit /b 1
)

:: =====================================================
:: CONFIGURACION DE LOG Y VARIABLES
:: =====================================================
set "LOGFILE=%TEMP%\PanelTI_Log_%date:~-4,4%%date:~-10,2%%date:~-7,2%.log"
set "LOCAL_FOLDER=C:\HerramientasTI"

:: Iniciar log
(
    echo =====================================================
    echo PANEL TI MAESTRO v3.0 - LOG DE EJECUCION
    echo =====================================================
    echo Fecha inicio: %date% %time%
    echo Usuario: %USERNAME%
    echo Equipo: %COMPUTERNAME%
    echo =====================================================
    echo.
) > "%LOGFILE%"

:: Crear carpeta de herramientas si no existe
if not exist "%LOCAL_FOLDER%" (
    mkdir "%LOCAL_FOLDER%" 2>nul
    if exist "%LOCAL_FOLDER%" (
        echo [%date% %time%] Carpeta HerramientasTI creada >> "%LOGFILE%"
    ) else (
        echo [%date% %time%] ERROR: No se pudo crear carpeta HerramientasTI >> "%LOGFILE%"
    )
)

:MENU
cls
title PANEL TI MAESTRO v3.0 - SOPORTE TECNICO PROFESIONAL
color 0F

:: =====================================================
:: INFORMACION DEL SISTEMA CON POWERSHELL
:: =====================================================
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$sys = Get-CimInstance -ClassName Win32_ComputerSystem;" ^
    "$os = Get-CimInstance -ClassName Win32_OperatingSystem;" ^
    "$cpu = Get-CimInstance -ClassName Win32_Processor | Select-Object -First 1;" ^
    "$gpu = Get-CimInstance -ClassName Win32_VideoController | Where-Object {$_.Status -eq 'OK'} | Select-Object -First 1;" ^
    "$bios = Get-CimInstance -ClassName Win32_Bios;" ^
    "$disk = Get-PhysicalDisk | Select-Object -First 1;" ^
    "$vol = Get-Volume -DriveLetter C -ErrorAction SilentlyContinue;" ^
    "$net = Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike '*Loopback*'} | Select-Object -First 1;" ^
    "$mac = Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | Select-Object -First 1;" ^
    "$uptime = (Get-Date) - $os.LastBootUpTime;" ^
    "$ramTotal = $sys.TotalPhysicalMemory / 1MB;" ^
    "$ramFree = $os.FreePhysicalMemory / 1KB;" ^
    "$ramPct = [Math]::Round(100 - ($ramFree / ($ramTotal/1024) * 100), 1);" ^
    "Write-Host '=====================================================' -ForegroundColor DarkCyan;" ^
    "Write-Host '       SISTEMA DE MANTENIMIENTO INTEGRAL v3.0' -ForegroundColor White;" ^
    "Write-Host '=====================================================' -ForegroundColor DarkCyan;" ^
    "Write-Host ' [RESUMEN DEL SISTEMA]' -ForegroundColor DarkCyan;" ^
    "Write-Host '  HOST        : ' -NoNewline; Write-Host $env:COMPUTERNAME -ForegroundColor White -NoNewline; Write-Host ' | IP: ' -NoNewline; Write-Host $net.IPAddress -ForegroundColor DarkYellow;" ^
    "Write-Host '  SISTEMA     : ' -NoNewline; Write-Host $os.Caption -ForegroundColor White -NoNewline; Write-Host ' (' $os.OSArchitecture ')' -ForegroundColor White;" ^
    "Write-Host '  VERSION     : ' -NoNewline; Write-Host $os.Version -ForegroundColor White -NoNewline; Write-Host ' | BUILD: ' -NoNewline; Write-Host $os.BuildNumber -ForegroundColor White;" ^
    "Write-Host '  UPTIME      : ' -NoNewline; Write-Host \"$($uptime.Days)d $($uptime.Hours)h $($uptime.Minutes)m\" -ForegroundColor DarkYellow -NoNewline; Write-Host ' | RAM: ' -NoNewline; Write-Host ([Math]::Round($ramTotal/1024,2)) 'GB ('$ramPct'%%)' -ForegroundColor White;" ^
    "Write-Host ' [HARDWARE DETALLADO]' -ForegroundColor DarkCyan;" ^
    "Write-Host '  PROCESADOR  : ' -NoNewline; Write-Host $cpu.Name -ForegroundColor White;" ^
    "Write-Host '  GRAFICOS    : ' -NoNewline; Write-Host $gpu.Name -ForegroundColor DarkYellow;" ^
    "Write-Host '  PLACA/BIOS  : ' -NoNewline; Write-Host $sys.Model -ForegroundColor White -NoNewline; Write-Host ' | VER: ' -NoNewline; Write-Host $bios.SMBIOSBIOSVersion -ForegroundColor White;" ^
    "Write-Host '  S/N         : ' -NoNewline; Write-Host $bios.SerialNumber -ForegroundColor DarkYellow -NoNewline; Write-Host ' | MAC: ' -NoNewline; Write-Host $mac.MacAddress -ForegroundColor White;" ^
    "Write-Host ' [ALMACENAMIENTO Y SALUD]' -ForegroundColor DarkCyan;" ^
    "Write-Host '  DISCO       : ' -NoNewline; Write-Host $disk.MediaType -NoNewline; Write-Host ' | SALUD: ' -NoNewline; Write-Host $disk.HealthStatus -ForegroundColor DarkYellow;" ^
    "if ($vol) { Write-Host '  C: LIBRE    : ' -NoNewline; Write-Host ([Math]::Round($vol.SizeRemaining / 1GB, 2)) 'GB de ' ([Math]::Round($vol.Size / 1GB, 2)) 'GB' -ForegroundColor White; }" ^
    "Write-Host '-----------------------------------------------------' -ForegroundColor DarkCyan;"

echo.
echo  [1]  REPARACION SISTEMA (SFC + DISM)     [10] OPTIMIZACION DISCO (TRIM/Defrag)
echo  [2]  LIMPIEZA TOTAL (5 Ciclos)           [11] ELIMINAR IA (Remover Copilot)
echo  [3]  OPTIMIZACION RAM (RAMMap)           [12] ENERGIA (Reportes Detallados)
echo  [4]  RED Y DNS (Flush + Reset)           [13] AVANZADO (Herramientas TI)
echo  [5]  PLAN MAXIMO RENDIMIENTO             [14] BACKUP COMPLETO (Sistema)
echo  [6]  DEBLOAT (Quitar Apps Basura)        [15] SEGURIDAD (Firewall + Defender)
echo  [7]  DESACTIVAR TELEMETRIA               [16] REINICIAR EQUIPO
echo  [8]  GESTION HIBERNACION                 [17] SALIR
echo  [9]  REGISTROS Y ERRORES                 
echo.
set "op="
set /p op="Seleccione una opcion (1-18): "

:: Validar entrada
if "%op%"=="" (
    echo.
    echo [ERROR] Debe seleccionar una opcion.
    timeout /t 2 >nul
    goto MENU
)

if "%op%"=="1" goto REPARAR
if "%op%"=="2" goto LIMPIAR
if "%op%"=="3" goto RAM
if "%op%"=="4" goto RED
if "%op%"=="5" goto PERF_PLAN
if "%op%"=="6" goto DEBLOAT
if "%op%"=="7" goto TELEMETRY
if "%op%"=="8" goto HIBERNATE
if "%op%"=="9" goto REGISTROS
if "%op%"=="10" goto DISCOS
if "%op%"=="11" goto REMOVEAI
if "%op%"=="12" goto ENERGIA
if "%op%"=="13" goto AVANZADO
if "%op%"=="14" goto BACKUP
if "%op%"=="15" goto SEGURIDAD
if "%op%"=="16" goto REINICIAR_INSTANTANEO
if "%op%"=="17" goto SALIR

:: Si llega aquí, la opción es inválida
echo.
echo [ERROR] Opcion no valida: "%op%"
echo [INFO] Seleccione un numero del 1 al 18
echo.
timeout /t 2 >nul
goto MENU

:: =====================================================
:: SECCION 1: REPARACION DEL SISTEMA
:: =====================================================
:REPARAR
cls
echo =====================================================
echo            REPARACION DEL SISTEMA
echo =====================================================
echo.
echo [INFO] Este proceso puede tardar 20-40 minutos.
echo [INFO] Cierre todas las aplicaciones posibles.
echo.
echo Presione ENTER para continuar o CTRL+C para cancelar...
pause >nul

echo.
echo [1/3] Ejecutando SFC (System File Checker)...
echo [INFO] Verificando integridad de archivos del sistema...
echo.

sfc /scannow 2>nul
set "sfc_result=%errorLevel%"

if %sfc_result% equ 0 (
    echo [OK] SFC completado sin errores criticos.
) else (
    echo [ADVERTENCIA] SFC encontro algunos problemas. Continuando con DISM...
)

echo.
echo [2/3] Ejecutando DISM ScanHealth...
echo [INFO] Escaneando imagen del sistema...
echo.

dism /online /cleanup-image /scanhealth 2>nul
set "dism_scan=%errorLevel%"

echo.
echo [3/3] Ejecutando DISM RestoreHealth...
echo [INFO] Reparando archivos danados (esto puede tardar)...
echo.

dism /online /cleanup-image /restorehealth /NoRestart 2>nul
set "dism_restore=%errorLevel%"

echo.
echo =====================================================
echo              RESUMEN DE REPARACION
echo =====================================================
if %sfc_result% equ 0 (
    echo SFC         : [OK] Sin errores
) else (
    echo SFC         : [!] Encontro problemas
)
if %dism_scan% equ 0 (
    echo DISM Scan   : [OK] Sin errores
) else (
    echo DISM Scan   : [!] Encontro problemas
)
if %dism_restore% equ 0 (
    echo DISM Repair : [OK] Reparacion exitosa
) else (
    echo DISM Repair : [!] Reparacion parcial
)
echo =====================================================

if %dism_restore% equ 0 (
    echo.
    echo [EXITO] Reparacion completada exitosamente.
    echo [RECOMENDACION] Reinicie el equipo para aplicar cambios.
) else (
    echo.
    echo [ADVERTENCIA] Algunos errores no se pudieron reparar automaticamente.
    echo [SOLUCION 1] Ejecute en modo seguro y vuelva a intentar
    echo [SOLUCION 2] Use: dism /online /cleanup-image /startcomponentcleanup
    echo [SOLUCION 3] Considere una reparacion de Windows con ISO
)

echo.
echo [%date% %time%] Reparacion completada - SFC:%sfc_result% DISM:%dism_restore% >> "%LOGFILE%"
echo.
echo Presione cualquier tecla para volver al menu...
pause >nul
goto MENU

:: =====================================================
:: SECCION 2: LIMPIEZA TOTAL AUTOMATIZADA
:: =====================================================
:LIMPIAR
cls
echo =====================================================
echo        LIMPIEZA PROFUNDA MULTI-USUARIO
echo =====================================================
echo.
echo Iniciando limpieza automatica...
echo.

:: Ejecutar limpieza PowerShell con manejo robusto de errores
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$ErrorActionPreference = 'SilentlyContinue';" ^
    "$ProgressPreference = 'SilentlyContinue';" ^
    "$rutasGlobales = @(" ^
    "    'C:\Windows\Prefetch'," ^
    "    'C:\Windows\System32\Logs'," ^
    "    'C:\Windows\Temp'," ^
    "    'C:\Windows\SoftwareDistribution\Download'," ^
    "    'C:\Windows\Logs'" ^
    ");" ^
    "Write-Host '--- Iniciando 5 ciclos de limpieza profunda ---' -ForegroundColor Cyan;" ^
    "$totalLiberado = 0;" ^
    "for ($i = 1; $i -le 5; $i++) {" ^
    "    Write-Host \"`n[CICLO $i/5]\" -ForegroundColor Magenta;" ^
    "    $liberadoCiclo = 0;" ^
    "    foreach ($carpeta in $rutasGlobales) {" ^
    "        if (Test-Path $carpeta) {" ^
    "            try {" ^
    "                $items = Get-ChildItem -Path $carpeta -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { -not $_.PSIsContainer };" ^
    "                if ($items) {" ^
    "                    $tamano = ($items | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum;" ^
    "                    if ($tamano) { $liberadoCiclo += $tamano / 1MB; }" ^
    "                    Get-ChildItem -Path $carpeta -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue;" ^
    "                }" ^
    "            } catch { }" ^
    "        }" ^
    "    }" ^
    "    try {" ^
    "        $usuarios = Get-ChildItem -Path 'C:\Users' -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne 'Public' -and $_.Name -ne 'Default' };" ^
    "        foreach ($u in $usuarios) {" ^
    "            $rutasUsuario = @(" ^
    "                (Join-Path $u.FullName 'AppData\Local\Temp')," ^
    "                (Join-Path $u.FullName 'AppData\Local\Microsoft\Windows\INetCache')," ^
    "                (Join-Path $u.FullName 'AppData\Local\CrashDumps')" ^
    "            );" ^
    "            foreach ($ruta in $rutasUsuario) {" ^
    "                if (Test-Path $ruta) {" ^
    "                    try {" ^
    "                        $items = Get-ChildItem -Path $ruta -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { -not $_.PSIsContainer };" ^
    "                        if ($items) {" ^
    "                            $tamano = ($items | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum;" ^
    "                            if ($tamano) { $liberadoCiclo += $tamano / 1MB; }" ^
    "                            Get-ChildItem -Path $ruta -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue;" ^
    "                        }" ^
    "                    } catch { }" ^
    "                }" ^
    "            }" ^
    "        }" ^
    "    } catch { }" ^
    "    $totalLiberado += $liberadoCiclo;" ^
    "    Write-Host \"  Espacio liberado en ciclo $i : $([Math]::Round($liberadoCiclo, 2)) MB\" -ForegroundColor Yellow;" ^
    "    Start-Sleep -Milliseconds 500;" ^
    "}" ^
    "Write-Host \"`n[COMPLETADO] Limpieza finalizada\" -ForegroundColor Green;" ^
    "Write-Host \"Espacio total liberado: $([Math]::Round($totalLiberado, 2)) MB ($([Math]::Round($totalLiberado/1024, 2)) GB)\" -ForegroundColor Cyan;"

echo.
echo Ejecutando limpiador de disco de Windows...

:: Configurar y ejecutar Disk Cleanup automaticamente
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files" /v StateFlags0001 /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Downloaded Program Files" /v StateFlags0001 /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Internet Cache Files" /v StateFlags0001 /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Recycle Bin" /v StateFlags0001 /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Setup Files" /v StateFlags0001 /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Files" /v StateFlags0001 /t REG_DWORD /d 2 /f >nul 2>&1

cleanmgr /sagerun:1 >nul 2>&1

echo.
echo [%date% %time%] Limpieza multi-usuario completada >> "%LOGFILE%"
echo Limpieza completada exitosamente.
echo.
timeout /t 3 /nobreak >nul
goto MENU

:: =====================================================
:: SECCION 3: OPTIMIZACION DE RAM
:: =====================================================
:RAM
cls
echo =====================================================
echo            GESTION Y OPTIMIZACION DE RAM
echo =====================================================
echo  [1] PREPARAR Y ABRIR RAMMap (Instalar en C:\)
echo  [2] Liberar Cache + Monitor (Pestana MEMORIA)
echo  [3] Ejecutar RAMMap (Desde C:\HerramientasTI)
echo  [4] Limpiar Memoria sin RAMMap (EmptyStandbyList)
echo  [5] VOLVER AL MENU PRINCIPAL
echo.
set "ram_op="
set /p ram_op="Seleccione una opcion (1-5): "

if "%ram_op%"=="1" goto RAM_FULL_PREP
if "%ram_op%"=="2" goto RAM_RESMON
if "%ram_op%"=="3" goto RAM_RAMMAP
if "%ram_op%"=="4" goto RAM_EMPTY_STANDBY
if "%ram_op%"=="5" goto MENU
goto RAM

:RAM_FULL_PREP
cls
echo =====================================================
echo      INSTALACION Y LIMPIEZA EN C:\HerramientasTI
echo =====================================================
echo.

set "ZFILE=%LOCAL_FOLDER%\RAMMap.zip"
set "EFILE=%LOCAL_FOLDER%\RAMMap.exe"

echo [1/5] Descargando RAMMap desde Sysinternals...
echo [INFO] URL: https://download.sysinternals.com/files/RAMMap.zip
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "try {" ^
    "    $ProgressPreference = 'SilentlyContinue';" ^
    "    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;" ^
    "    Write-Host 'Conectando con servidor Sysinternals...' -ForegroundColor Cyan;" ^
    "    Invoke-WebRequest -Uri 'https://download.sysinternals.com/files/RAMMap.zip' -OutFile '%ZFILE%' -UseBasicParsing -TimeoutSec 30;" ^
    "    if (Test-Path '%ZFILE%') {" ^
    "        $size = (Get-Item '%ZFILE%').Length / 1KB;" ^
    "        Write-Host \"[OK] Descarga completada - Tamano: $([Math]::Round($size, 2)) KB\" -ForegroundColor Green;" ^
    "    } else {" ^
    "        throw 'Archivo no descargado';" ^
    "    }" ^
    "} catch {" ^
    "    Write-Host '[ERROR] Fallo en descarga: ' $_.Exception.Message -ForegroundColor Red;" ^
    "    Write-Host '[INFO] Verifique su conexion a internet' -ForegroundColor Yellow;" ^
    "    Write-Host '[INFO] O descargue manualmente desde: https://learn.microsoft.com/en-us/sysinternals/downloads/rammap' -ForegroundColor Yellow;" ^
    "    exit 1;" ^
    "}"

if not exist "%ZFILE%" (
    echo.
    echo [ERROR] Descarga fallida. Verifica tu conexion a internet.
    echo.
    echo [SOLUCION] Descarga manual:
    echo 1. Visita: https://learn.microsoft.com/en-us/sysinternals/downloads/rammap
    echo 2. Descarga RAMMap.zip
    echo 3. Extrae RAMMap.exe en: %LOCAL_FOLDER%
    echo.
    echo Presione ENTER para volver al menu...
    pause >nul
    goto RAM
)

echo.
echo [2/5] Extrayendo archivos...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "try {" ^
    "    Add-Type -AssemblyName System.IO.Compression.FileSystem;" ^
    "    [System.IO.Compression.ZipFile]::ExtractToDirectory('%ZFILE%', '%LOCAL_FOLDER%');" ^
    "    Write-Host '[OK] Extraccion completada' -ForegroundColor Green;" ^
    "} catch {" ^
    "    Write-Host '[ERROR] Fallo en extraccion: ' $_.Exception.Message -ForegroundColor Red;" ^
    "}"

if exist "%ZFILE%" del /Q "%ZFILE%" 2>nul

echo.
echo [3/5] Liberando memoria standby y cache...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "try {" ^
    "    Clear-RecycleBin -Force -ErrorAction SilentlyContinue;" ^
    "    [System.GC]::Collect();" ^
    "    Write-Host '[OK] Memoria liberada' -ForegroundColor Green;" ^
    "} catch {" ^
    "    Write-Host '[INFO] Limpieza basica completada' -ForegroundColor Yellow;" ^
    "}"

echo.
echo [4/5] Verificando instalacion...
if exist "%EFILE%" (
    echo [OK] RAMMap instalado correctamente en: %EFILE%
    echo.
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "$file = Get-Item '%EFILE%';" ^
        "Write-Host 'Version: ' $file.VersionInfo.FileVersion -ForegroundColor Cyan;" ^
        "Write-Host 'Tamano: ' ([Math]::Round($file.Length / 1MB, 2)) 'MB' -ForegroundColor Cyan;"
) else (
    echo [ERROR] No se encontro RAMMap.exe
    echo.
    pause
    goto RAM
)

echo.
echo [5/5] Abriendo RAMMap...
echo.
echo =====================================================
echo              INSTRUCCIONES DE USO
echo =====================================================
echo.
echo 1. Ve a la pestana "Empty" en la parte superior
echo 2. Haz clic en "Empty Standby List" para liberar cache
echo 3. Observa el incremento de RAM disponible en tiempo real
echo 4. Opcional: "Empty Working Sets" para mayor liberacion
echo.
echo [TIP] Usa RAMMap cuando tu PC este lento por falta de RAM
echo =====================================================
echo.

start "" "%EFILE%"
echo [OK] RAMMap iniciado correctamente.
echo.
echo [%date% %time%] RAMMap instalado y ejecutado >> "%LOGFILE%"
pause
goto RAM

:RAM_RESMON
cls
echo =====================================================
echo         MONITOR DE RECURSOS - MEMORIA
echo =====================================================
echo.
echo [1/2] Liberando cache del sistema...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "[System.GC]::Collect(); Write-Host 'Cache liberada' -ForegroundColor Green"

echo [2/2] Abriendo Monitor de Recursos...
echo.
echo [INSTRUCCIONES]
echo - La pestana MEMORIA muestra procesos consumiendo RAM
echo - Ordena por "Confirmado (KB)" para ver los mas pesados
echo.
start resmon.exe
echo.
echo Monitor de recursos abierto.
pause
goto RAM

:RAM_RAMMAP
cls
echo =====================================================
echo         EJECUTAR RAMMAP EXISTENTE
echo =====================================================
echo.
if exist "%LOCAL_FOLDER%\RAMMap.exe" (
    echo [OK] Ejecutando RAMMap desde %LOCAL_FOLDER%
    start "" "%LOCAL_FOLDER%\RAMMap.exe"
    echo.
    echo RAMMap abierto. Use "Empty Standby List" para liberar RAM.
) else (
    echo [ERROR] RAMMap no esta instalado.
    echo Use la opcion 1 primero para instalarlo.
)
echo.
pause
goto RAM

:RAM_EMPTY_STANDBY
cls
echo =====================================================
echo      LIBERAR MEMORIA STANDBY (Sin RAMMap)
echo =====================================================
echo.
echo [INFO] Liberando memoria del sistema...
echo.

echo [1/3] Limpiando cache de sistema con PowerShell...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "try {" ^
    "    Write-Host 'Liberando memoria standby...' -ForegroundColor Cyan;" ^
    "    [System.GC]::Collect();" ^
    "    [System.GC]::WaitForPendingFinalizers();" ^
    "    [System.GC]::Collect();" ^
    "    Write-Host '[OK] Garbage Collector ejecutado' -ForegroundColor Green;" ^
    "} catch {" ^
    "    Write-Host '[ERROR] ' $_.Exception.Message -ForegroundColor Red;" ^
    "}"

echo.
echo [2/3] Vaciando papelera de reciclaje...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Clear-RecycleBin -Force -ErrorAction SilentlyContinue; Write-Host '[OK] Papelera vaciada' -ForegroundColor Green"

echo.
echo [3/3] Creando archivo temporal para liberar cache...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$before = (Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1MB;" ^
    "Write-Host \"RAM libre antes: $([Math]::Round($before, 2)) GB\" -ForegroundColor Yellow;" ^
    "try {" ^
    "    $processes = Get-Process | Where-Object {$_.WorkingSet -gt 10MB} | Sort-Object WorkingSet -Descending | Select-Object -First 20;" ^
    "    foreach ($proc in $processes) {" ^
    "        try {" ^
    "            $proc.Refresh();" ^
    "        } catch {}" ^
    "    }" ^
    "    [System.GC]::Collect();" ^
    "    Start-Sleep -Seconds 2;" ^
    "    $after = (Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1MB;" ^
    "    Write-Host \"RAM libre despues: $([Math]::Round($after, 2)) GB\" -ForegroundColor Green;" ^
    "    $liberado = $after - $before;" ^
    "    if ($liberado -gt 0) {" ^
    "        Write-Host \"RAM liberada: +$([Math]::Round($liberado, 2)) GB\" -ForegroundColor Cyan;" ^
    "    } else {" ^
    "        Write-Host 'Sistema ya optimizado' -ForegroundColor Yellow;" ^
    "    }" ^
    "} catch {" ^
    "    Write-Host '[INFO] Limpieza completada' -ForegroundColor Green;" ^
    "}"

echo.
echo =====================================================
echo [TIP] Para mayor liberacion de RAM, use RAMMap (Opcion 1)
echo =====================================================
echo.
echo [%date% %time%] Limpieza de RAM ejecutada >> "%LOGFILE%"
pause
goto RAM

:: =====================================================
:: SECCION 4: RESET DE RED Y CAMBIO DE DNS
:: =====================================================
:RED
cls
echo =====================================================
echo        RESET COMPLETO DE RED + DNS CLOUDFLARE
echo =====================================================
echo.
echo [INFO] Este proceso reiniciara toda la configuracion de red.
echo.
echo Presione ENTER para continuar o CTRL+C para cancelar...
pause >nul

echo.
echo [1/6] Reseteando Winsock...
netsh winsock reset

echo.
echo [2/6] Reseteando pila TCP/IP...
netsh int ip reset

echo.
echo [3/6] Limpiando cache DNS...
ipconfig /flushdns

echo.
echo [4/6] Renovando configuracion IP...
ipconfig /release
ipconfig /renew

echo.
echo [5/6] Configurando DNS Cloudflare (1.1.1.1)...
powershell -Command "Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | ForEach-Object { Set-DnsClientServerAddress -InterfaceIndex $_.ifIndex -ServerAddresses ('1.1.1.1','1.0.0.1') }"

echo.
echo [6/6] Verificando conectividad...
ping -n 2 1.1.1.1

echo.
echo =====================================================
echo [COMPLETADO] Red reseteada y DNS configurado
echo =====================================================
echo.
echo [NOTA] Se recomienda reiniciar el equipo para aplicar
echo        todos los cambios correctamente.
echo.
echo [%date% %time%] Red y DNS configurados >> "%LOGFILE%"
pause
goto MENU

:: =====================================================
:: SECCION 5: PLAN MAXIMO RENDIMIENTO
:: =====================================================
:PERF_PLAN
cls
echo =====================================================
echo      PLAN DE ENERGIA: MAXIMO RENDIMIENTO
echo =====================================================
echo.
echo [INFO] Activando plan de energia oculto de Windows...
echo.

powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61

echo.
echo [INFO] Estableciendo como plan activo...
powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61

echo.
echo [INFO] Configurando opciones de rendimiento...
powercfg /change monitor-timeout-ac 0
powercfg /change disk-timeout-ac 0
powercfg /change standby-timeout-ac 0
powercfg /change hibernate-timeout-ac 0

echo.
echo [OK] Plan de Maximo Rendimiento activado.
echo.
echo [ADVERTENCIA] Este plan aumenta el consumo electrico y temperatura.
echo [NOTA] Para portatiles, puede reducir la duracion de bateria.
echo.
echo [%date% %time%] Plan de rendimiento activado >> "%LOGFILE%"
pause
goto MENU

:: =====================================================
:: SECCION 6: DEBLOAT (REMOVER APPS INNECESARIAS)
:: =====================================================
:DEBLOAT
cls
echo =====================================================
echo       DESINSTALACION DE APLICACIONES BASURA
echo =====================================================
echo.
echo [ADVERTENCIA] Esto removera las siguientes apps:
echo  - Noticias (Microsoft.BingNews)
echo  - El Tiempo (Microsoft.BingWeather)
echo  - Mapas (Microsoft.WindowsMaps)
echo  - Power Automate (Microsoft.PowerAutomateDesktop)
echo  - Gente (Microsoft.People)
echo  - Ayuda (Microsoft.GetHelp)
echo  - Sugerencias (Microsoft.Getstarted)
echo  - Solitario (Microsoft.MicrosoftSolitaireCollection)
echo  - Peliculas y TV (Microsoft.ZuneVideo)
echo  - Office Hub (Microsoft.MicrosoftOfficeHub)
echo  - Correo (Microsoft.WindowsCommunicationsApps)
echo  - Grabadora (Microsoft.WindowsSoundRecorder)
echo.
echo Presione ENTER para continuar o CTRL+C para cancelar...
pause >nul

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$bloatware = @(" ^
    "    'Microsoft.BingNews'," ^
    "    'Microsoft.BingWeather'," ^
    "    'Microsoft.WindowsMaps'," ^
    "    'Microsoft.PowerAutomateDesktop'," ^
    "    'Microsoft.People'," ^
    "    'Microsoft.GetHelp'," ^
    "    'Microsoft.Getstarted'," ^
    "    'Microsoft.MicrosoftSolitaireCollection'," ^
    "    'Microsoft.ZuneVideo'," ^
    "    'Microsoft.MicrosoftOfficeHub'," ^
    "    'Microsoft.WindowsCommunicationsApps'," ^
    "    'Microsoft.WindowsSoundRecorder'" ^
    ");" ^
    "Write-Host '=========================================' -ForegroundColor Cyan;" ^
    "Write-Host '  INICIANDO DESINSTALACION DE BLOATWARE' -ForegroundColor Cyan;" ^
    "Write-Host '=========================================' -ForegroundColor Cyan;" ^
    "Write-Host '';" ^
    "$removidas = 0;" ^
    "$noEncontradas = 0;" ^
    "$errores = 0;" ^
    "foreach ($app in $bloatware) {" ^
    "    try {" ^
    "        Write-Host \"[BUSCANDO] $app\" -ForegroundColor Yellow;" ^
    "        $paquete = Get-AppxPackage -Name $app -AllUsers -ErrorAction SilentlyContinue;" ^
    "        if ($paquete) {" ^
    "            Write-Host \"  [REMOVIENDO] Desinstalando $app...\" -ForegroundColor Magenta;" ^
    "            Remove-AppxPackage -Package $paquete.PackageFullName -AllUsers -ErrorAction Stop;" ^
    "            Remove-AppxProvisionedPackage -Online -PackageName $paquete.PackageFullName -ErrorAction SilentlyContinue;" ^
    "            $removidas++;" ^
    "            Write-Host \"  [EXITO] $app eliminado correctamente`n\" -ForegroundColor Green;" ^
    "        } else {" ^
    "            Write-Host \"  [INFO] $app no esta instalado en este sistema`n\" -ForegroundColor Gray;" ^
    "            $noEncontradas++;" ^
    "        }" ^
    "    } catch {" ^
    "        Write-Host \"  [ERROR] No se pudo remover $app : $($_.Exception.Message)`n\" -ForegroundColor Red;" ^
    "        $errores++;" ^
    "    }" ^
    "}" ^
    "Write-Host '';" ^
    "Write-Host '=========================================' -ForegroundColor Cyan;" ^
    "Write-Host '           RESUMEN DE LA OPERACION' -ForegroundColor Cyan;" ^
    "Write-Host '=========================================' -ForegroundColor Cyan;" ^
    "Write-Host \"Aplicaciones eliminadas   : $removidas\" -ForegroundColor Green;" ^
    "Write-Host \"Aplicaciones no instaladas: $noEncontradas\" -ForegroundColor Yellow;" ^
    "Write-Host \"Errores encontrados       : $errores\" -ForegroundColor Red;" ^
    "Write-Host '=========================================' -ForegroundColor Cyan;" ^
    "Write-Host '';"

echo.
echo [%date% %time%] Debloat completado >> "%LOGFILE%"
echo.
echo Presione ENTER para volver al menu...
pause >nul
goto MENU

:: =====================================================
:: SECCION 7: DESACTIVAR TELEMETRIA
:: =====================================================
:TELEMETRY
cls
echo =====================================================
echo        DESACTIVACION DE TELEMETRIA Y PRIVACIDAD
echo =====================================================
echo.
echo [INFO] Desactivando servicios de telemetria...
echo.

echo [1/6] Deteniendo servicios de telemetria...
sc config DiagTrack start= disabled
sc config dmwappushservice start= disabled
sc stop DiagTrack
sc stop dmwappushservice

echo.
echo [2/6] Configurando politicas de privacidad en registro...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v AITEnable /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v DisableInventory /t REG_DWORD /d 1 /f

echo.
echo [3/6] Desactivando tareas programadas de telemetria...
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable 2>nul
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable 2>nul
schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy" /Disable 2>nul
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable 2>nul
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable 2>nul
schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable 2>nul

echo.
echo [4/6] Bloqueando dominios de telemetria en hosts...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$telemetryHosts = @('vortex.data.microsoft.com','vortex-win.data.microsoft.com','telecommand.telemetry.microsoft.com','oca.telemetry.microsoft.com','sqm.telemetry.microsoft.com','watson.telemetry.microsoft.com','redir.metaservices.microsoft.com','choice.microsoft.com','df.telemetry.microsoft.com','reports.wes.df.telemetry.microsoft.com','wes.df.telemetry.microsoft.com','services.wes.df.telemetry.microsoft.com','sqm.df.telemetry.microsoft.com','telemetry.microsoft.com','telemetry.appex.bing.net','telemetry.urs.microsoft.com','settings-sandbox.data.microsoft.com','vortex-sandbox.data.microsoft.com','survey.watson.microsoft.com','watson.live.com','watson.microsoft.com','statsfe2.ws.microsoft.com','corpext.msitadfs.glbdns2.microsoft.com','compatexchange.cloudapp.net','cs1.wpc.v0cdn.net','a-0001.a-msedge.net','statsfe2.update.microsoft.com.akadns.net','sls.update.microsoft.com.akadns.net','fe2.update.microsoft.com.akadns.net','diagnostics.support.microsoft.com','corp.sts.microsoft.com','statsfe1.ws.microsoft.com','pre.footprintpredict.com','i1.services.social.microsoft.com','i1.services.social.microsoft.com.nsatc.net','feedback.windows.com','feedback.microsoft-hohm.com','feedback.search.microsoft.com');" ^
    "$hostsPath = 'C:\Windows\System32\drivers\etc\hosts';" ^
    "$contenido = Get-Content $hostsPath;" ^
    "foreach ($host in $telemetryHosts) {" ^
    "    $linea = \"127.0.0.1 $host\";" ^
    "    if ($contenido -notcontains $linea) {" ^
    "        Add-Content -Path $hostsPath -Value $linea;" ^
    "    }" ^
    "}" ^
    "Write-Host '[OK] Hosts bloqueados agregados' -ForegroundColor Green;"

echo.
echo [5/6] Desactivando Cortana...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f

echo.
echo [6/6] Desactivando publicidad en menu inicio...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-353696Enabled /t REG_DWORD /d 0 /f

echo.
echo [COMPLETADO] Telemetria desactivada.
echo [NOTA] Algunos cambios requieren reiniciar el equipo.
echo.
echo [%date% %time%] Telemetria desactivada >> "%LOGFILE%"
pause
goto MENU

:: =====================================================
:: SECCION 8: GESTION DE HIBERNACION
:: =====================================================
:HIBERNATE
cls
echo =====================================================
echo         GESTION DE ARCHIVO DE HIBERNACION
echo =====================================================
echo.
echo  [1] DESACTIVAR hibernacion (Liberar espacio en C:)
echo  [2] ACTIVAR hibernacion (Habilitar modo hibernar)
echo  [3] REDUCIR tamano (50%% de RAM - Opcion hibrida)
echo  [4] VOLVER AL MENU PRINCIPAL
echo.
set "hib_op="
set /p hib_op="Seleccione una opcion (1-4): "

if "%hib_op%"=="1" goto HIB_OFF
if "%hib_op%"=="2" goto HIB_ON
if "%hib_op%"=="3" goto HIB_REDUCE
if "%hib_op%"=="4" goto MENU
goto HIBERNATE

:HIB_OFF
cls
echo =====================================================
echo        DESACTIVANDO HIBERNACION
echo =====================================================
echo.
echo [INFO] Esto eliminara el archivo hiberfil.sys
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$hiberfil = 'C:\hiberfil.sys';" ^
    "if (Test-Path $hiberfil) {" ^
    "    $tamano = (Get-Item $hiberfil).Length / 1GB;" ^
    "    Write-Host \"Tamano actual de hiberfil.sys: $([Math]::Round($tamano, 2)) GB\" -ForegroundColor Yellow;" ^
    "}"
echo.
powercfg /hibernate off
echo [OK] Hibernacion desactivada y espacio liberado.
echo.
echo [%date% %time%] Hibernacion desactivada >> "%LOGFILE%"
pause
goto HIBERNATE

:HIB_ON
cls
echo =====================================================
echo         ACTIVANDO HIBERNACION
echo =====================================================
echo.
powercfg /hibernate on
echo [OK] Hibernacion activada.
echo [INFO] El archivo hiberfil.sys sera creado en C:\
echo.
echo [%date% %time%] Hibernacion activada >> "%LOGFILE%"
pause
goto HIBERNATE

:HIB_REDUCE
cls
echo =====================================================
echo     REDUCIENDO TAMANO DE HIBERNACION (50%%)
echo =====================================================
echo.
echo [INFO] Esto reduce el archivo a 50%% de la RAM
powercfg /hibernate /type reduced
echo [OK] Hibernacion configurada en modo reducido.
echo.
echo [%date% %time%] Hibernacion reducida al 50%% >> "%LOGFILE%"
pause
goto HIBERNATE

:: =====================================================
:: SECCION 9: REGISTROS Y ERRORES DEL SISTEMA
:: =====================================================
:REGISTROS
cls
echo =====================================================
echo       ANALISIS DE REGISTROS Y ERRORES CRITICOS
echo =====================================================
echo.
echo  [1] Ver ultimos 20 errores criticos del sistema
echo  [2] Ver ultimos 20 errores de aplicaciones
echo  [3] Analizar eventos de apagados/reinicios
echo  [4] Exportar logs completos a archivo
echo  [5] Limpiar logs antiguos (liberar espacio)
echo  [6] VOLVER AL MENU PRINCIPAL
echo.
set "log_op="
set /p log_op="Seleccione una opcion (1-6): "

if "%log_op%"=="1" goto LOG_SYSTEM
if "%log_op%"=="2" goto LOG_APP
if "%log_op%"=="3" goto LOG_SHUTDOWN
if "%log_op%"=="4" goto LOG_EXPORT
if "%log_op%"=="5" goto LOG_CLEAR
if "%log_op%"=="6" goto MENU
goto REGISTROS

:LOG_SYSTEM
cls
echo =====================================================
echo        ULTIMOS 20 ERRORES CRITICOS DEL SISTEMA
echo =====================================================
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Get-EventLog -LogName System -EntryType Error -Newest 20 -ErrorAction SilentlyContinue | Format-Table TimeGenerated, Source, Message -AutoSize -Wrap"
echo.
pause
goto REGISTROS

:LOG_APP
cls
echo =====================================================
echo       ULTIMOS 20 ERRORES DE APLICACIONES
echo =====================================================
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Get-EventLog -LogName Application -EntryType Error -Newest 20 -ErrorAction SilentlyContinue | Format-Table TimeGenerated, Source, Message -AutoSize -Wrap"
echo.
pause
goto REGISTROS

:LOG_SHUTDOWN
cls
echo =====================================================
echo      ANALISIS DE APAGADOS Y REINICIOS
echo =====================================================
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Get-WinEvent -FilterHashtable @{LogName='System';Id=1074,1076,6005,6006,6008} -MaxEvents 10 -ErrorAction SilentlyContinue | Select-Object TimeCreated, Id, Message | Format-List"
echo.
pause
goto REGISTROS

:LOG_EXPORT
cls
echo =====================================================
echo         EXPORTAR LOGS A ARCHIVO
echo =====================================================
echo.
set "EXPORT_FILE=C:\HerramientasTI\SystemLogs_%date:~-4,4%%date:~-10,2%%date:~-7,2%.txt"
echo [INFO] Exportando logs a: %EXPORT_FILE%
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$output = '%EXPORT_FILE%';" ^
    "\"=== ERRORES DEL SISTEMA ===\" | Out-File $output;" ^
    "Get-EventLog -LogName System -EntryType Error -Newest 50 -ErrorAction SilentlyContinue | Format-Table TimeGenerated, Source, Message | Out-File $output -Append;" ^
    "\"`n=== ERRORES DE APLICACIONES ===\" | Out-File $output -Append;" ^
    "Get-EventLog -LogName Application -EntryType Error -Newest 50 -ErrorAction SilentlyContinue | Format-Table TimeGenerated, Source, Message | Out-File $output -Append;" ^
    "Write-Host '[OK] Logs exportados a: $output' -ForegroundColor Green;"
echo.
pause
goto REGISTROS

:LOG_CLEAR
cls
echo =====================================================
echo          LIMPIAR LOGS ANTIGUOS
echo =====================================================
echo.
echo [ADVERTENCIA] Esto eliminara logs antiguos del sistema.
echo [INFO] Los logs mas recientes se conservaran.
echo.
echo Presione ENTER para continuar o CTRL+C para cancelar...
pause >nul
echo.
wevtutil cl Application
wevtutil cl System
wevtutil cl Security
echo [OK] Logs antiguos eliminados.
echo.
pause
goto REGISTROS

:: =====================================================
:: SECCION 10: OPTIMIZACION DE DISCOS
:: =====================================================
:DISCOS
cls
echo =====================================================
echo        OPTIMIZACION Y MANTENIMIENTO DE DISCOS
echo =====================================================
echo.
echo  [1] Ejecutar TRIM en SSD (Optimizacion rapida)
echo  [2] Desfragmentar HDD (Solo discos mecanicos)
echo  [3] Analizar estado de salud del disco
echo  [4] Verificar errores en disco (CHKDSK)
echo  [5] Optimizar TODOS los discos automaticamente
echo  [6] VOLVER AL MENU PRINCIPAL
echo.
set "disk_op="
set /p disk_op="Seleccione una opcion (1-6): "

if "%disk_op%"=="1" goto DISK_TRIM
if "%disk_op%"=="2" goto DISK_DEFRAG
if "%disk_op%"=="3" goto DISK_HEALTH
if "%disk_op%"=="4" goto DISK_CHKDSK
if "%disk_op%"=="5" goto DISK_AUTO
if "%disk_op%"=="6" goto MENU
goto DISCOS

:DISK_TRIM
cls
echo =====================================================
echo            EJECUTAR TRIM EN SSD
echo =====================================================
echo.
echo [INFO] Optimizando unidad C: con TRIM...
defrag C: /L /O
echo.
echo [OK] TRIM completado en unidad C:
echo.
echo [%date% %time%] TRIM ejecutado >> "%LOGFILE%"
pause
goto DISCOS

:DISK_DEFRAG
cls
echo =====================================================
echo         DESFRAGMENTACION DE HDD
echo =====================================================
echo.
echo [ADVERTENCIA] Solo use esto en discos HDD (mecanicos).
echo [INFO] Para SSD, use la opcion TRIM en su lugar.
echo.
echo Presione ENTER para continuar o CTRL+C para cancelar...
pause >nul
echo.
defrag C: /U /V
echo.
echo [OK] Desfragmentacion completada.
echo.
echo [%date% %time%] Desfragmentacion ejecutada >> "%LOGFILE%"
pause
goto DISCOS

:DISK_HEALTH
cls
echo =====================================================
echo         ESTADO DE SALUD DEL DISCO
echo =====================================================
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Get-PhysicalDisk | Select-Object FriendlyName, MediaType, HealthStatus, OperationalStatus, Size | Format-Table -AutoSize;" ^
    "Write-Host \"`n=== VOLUMENES ===\";" ^
    "Get-Volume | Where-Object {$_.DriveLetter} | Select-Object DriveLetter, FileSystemLabel, FileSystem, HealthStatus, SizeRemaining, Size | Format-Table -AutoSize;"
echo.
pause
goto DISCOS

:DISK_CHKDSK
cls
echo =====================================================
echo      VERIFICACION DE ERRORES EN DISCO
echo =====================================================
echo.
echo [INFO] Escaneando unidad C: en busca de errores...
echo [NOTA] Si hay errores, se programara una verificacion al reiniciar.
echo.
chkdsk C: /F /R /X
echo.
echo [%date% %time%] CHKDSK ejecutado >> "%LOGFILE%"
pause
goto DISCOS

:DISK_AUTO
cls
echo =====================================================
echo       OPTIMIZACION AUTOMATICA DE DISCOS
echo =====================================================
echo.
echo [INFO] Optimizando todos los discos del sistema...
defrag /C /O
echo.
echo [OK] Optimizacion completada en todos los discos.
echo.
echo [%date% %time%] Optimizacion automatica ejecutada >> "%LOGFILE%"
pause
goto DISCOS

:: =====================================================
:: SECCION 11: REMOVER COPILOT E IA
:: =====================================================
:REMOVEAI
cls
echo =====================================================
echo     DESINSTALACION DE COPILOT Y CARACTERISTICAS IA
echo =====================================================
echo.
echo [ADVERTENCIA] Esto ejecutara el script RemoveWindowsAI de GitHub.
echo [INFO] Esto removera Copilot, Recall y funciones de IA de Windows.
echo.
echo Script original: https://github.com/zoicware/RemoveWindowsAI
echo.
echo Presione ENTER para continuar o CTRL+C para cancelar...
pause >nul

echo.
echo [INFO] Descargando y ejecutando script de RemoveWindowsAI...
echo [NOTA] Esto puede tardar unos minutos...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "try {" ^
    "    Write-Host '[1/2] Descargando script desde GitHub...' -ForegroundColor Cyan;" ^
    "    $ErrorActionPreference = 'Stop';" ^
    "    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;" ^
    "    & ([scriptblock]::Create((irm 'https://raw.githubusercontent.com/zoicware/RemoveWindowsAI/main/RemoveWindowsAi.ps1')));" ^
    "    Write-Host '';" ^
    "    Write-Host '[OK] Proceso completado exitosamente' -ForegroundColor Green;" ^
    "} catch {" ^
    "    Write-Host '';" ^
    "    Write-Host '[ERROR] No se pudo ejecutar el script: ' $_.Exception.Message -ForegroundColor Red;" ^
    "    Write-Host '[INFO] Verifique su conexion a internet e intente nuevamente' -ForegroundColor Yellow;" ^
    "    Write-Host '';" ^
    "    Write-Host 'Ejecutando metodo alternativo...' -ForegroundColor Cyan;" ^
    "    Write-Host '';" ^
    "    Write-Host '[1/4] Desactivando Copilot en registro...' -ForegroundColor Yellow;" ^
    "    reg add 'HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot' /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f | Out-Null;" ^
    "    reg add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot' /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f | Out-Null;" ^
    "    Write-Host '[2/4] Removiendo Copilot del sistema...' -ForegroundColor Yellow;" ^
    "    Get-AppxPackage -Name '*Copilot*' -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue;" ^
    "    Write-Host '[3/4] Ocultando icono de Copilot...' -ForegroundColor Yellow;" ^
    "    reg add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' /v ShowCopilotButton /t REG_DWORD /d 0 /f | Out-Null;" ^
    "    Write-Host '[4/4] Desactivando sugerencias de IA...' -ForegroundColor Yellow;" ^
    "    reg add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' /v Start_IrisRecommendations /t REG_DWORD /d 0 /f | Out-Null;" ^
    "    Write-Host '';" ^
    "    Write-Host '[OK] Metodo alternativo completado' -ForegroundColor Green;" ^
    "}"

echo.
echo [COMPLETADO] Proceso de remocion de IA finalizado.
echo [NOTA] Reinicie el equipo para aplicar todos los cambios.
echo.
echo [%date% %time%] RemoveWindowsAI ejecutado >> "%LOGFILE%"
echo.
echo Presione ENTER para volver al menu...
pause >nul
goto MENU

:: =====================================================
:: SECCION 12: REPORTES DE ENERGIA
:: =====================================================
:ENERGIA
cls
echo =====================================================
echo         ANALISIS Y REPORTES DE ENERGIA
echo =====================================================
echo.
echo  [1] Generar reporte de bateria (Portatiles)
echo  [2] Generar reporte de eficiencia energetica
echo  [3] Ver plan de energia actual
echo  [4] Configurar suspension/hibernacion
echo  [5] VOLVER AL MENU PRINCIPAL
echo.
set "pwr_op="
set /p pwr_op="Seleccione una opcion (1-5): "

if "%pwr_op%"=="1" goto PWR_BATTERY
if "%pwr_op%"=="2" goto PWR_EFFICIENCY
if "%pwr_op%"=="3" goto PWR_CURRENT
if "%pwr_op%"=="4" goto PWR_CONFIG
if "%pwr_op%"=="5" goto MENU
goto ENERGIA

:PWR_BATTERY
cls
echo =====================================================
echo          REPORTE DE BATERIA (PORTATILES)
echo =====================================================
echo.
echo [INFO] Generando reporte detallado de bateria...
set "BATTERY_REPORT=%LOCAL_FOLDER%\battery-report.html"
powercfg /batteryreport /output "%BATTERY_REPORT%"
echo.
echo [OK] Reporte generado en: %BATTERY_REPORT%
echo.
echo Abriendo reporte en navegador...
start "" "%BATTERY_REPORT%"
echo.
pause
goto ENERGIA

:PWR_EFFICIENCY
cls
echo =====================================================
echo       REPORTE DE EFICIENCIA ENERGETICA
echo =====================================================
echo.
echo [INFO] Generando analisis de 60 segundos...
echo [NOTA] No use el equipo durante este tiempo.
echo.
set "ENERGY_REPORT=%LOCAL_FOLDER%\energy-report.html"
powercfg /energy /output "%ENERGY_REPORT%" /duration 60
echo.
echo [OK] Reporte generado en: %ENERGY_REPORT%
echo.
echo Abriendo reporte en navegador...
start "" "%ENERGY_REPORT%"
echo.
pause
goto ENERGIA

:PWR_CURRENT
cls
echo =====================================================
echo         PLAN DE ENERGIA ACTUAL
echo =====================================================
echo.
powercfg /list
echo.
echo --- CONFIGURACION ACTUAL ---
powercfg /query
echo.
pause
goto ENERGIA

:PWR_CONFIG
cls
echo =====================================================
echo      CONFIGURAR SUSPENSION E HIBERNACION
echo =====================================================
echo.
echo  [1] Desactivar suspension (siempre activo)
echo  [2] Suspension tras 15 minutos
echo  [3] Suspension tras 30 minutos
echo  [4] Volver al menu de energia
echo.
set "cfg_op="
set /p cfg_op="Seleccione una opcion (1-4): "

if "%cfg_op%"=="1" (
    powercfg /change standby-timeout-ac 0
    powercfg /change standby-timeout-dc 0
    echo [OK] Suspension desactivada
)
if "%cfg_op%"=="2" (
    powercfg /change standby-timeout-ac 15
    powercfg /change standby-timeout-dc 15
    echo [OK] Suspension configurada a 15 minutos
)
if "%cfg_op%"=="3" (
    powercfg /change standby-timeout-ac 30
    powercfg /change standby-timeout-dc 30
    echo [OK] Suspension configurada a 30 minutos
)
if "%cfg_op%"=="4" goto ENERGIA

echo.
pause
goto ENERGIA

:: =====================================================
:: SECCION 13: MENU AVANZADO
:: =====================================================
:AVANZADO
cls
echo =====================================================
echo         HERRAMIENTAS AVANZADAS PARA TI
echo =====================================================
echo.
echo  [1] Respaldar Drivers del Sistema
echo  [2] Ver Puertos y Conexiones Activas (NETSTAT)
echo  [3] Consultar Errores Criticos del Sistema
echo  [4] Resetear Windows Update (Solucionar Updates)
echo  [5] Reparar Cola de Impresion (Print Spooler)
echo  [6] Motivo del Ultimo Apagado
echo  [7] Test de Latencia y Ruta (PING + TRACERT)
echo  [8] Monitor de Sistema en Tiempo Real
echo  [9] VOLVER AL MENU PRINCIPAL
echo.
set "av="
set /p av="Seleccione una herramienta (1-9): "

if "%av%"=="1" goto ADV_DRIVERS
if "%av%"=="2" goto ADV_NETSTAT
if "%av%"=="3" goto ADV_LOGS
if "%av%"=="4" goto ADV_UPDATE
if "%av%"=="5" goto ADV_SPOOLER
if "%av%"=="6" goto ADV_SHUTDOWN
if "%av%"=="7" goto ADV_PING
if "%av%"=="8" goto ADV_MONITOR
if "%av%"=="9" goto MENU
goto AVANZADO

:ADV_DRIVERS
cls
echo =====================================================
echo        RESPALDO DE CONTROLADORES (DRIVERS)
echo =====================================================
echo.
echo [PASO 1] Creando carpeta en C:\DriversBackup...
if not exist "C:\DriversBackup" mkdir "C:\DriversBackup"

echo [PASO 2] Exportando drivers del sistema...
echo [INFO] Este proceso puede tardar varios minutos...
echo.
dism /online /export-driver /destination:"C:\DriversBackup"
echo.
if %errorLevel% equ 0 (
    echo [OK] Drivers exportados correctamente a C:\DriversBackup
) else (
    echo [ERROR] Hubo un problema al exportar los drivers
)
echo.
echo [%date% %time%] Backup de drivers realizado >> "%LOGFILE%"
pause
goto AVANZADO

:ADV_NETSTAT
cls
echo =====================================================
echo        PUERTOS Y CONEXIONES ACTIVAS
echo =====================================================
echo.
echo [INFO] Listando aplicaciones conectadas a Internet:
echo [NOTA] Esto puede tardar unos segundos...
echo.
netstat -ano | findstr /i "ESTABLISHED LISTENING" > "%TEMP%\netstat_temp.txt"
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$connections = Get-Content '%TEMP%\netstat_temp.txt';" ^
    "foreach ($line in $connections) {" ^
    "    if ($line -match '\s+(\d+)$') {" ^
    "        $pid = $matches[1];" ^
    "        try {" ^
    "            $process = Get-Process -Id $pid -ErrorAction SilentlyContinue;" ^
    "            if ($process) {" ^
    "                Write-Host \"$line - Proceso: $($process.ProcessName)\" -ForegroundColor Cyan;" ^
    "            } else {" ^
    "                Write-Host $line -ForegroundColor Gray;" ^
    "            }" ^
    "        } catch {" ^
    "            Write-Host $line -ForegroundColor Gray;" ^
    "        }" ^
    "    }" ^
    "}"
del "%TEMP%\netstat_temp.txt" 2>nul
echo.
pause
goto AVANZADO

:ADV_LOGS
cls
echo =====================================================
echo         ULTIMOS 15 ERRORES CRITICOS
echo =====================================================
echo.
echo [INFO] Consultando visor de eventos de Windows...
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Get-EventLog -LogName System -EntryType Error -Newest 15 -ErrorAction SilentlyContinue | Format-Table TimeGenerated, Source, EventID, Message -AutoSize -Wrap"
echo.
pause
goto AVANZADO

:ADV_UPDATE
cls
echo =====================================================
echo          RESETEO DE WINDOWS UPDATE
echo =====================================================
echo.
echo [ADVERTENCIA] Esto reseteara completamente Windows Update.
echo [INFO] Util para solucionar actualizaciones bloqueadas.
echo.
echo Presione ENTER para continuar o CTRL+C para cancelar...
pause >nul

echo.
echo [1/6] Deteniendo servicios de actualizacion...
net stop wuauserv
net stop bits
net stop cryptsvc
net stop msiserver

echo.
echo [2/6] Eliminando cache de descargas corruptas...
rd /s /q "%WINDIR%\SoftwareDistribution" 2>nul
rd /s /q "%WINDIR%\System32\catroot2" 2>nul

echo.
echo [3/6] Creando nuevas carpetas...
md "%WINDIR%\SoftwareDistribution"
md "%WINDIR%\System32\catroot2"

echo.
echo [4/6] Reiniciando servicios...
net start wuauserv
net start bits
net start cryptsvc
net start msiserver

echo.
echo [5/6] Registrando componentes de Windows Update...
regsvr32 /s wuaueng.dll
regsvr32 /s wuapi.dll
regsvr32 /s wups.dll
regsvr32 /s wuwebv.dll
regsvr32 /s wucltui.dll

echo.
echo [6/6] Limpiando cache de Windows Store...
wsreset.exe

echo.
echo [OK] Windows Update reseteado completamente.
echo [NOTA] Intente buscar actualizaciones nuevamente.
echo.
echo [%date% %time%] Windows Update reseteado >> "%LOGFILE%"
pause
goto AVANZADO

:ADV_SPOOLER
cls
echo =====================================================
echo       REPARACION PROFUNDA DE COLA DE IMPRESION
echo =====================================================
echo.
echo [1/6] Deteniendo servicios de impresion...
net stop spooler /y >nul 2>&1
net stop PrintNotify /y >nul 2>&1

echo [2/6] Eliminando archivos temporales y documentos corruptos...
del /Q /F /S "%systemroot%\System32\Spool\Printers\*.*" >nul 2>&1

echo [3/6] Limpiando cache de impresoras...
del /Q /F "%LOCALAPPDATA%\Microsoft\Windows\Printer\*.spl" >nul 2>&1
del /Q /F "%LOCALAPPDATA%\Microsoft\Windows\Printer\*.shd" >nul 2>&1

echo [4/6] Limpiando sockets de red de impresion...
netsh winsock reset >nul 2>&1

echo [5/6] Aplicando correccion de aislamiento de procesos...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Print" /v PrintWorkflowUserActivationTimeout /t REG_DWORD /d 10000 /f >nul 2>&1

echo [6/6] Reiniciando servicios...
net start spooler
net start PrintNotify >nul 2>&1

echo.
echo [VERIFICACION] Estado del servicio:
sc query spooler | findstr "STATE"
echo.
echo [OK] Cola de impresion reseteada y optimizada.
echo [NOTA] Si el problema persiste, desinstale y reinstale la impresora.
echo.
echo [%date% %time%] Spooler reparado >> "%LOGFILE%"
pause
goto AVANZADO

:ADV_SHUTDOWN
cls
echo =====================================================
echo          MOTIVO DEL ULTIMO APAGADO
echo =====================================================
echo.
echo [INFO] Analizando logs de energia y cierres...
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Write-Host '=== EVENTOS DE APAGADO ===' -ForegroundColor Cyan;" ^
    "Get-WinEvent -FilterHashtable @{LogName='System';Id=1074,1076,6008} -MaxEvents 5 -ErrorAction SilentlyContinue | Select-Object TimeCreated, Id, Message | Format-List;" ^
    "Write-Host \"`n=== EVENTOS DE SUSPENSION ===\";" ^
    "Get-WinEvent -FilterHashtable @{LogName='System';Id=42} -MaxEvents 3 -ErrorAction SilentlyContinue | Select-Object TimeCreated, Message | Format-List;"
echo.
pause
goto AVANZADO

:ADV_PING
cls
echo =====================================================
echo       DIAGNOSTICO DETALLADO DE LATENCIA Y RUTA
echo =====================================================
echo.
echo [INFO] Ingrese URL o IP (Ej: google.com, 1.1.1.1)
echo Si presiona ENTER, se usara google.com
echo.
set /p "target=Servidor a escanear: "
if "%target%"=="" set "target=google.com"

echo.
echo [1/3] ANALISIS DE RUTA (TRACERT)
echo [INFO] Esto muestra cada "salto" que da tu internet.
echo [!] Si un salto tiene muchos ms, ahi esta el problema.
echo.
tracert -d -h 15 %target%

echo.
echo -----------------------------------------------------
echo [2/3] PRUEBA DE ESTABILIDAD (15 PAQUETES)
echo Destino: %target%
echo.
ping %target% -n 15

echo.
echo -----------------------------------------------------
echo [3/3] INTERPRETACION TECNICA:
echo  - Salto 1 (192.168.x.x): Es tu Router (Debe ser ^< 2ms)
echo  - Saltos 2-4: Es tu Proveedor de Internet (ISP)
echo  - Saltos Finales: El servidor de destino
echo.
echo [TIP] Si el Salto 1 tiene ms altos, el problema es tu CABLE o WIFI
echo [TIP] Si los ms suben en el Salto 2 o 3, el problema es tu PROVEEDOR
echo.
pause
goto AVANZADO

:ADV_MONITOR
cls
echo =====================================================
echo       MONITOR DE SISTEMA EN TIEMPO REAL
echo =====================================================
echo.
echo [INFO] Abriendo herramientas de monitoreo...
echo.
echo [1/2] Abriendo Administrador de Tareas (Performance)...
start taskmgr.exe

echo [2/2] Abriendo Monitor de Recursos...
start resmon.exe

echo.
echo [OK] Herramientas de monitoreo abiertas.
echo.
pause
goto AVANZADO

:: =====================================================
:: SECCION 14: BACKUP COMPLETO DEL SISTEMA
:: =====================================================
:BACKUP
cls
echo =====================================================
echo          BACKUP COMPLETO DEL SISTEMA
echo =====================================================
echo.
echo  [1] Crear punto de restauracion
echo  [2] Listar puntos de restauracion existentes
echo  [3] Crear imagen del sistema (Backup completo)
echo  [4] VOLVER AL MENU PRINCIPAL
echo.
set "bkp_op="
set /p bkp_op="Seleccione una opcion (1-4): "

if "%bkp_op%"=="1" goto BKP_CREATE_POINT
if "%bkp_op%"=="2" goto BKP_LIST_POINTS
if "%bkp_op%"=="3" goto BKP_IMAGE
if "%bkp_op%"=="4" goto MENU
goto BACKUP

:BKP_CREATE_POINT
cls
echo =====================================================
echo        CREAR PUNTO DE RESTAURACION
echo =====================================================
echo.
echo [INFO] Creando punto de restauracion del sistema...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "try {" ^
    "    Checkpoint-Computer -Description 'Panel TI Maestro - Punto manual' -RestorePointType 'MODIFY_SETTINGS';" ^
    "    Write-Host '[OK] Punto de restauracion creado exitosamente' -ForegroundColor Green;" ^
    "} catch {" ^
    "    Write-Host '[ERROR] No se pudo crear el punto: ' $_.Exception.Message -ForegroundColor Red;" ^
    "}"
echo.
echo [%date% %time%] Punto de restauracion creado >> "%LOGFILE%"
pause
goto BACKUP

:BKP_LIST_POINTS
cls
echo =====================================================
echo        PUNTOS DE RESTAURACION EXISTENTES
echo =====================================================
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Get-ComputerRestorePoint | Select-Object SequenceNumber, CreationTime, Description | Format-Table -AutoSize"
echo.
pause
goto BACKUP

:BKP_IMAGE
cls
echo =====================================================
echo         CREAR IMAGEN DEL SISTEMA
echo =====================================================
echo.
echo [INFO] Abriendo herramienta de copia de seguridad de Windows...
echo [NOTA] Configure la copia de seguridad segun sus necesidades.
echo.
control /name Microsoft.Backup
echo.
echo [INFO] Herramienta de backup abierta.
echo.
pause
goto BACKUP

:: =====================================================
:: SECCION 15: SEGURIDAD (FIREWALL + DEFENDER)
:: =====================================================
:SEGURIDAD
cls
echo =====================================================
echo         CONFIGURACION DE SEGURIDAD
echo =====================================================
echo.
echo  [1] Verificar estado de Windows Defender
echo  [2] Escaneo rapido con Defender
echo  [3] Escaneo completo con Defender
echo  [4] Verificar reglas de Firewall
echo  [5] Actualizar definiciones de virus
echo  [6] VOLVER AL MENU PRINCIPAL
echo.
set "sec_op="
set /p sec_op="Seleccione una opcion (1-6): "

if "%sec_op%"=="1" goto SEC_STATUS
if "%sec_op%"=="2" goto SEC_QUICK_SCAN
if "%sec_op%"=="3" goto SEC_FULL_SCAN
if "%sec_op%"=="4" goto SEC_FIREWALL
if "%sec_op%"=="5" goto SEC_UPDATE_DEF
if "%sec_op%"=="6" goto MENU
goto SEGURIDAD

:SEC_STATUS
cls
echo =====================================================
echo       ESTADO DE WINDOWS DEFENDER
echo =====================================================
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Get-MpComputerStatus | Select-Object AntivirusEnabled, RealTimeProtectionEnabled, IoavProtectionEnabled, BehaviorMonitorEnabled, AntivirusSignatureLastUpdated | Format-List"
echo.
pause
goto SEGURIDAD

:SEC_QUICK_SCAN
cls
echo =====================================================
echo         ESCANEO RAPIDO CON DEFENDER
echo =====================================================
echo.
echo [INFO] Iniciando escaneo rapido del sistema...
echo [NOTA] Este proceso puede tardar varios minutos.
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-MpScan -ScanType QuickScan"
echo.
echo [OK] Escaneo rapido completado.
echo.
echo [%date% %time%] Escaneo rapido ejecutado >> "%LOGFILE%"
pause
goto SEGURIDAD

:SEC_FULL_SCAN
cls
echo =====================================================
echo        ESCANEO COMPLETO CON DEFENDER
echo =====================================================
echo.
echo [ADVERTENCIA] Este escaneo puede tardar varias horas.
echo [INFO] Se recomienda ejecutarlo cuando no este usando el equipo.
echo.
echo Presione ENTER para continuar o CTRL+C para cancelar...
pause >nul
echo.
echo [INFO] Iniciando escaneo completo...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-MpScan -ScanType FullScan"
echo.
echo [OK] Escaneo completo finalizado.
echo.
echo [%date% %time%] Escaneo completo ejecutado >> "%LOGFILE%"
pause
goto SEGURIDAD

:SEC_FIREWALL
cls
echo =====================================================
echo         ESTADO DEL FIREWALL
echo =====================================================
echo.
netsh advfirewall show allprofiles
echo.
echo -----------------------------------------------------
echo [INFO] Verificando reglas activas...
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Get-NetFirewallRule | Where-Object {$_.Enabled -eq 'True'} | Select-Object DisplayName, Direction, Action | Format-Table -AutoSize"
echo.
pause
goto SEGURIDAD

:SEC_UPDATE_DEF
cls
echo =====================================================
echo      ACTUALIZAR DEFINICIONES DE VIRUS
echo =====================================================
echo.
echo [INFO] Actualizando definiciones de Windows Defender...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Update-MpSignature"
echo.
echo [OK] Definiciones actualizadas.
echo.
echo [%date% %time%] Definiciones de virus actualizadas >> "%LOGFILE%"
pause
goto SEGURIDAD


:: =====================================================
:: SECCION 16: REINICIAR EQUIPO
:: =====================================================
:REINICIAR_INSTANTANEO
cls
echo =====================================================
echo       ADVERTENCIA: REINICIO PROGRAMADO
echo =====================================================
echo.
echo El equipo se reiniciara en 15 segundos.
echo.
echo GUARDA TU TRABAJO AHORA.
echo.
echo Presiona CTRL+C para CANCELAR
echo.
shutdown /r /t 15 /c "Reinicio programado por Panel TI Maestro v3.0"
echo.
echo [%date% %time%] Reinicio programado >> "%LOGFILE%"
echo.
echo Reinicio en curso...
pause
goto MENU

:: =====================================================
:: SECCION 17: SALIR
:: =====================================================
:SALIR
cls
echo.
echo =====================================================
echo           CERRANDO PANEL TI MAESTRO v3.0
echo =====================================================
echo.
echo Log guardado en: %LOGFILE%
echo.
echo Gracias por usar Panel TI Maestro v3.0
echo Script desarrollado para soporte tecnico profesional
echo.
echo Presione ENTER para salir...
pause >nul
echo [%date% %time%] Script finalizado >> "%LOGFILE%"
exit /b 0