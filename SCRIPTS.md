# =====================================================
# SCRIPTS DE RETROGAMINGBOX
# =====================================================

## Scripts Disponibles

### 1. launch.sh
Script principal para lanzar RetroArch.

```bash
./launch.sh
```

**Descripción:**
- Usa la configuración portable en `configs/retroarch/retroarch.cfg`
- Establece variables de entorno necesarias
- Inicia RetroArch con el frontend Ozone

---

### 2. start_retrobox.sh
Launcher modo consola con menú interactivo.

```bash
./scripts/start_retrobox.sh
```

**Descripción:**
- Transforma Linux Mint en una consola de gaming
- Menú interactivo con 7 opciones
- Optimiza el sistema automáticamente
- Permite cambiar shaders y themes

**Opciones:**
1. Iniciar ES-DE
2. Iniciar RetroArch
3. Cambiar shader
4. Cambiar theme
5. Abrir terminal
6. Ver información del sistema
7. Salir al escritorio

**Argumentos:**
```bash
./scripts/start_retrobox.sh --esde    # Iniciar ES-DE directamente
./scripts/start_retrobox.sh --retroarch  # Iniciar RetroArch directamente
./scripts/start_retrobox.sh --help   # Mostrar ayuda
```

---

### 3. switch_shader.sh
Cambia entre presets de shaders rápidamente.

```bash
./scripts/switch_shader.sh [opción]
```

**Opciones:**
- `crt` - Activar shader CRT (para pantallas de TV)
- `lcd` - Activar shader LCD (para pantallas modernas)
- `pixel` - Activar modo pixel-perfect (escala entera)
- `off` - Desactivar shaders completamente

**Ejemplos:**
```bash
./scripts/switch_shader.sh crt      # Activa CRT-Royale
./scripts/switch_shader.sh lcd      # Activa LCD-Clean
./scripts/switch_shader.sh pixel    # Activa pixel-perfect
./scripts/switch_shader.sh off      # Desactiva shaders
```

**Shaders disponibles:**
- CRT: `/shaders/crt/CRT-Royale.glslp`
- LCD: `/shaders/lcd/LCD-Clean.glslp`
- Pixel: `/shaders/pixel/PIXEL-Perfect.glslp`

---

### 4. switch_theme.sh
Cambia entre themes de ES-DE.

```bash
./scripts/switch_theme.sh [opción]
```

**Opciones:**
- `steamdeck` - Theme estilo Steam Deck (oscuro, minimalista)
- `ps5` - Theme estilo PlayStation 5 (moderno)
- `switch` - Theme estilo Nintendo Switch (colores vibrantes)
- `list` - Listar themes disponibles
- `help` - Mostrar ayuda

**Ejemplos:**
```bash
./scripts/switch_theme.sh steamdeck  # Activa theme Steam Deck
./scripts/switch_theme.sh ps5        # Activa theme PS5
./scripts/switch_theme.sh switch     # Activa theme Switch
./scripts/switch_theme.sh list       # Lista todos los themes
```

---

### 5. install_cores.sh
Re-instala los cores libretro desde el sistema.

```bash
./scripts/install_cores.sh
```

**Descripción:**
- Instala cores desde APT del sistema
- Copia los cores a `cores/` para uso portable
- Genera log en `logs/cores_install.log`

**Cores instalados:**
- Mesen (NES)
- Nestopia (NES)
- Snes9x (SNES)
- bsnes (SNES)
- Gambatte (GB/GBC)
- mGBA (GBA)
- Genesis Plus GX (Genesis)
- Beetle PCE Fast (PC Engine)
- Beetle PSX (PS1)
- Beetle VB (Virtual Boy)
- Beetle WSWAN (Wonderswan)
- DeSmuME (DS)
- bsnes Mercury (SNES/GB/GBC)

---

### 6. install_shaders.sh
Re-instala los shaders básicos.

```bash
./scripts/install_shaders.sh
```

**Descripción:**
- Crea shaders básicos (CRT, LCD, Pixel-perfect)
- Los guarda en `shaders/`

---

### 7. install_esde.sh
Script para instalar ES-DE.

```bash
./scripts/install_esde.sh
```

**Descripción:**
- Busca la última versión de ES-DE
- Intenta descargar e instalar automáticamente
- Si falla, muestra instrucciones manuales

**Nota:** ES-DE necesita instalarse manualmente desde https://es-de.org

---

### 8. scraper.sh
Scraper automático para generar metadata.

```bash
./scripts/scraper.sh [opción]
```

**Opciones:**
- Sin argumentos - Scraper de todos los sistemas
- `all` - Scraper de todos los sistemas
- `[sistema]` - Scraper de un sistema específico
- `update` - Actualizar metadata existente
- `force` - Forzar re-scraping completo

**Ejemplos:**
```bash
./scripts/scraper.sh              # Scraper todos los sistemas
./scripts/scraper.sh all          # Lo mismo que arriba
./scripts/scraper.sh snes        # Solo SNES
./scripts/scraper.sh psx         # Solo PS1
./scripts/scraper.sh force       # Forzar re-scraping
```

**Sistemas disponibles:**
- snes, nes, gbc, gba, genesis, n64, psx, dreamcast, psp, mame, atari

---

## Crear Scripts Personalizados

### Ejemplo: Script para cambiar pantalla

```bash
#!/bin/bash
# Cambiar entre CRT y LCD según necesidad

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "¿Qué tipo de pantalla tienes?"
echo "1. CRT (TV antiguo)"
echo "2. LCD/LED (Monitor moderno)"
read -r choice

case "$choice" in
    1) $SCRIPT_DIR/switch_shader.sh crt ;;
    2) $SCRIPT_DIR/switch_shader.sh lcd ;;
esac
```

---

## Variables de Entorno

Puedes personalizar las rutas editando los scripts:

```bash
RETROGAMING_DIR="/home/fabian/RetroGamingBox"
ROMS_DIR="/home/fabian/ROMs_Archive"
SAVES_DIR="/home/fabian/ROMs_Archive/saves"
```

---

## Depuración

### Ver logs de scripts

```bash
cat logs/cores_install.log
cat logs/shaders_install.log
cat logs/scraper.log
```

### Verificar permisos

```bash
ls -la scripts/*.sh
```

### Ver cores instalados

```bash
ls -lh cores/*.so | wc -l
```

---

## Tips

1. **Atajos de teclado en RetroArch:**
   - F1: Menú
   - F2: Load state
   - F3: Save state
   - F6: Rewind
   - F7: Fast forward
   - Esc: Salir

2. **Crear atajos en el escritorio:**
   ```bash
   # Crear lanzador para RetroArch
   ln -s /home/fabian/RetroGamingBox/launch.sh ~/Escritorio/RetroArch.desktop
   ```

3. **Scripts de ejemplo para temas específicos:**
   ```bash
   # Auto-switch theme según hora del día
   ./scripts/switch_theme.sh $( [ $(date +%H) -lt 20 ] && echo "steamdeck" || echo "ps5" )
   ```

4. **Verificar que todo funciona:**
   ```bash
   ./scripts/start_retrobox.sh 6  # Opción 6 = info del sistema
   ```