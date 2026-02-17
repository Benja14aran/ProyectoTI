# 🖥️ Panel TI Maestro

Suite de mantenimiento y soporte técnico profesional para Windows, compuesta por dos herramientas complementarias: un script de consola avanzado y una aplicación de escritorio con interfaz gráfica moderna.

## 📦 Componentes

| Archivo | Descripción | Versión |
|--------|-------------|---------|
| `PanelTIMaestro_v3_0.bat` | Script de consola interactivo | v3.0 |
| `PanelTIMaestro.exe` | Aplicación de escritorio .NET con GUI | v1.0.0 |

---

## 🖱️ `PanelTIMaestro.exe` — Aplicación de Escritorio

Aplicación nativa de Windows desarrollada en **.NET Desktop** (x64) con interfaz gráfica moderna. Proporciona un dashboard visual en tiempo real del estado del sistema, con diseño oscuro estilo Opera GX.

### ✨ Características

- **Dashboard en tiempo real** con métricas de CPU, RAM, temperatura y salud del disco con barras de progreso dinámicas con cambio de color según el nivel de uso (verde / naranja / rojo).
- **Interfaz glassmorphism** con paleta oscura morada, animaciones y efectos de brillo.
- **Consola de actividad** embebida con timestamps para registrar eventos, comandos y errores.
- **Integración con WebView2** para renderizar la interfaz HTML dentro de la aplicación nativa.
- **Comunicación bidireccional** entre el frontend HTML y el backend .NET via `window.chrome.webview`.
- **Alta resolución (DPI aware)** y soporte para rutas largas de Windows.

### 🔧 Requisitos

- Windows 10 / 11 (x64)
- [**.NET Desktop Runtime**](https://dotnet.microsoft.com/download/dotnet) (se solicitará instalación automáticamente si no está presente)
- [**Microsoft WebView2 Runtime**](https://developer.microsoft.com/microsoft-edge/webview2/) (incluido en Windows 11, descargable para Windows 10)

### 🚀 Instalación y Uso

1. Descarga `PanelTIMaestro.exe`.
2. Ejecuta el archivo. Si falta el .NET Desktop Runtime, Windows mostrará un diálogo para descargarlo.
3. No requiere instalación adicional — es un ejecutable portable de archivo único.

> ✅ No se necesitan permisos de administrador para iniciar la aplicación. Algunas métricas avanzadas pueden requerir ejecución elevada.

---

## ⌨️ `PanelTIMaestro_v3_0.bat` — Script de Consola

Script de consola profesional para Windows que centraliza las tareas de mantenimiento y optimización más comunes desde un menú interactivo en la terminal, con información del sistema en tiempo real y registro automático de actividad.

### ✨ Características

- **Panel de información del sistema** al iniciar: hostname, IP, SO, versión, uptime, RAM, CPU, GPU, placa base, BIOS, número de serie, MAC, disco y espacio libre.
- **Registro automático** de toda la actividad con fecha, hora, usuario y nombre del equipo, guardado en `%TEMP%`.
- **Verificación de permisos** de administrador al arrancar.
- **17 módulos de mantenimiento** accesibles desde el menú principal.

### 📋 Menú Principal

| Opción | Módulo | Descripción |
|--------|--------|-------------|
| 1 | Reparación del sistema | SFC (System File Checker) + DISM RestoreHealth |
| 2 | Limpieza total | 5 ciclos de eliminación de archivos temporales |
| 3 | Optimización RAM | Limpieza de memoria con RAMMap |
| 4 | Red y DNS | Flush DNS + reset de adaptadores de red |
| 5 | Plan máximo rendimiento | Activa el plan de energía de alto rendimiento |
| 6 | Debloat | Elimina aplicaciones innecesarias de Windows |
| 7 | Desactivar telemetría | Deshabilita el envío de datos a Microsoft |
| 8 | Gestión de hibernación | Habilitar / deshabilitar hibernación |
| 9 | Registros y errores | Visor de eventos y errores del sistema |
| 10 | Optimización de disco | TRIM para SSD / Desfragmentación para HDD |
| 11 | Eliminar IA (Copilot) | Remueve Microsoft Copilot del sistema |
| 12 | Energía | Reportes detallados de batería y energía |
| 13 | Herramientas avanzadas TI | Acceso a herramientas del sistema adicionales |
| 14 | Backup completo | Puntos de restauración e imagen del sistema |
| 15 | Seguridad | Estado de Firewall + escaneos de Windows Defender |
| 16 | Reiniciar equipo | Reinicio con cuenta regresiva de 15 segundos |
| 17 | Salir | Cierra el script y muestra la ruta del log |

### 🔧 Requisitos

- Windows 10 / 11
- PowerShell 5.1 o superior (incluido en Windows)
- **Ejecutar como Administrador** (obligatorio)

### 🚀 Uso

```bat
:: Click derecho sobre el archivo → "Ejecutar como administrador"
PanelTIMaestro_v3_0.bat
```

### 📁 Archivos generados

| Archivo | Ubicación | Descripción |
|--------|-----------|-------------|
| Log de sesión | `%TEMP%\PanelTI_Log_AAAAMMDD.log` | Registro completo de la ejecución |
| Carpeta de herramientas | `C:\HerramientasTI\` | Creada automáticamente al primer inicio |

---

## ⚠️ Advertencias

- El script `.bat` realiza cambios a nivel de sistema operativo. Úsalo solo en equipos sobre los que tengas autorización.
- Las operaciones de **Debloat**, **Telemetría** y **Eliminar Copilot** son difíciles de revertir. Se recomienda crear un punto de restauración antes (Opción 14).
- Algunos módulos pueden tardar entre **20 y 40 minutos** en completarse (ej. SFC + DISM, escaneo completo de Defender).

---

## 🗂️ Estructura del Repositorio

```
📁 PanelTIMaestro/
├── PanelTIMaestro.exe          # Aplicación de escritorio .NET (v1.0.0, x64)
├── PanelTIMaestro_v3_0.bat     # Script de consola (v3.0)
└── README.md
```

---

## 📋 Roadmap

- [ ] Integración directa entre la GUI y el script `.bat`
- [ ] Historial de sesiones visible desde la aplicación
- [ ] Exportación de reportes a PDF
- [ ] Actualizaciones automáticas del ejecutable

---

## 📄 Licencia

Proyecto de uso libre para soporte técnico personal y profesional. Si lo modificas o distribuyes, agradece mantener la atribución original.
