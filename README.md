# 🖥️ Panel TI Maestro

Suite de herramientas de soporte técnico y mantenimiento profesional para Windows, compuesta por dos componentes complementarios: un potente script de consola (.bat) y una interfaz gráfica moderna (.html) integrada con WebView2.

---

## 📦 Componentes del Proyecto

### 1. `PanelTIMaestro_v3_0.bat` — Script de Mantenimiento de Consola

Script de consola profesional para Windows que centraliza las tareas de mantenimiento, optimización y soporte técnico más comunes, todo desde un menú interactivo en la terminal.

#### ✨ Características

- **Panel de información del sistema** al iniciar: muestra hostname, IP, SO, versión, uptime, RAM, procesador, GPU, placa base, BIOS, número de serie, MAC, disco y espacio libre — todo con colores vía PowerShell.
- **Registro automático de actividad** (log con fecha, hora, usuario y equipo) guardado en `%TEMP%`.
- **Verificación de permisos de administrador** al arrancar; si no los tiene, muestra error y se detiene de forma limpia.
- **Menú principal con 17 opciones:**

| Opción | Función |
|--------|---------|
| 1 | Reparación del sistema (SFC + DISM) |
| 2 | Limpieza total (5 ciclos de archivos temporales) |
| 3 | Optimización de RAM (RAMMap) |
| 4 | Red y DNS (flush + reset) |
| 5 | Plan de máximo rendimiento |
| 6 | Debloat (eliminar apps innecesarias) |
| 7 | Desactivar telemetría |
| 8 | Gestión de hibernación |
| 9 | Registros y errores del sistema |
| 10 | Optimización de disco (TRIM / Defrag) |
| 11 | Eliminar IA (remover Copilot) |
| 12 | Energía (reportes detallados) |
| 13 | Herramientas avanzadas TI |
| 14 | Backup completo del sistema |
| 15 | Seguridad (Firewall + Windows Defender) |
| 16 | Reiniciar equipo (con cuenta regresiva de 15 s) |
| 17 | Salir |

#### 🔧 Requisitos

- Windows 10 / 11
- PowerShell 5.1 o superior (incluido en Windows)
- **Ejecutar como Administrador** (obligatorio)

#### 🚀 Uso

```bat
:: Click derecho sobre el archivo → "Ejecutar como administrador"
PanelTIMaestro_v3_0.bat
```

> ⚠️ El script no se cerrará ante errores individuales; cada sección reporta su resultado y regresa al menú principal.

#### 📁 Archivos generados

- **Log de ejecución:** `%TEMP%\PanelTI_Log_AAAAMMDD.log`
- **Carpeta de herramientas:** `C:\HerramientasTI\` (se crea automáticamente si no existe)

---

### 2. `index.html` — Interfaz Gráfica Web (WebView2)

Interfaz de usuario moderna y visual diseñada para integrarse con una aplicación de escritorio .NET mediante **Microsoft WebView2**. Muestra métricas del sistema en tiempo real con un estilo inspirado en Opera GX.

#### ✨ Características

- **Dashboard en tiempo real** con métricas de CPU, RAM y temperatura con barras de progreso dinámicas con cambio de color (verde / naranja / rojo según el nivel de uso).
- **Sidebar de navegación** con secciones independientes y transiciones animadas.
- **Tema visual Opera GX:** paleta oscura con degradados morados y negros, efecto glassmorphism en las tarjetas, animaciones y efectos de brillo (glow).
- **Consola de actividad** embebida que registra eventos, comandos y errores con timestamp.
- **Comunicación bidireccional con C#** vía `window.chrome.webview`:
  - Recibe métricas del sistema en formato JSON (`type: 'metrics'`).
  - Envía comandos al backend C# (`enviarACSharp(comando)`).
- **Verificación automática** de elementos críticos del DOM al cargar (`cpu-percent`, `ram-percent`, `temp-value`, `disk-health`).

#### 🔧 Requisitos

- Aplicación host en C# / .NET con **Microsoft WebView2** embebido
- Navegador moderno (solo para previsualización estática; sin WebView2 no recibe datos)
- Tailwind CSS (cargado vía CDN: `https://cdn.tailwindcss.com`)

#### 📡 Integración con C# (WebView2)

La página escucha mensajes entrantes desde la capa .NET con el siguiente formato JSON:

```json
// Actualizar métricas
{
  "type": "metrics",
  "cpu": 45,
  "ram": 72,
  "temp": 61,
  "diskHealth": "Bueno"
}

// Enviar log a la consola
{
  "type": "log",
  "message": "Tarea completada",
  "level": "success"
}
```

Para enviar comandos al backend desde JavaScript:

```js
enviarACSharp("iniciar_limpieza");
```

#### 🎨 Diseño

| Elemento | Detalle |
|----------|---------|
| Fondo | Degradado fijo `#050110 → #1e0b36 → #4c1d95` |
| Tarjetas | Glassmorphism con `backdrop-filter: blur(12px)` |
| Acentos | Morado `#a855f7` con glow animado |
| Fuente | Segoe UI / system-ui |
| Animaciones | `fadeInUp` en cambio de sección, shimmer en hover |

---

## 🗂️ Estructura del Repositorio

```
📁 PanelTIMaestro/
├── PanelTIMaestro_v3_0.bat   # Script de consola (v3.0)
├── index.html                 # Interfaz gráfica WebView2 (v2.0)
└── README.md
```

---

## 📋 Roadmap / Ideas Futuras

- [ ] Integrar el `.bat` con la interfaz HTML como acciones ejecutables desde el panel
- [ ] Añadir soporte multi-idioma (EN / ES)
- [ ] Exportar reportes de salud del sistema a PDF
- [ ] Modo portable (sin instalación) con empaquetado `.exe`

---

## ⚠️ Advertencias

- El script `.bat` realiza cambios a nivel de sistema operativo. **Úsalo con responsabilidad** y solo en equipos sobre los que tienes autorización.
- Algunas operaciones (Debloat, Telemetría, Copilot) son **irreversibles** o difíciles de revertir. Se recomienda crear un punto de restauración antes (opción 14 → Backup).

---

## 📄 Licencia

Este proyecto es de uso libre para soporte técnico profesional y personal. Si lo modificas o distribuyes, mantén la atribución original.
