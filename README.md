# RetroGamingBox

## Tu Consola de Gaming Portable para Linux Mint

Transformando Linux Mint 22.3 con Cinnamon en una RetroGamingBox profesional estilo Batocera/Steam Deck, usando **RetroArch** y **ES-DE** (EmulationStation Desktop Edition).

---

## Características

- ✅ **Configuración Portable** - Todo en una carpeta, sin modificar el sistema
- ✅ **Multi-Sistema** - Soporte para 50+ sistemas (NES, SNES, GBA, Genesis, PS1, Arcade, etc.)
- ✅ **ES-DE Frontend** - Interfaz moderna estilo consola
- ✅ **Cores Libretro** - 13 cores preinstalados, optimizados para Intel Iris Xe
- ✅ **Themes Intercambiables** - Steam Deck, PS5, Nintendo Switch
- ✅ **Shaders** - CRT, LCD, Pixel-perfect (cambiables)
- ✅ **Scraper Automático** - ScreenScraper + TheGamesDB
- ✅ **Guardado Portable** - Saves en `/home/fabian/ROMs_Archive/saves/`

---

## Estructura

```
RetroGamingBox/
├── configs/
│   ├── retroarch/       # Configuración portable de RetroArch
│   └── es-de/           # Configuración de ES-DE
├── cores/               # Cores libretro
├── themes/              # 3 themes (steamdeck, ps5, switch)
├── shaders/             # Shaders CRT, LCD, Pixel-perfect
├── overlays/            # Overlays y bezels
├── bios/                # Carpeta para BIOS
├── media/               # Recursos multimedia
├── scripts/             # Scripts de gestión
│   ├── start_retrobox.sh    # Launcher modo consola
│   ├── switch_shader.sh     # Cambiar shaders
│   ├── switch_theme.sh      # Cambiar themes
│   ├── install_cores.sh     # Re-instalar cores
│   ├── install_shaders.sh   # Re-instalar shaders
│   └── scraper.sh           # Scraper automático
├── saves/               # Enlaces a saves
├── launch.sh            # Script principal de lanzamiento
└── README.md            # Este archivo
```

---

## Requisitos

- **OS:** Linux Mint 22.3 (Ubuntu 24.04) o similar
- **GPU:** Intel Iris Xe (o cualquier GPU con soporte OpenGL)
- **RAM:** 4GB mínimo (8GB recomendado)
- **Espacio:** 500MB para configs + espacio para ROMs

### Dependencias

```bash
sudo apt install retroarch libretro-cores ffmpeg p7zip-full unclutter
```

---

## Instalación Rápida

### 1. Clonar o descargar este repositorio

```bash
cd /home/fabian
git clone https://github.com/tu-usuario/RetroGamingBox.git
cd RetroGamingBox
```

### 2. Hacer ejecutables los scripts

```bash
chmod +x scripts/*.sh launch.sh
```

### 3. Organizar tus ROMs

Coloca tus ROMs en `/home/fabian/ROMs_Archive/`:

```
/home/fabian/ROMs_Archive/
├── snes/
├── nes/
├── gbc/
├── gba/
├── genesis/
├── n64/
├── psx/
├── dreamcast/
├── mame/
├── arcade/
└── saves/
    ├── snes/
    ├── nes/
    └── ...
```

### 4. Lanzar

```bash
./launch.sh                    # Lanzar RetroArch directamente
./scripts/start_retrobox.sh    # Launcher modo consola (menú interactivo)
```

---

## Uso

### Scripts Principales

```bash
./launch.sh                    # Iniciar RetroArch
./scripts/start_retrobox.sh     # Menú modo consola
./scripts/switch_shader.sh crt # Activar shader CRT
./scripts/switch_shader.sh lcd # Activar shader LCD
./scripts/switch_shader.sh pixel  # Pixel-perfect
./scripts/switch_theme.sh ps5  # Cambiar a theme PS5
```

### Controles de RetroArch

| Acción | Tecla |
|--------|-------|
| Menú | F1 |
| Guardar Estado | F3 |
| Cargar Estado | F2 |
| Fast Forward | F7 |
| Rewind | F6 |
| Salir | Escape |

| Acción | Tecla Alternativa |
|--------|-------------------|
| Aceptar/Saltar | Z |
| Retroceder/Atrás | X |
| Arriba/Abajo | Flechas |
| Menú Quick | Enter |

---

## Sistemas Soportados

| Sistema | Core | Extensiones |
|---------|------|-------------|
| NES | Mesen, Nestopia | .nes, .fds |
| SNES | Snes9x, bsnes | .sfc, .smc, .fig, .swc |
| GB/GBC | Gambatte, SameBoy | .gb, .gbc |
| GBA | mGBA, VBA-M | .gba |
| Genesis | Genesis Plus GX | .md, .smd, .gen, .bin |
| N64 | Mupen64Plus-Next | .n64, .v64, .z64 |
| PS1 | Beetle PSX HW, SwanStation | .cue, .bin, .img, .pbp |
| Dreamcast | Flycast | .cdi, .gdi, .chd |
| PSP | PPSSPP | .iso, .cso |
| Arcade | FBNeo, MAME 2003+ | .zip |
| Saturn | Beetle Saturn | .iso |
| GC/Wii | Dolphin | .iso, .gcm, .wad |
| DS | MelonDS, DeSmuME | .nds |
| Atari 2600 | Stella | .a26, .a52, .bin |

---

## Configuración

### Rutas

| Recurso | Ruta |
|---------|------|
| ROMs | `/home/fabian/ROMs_Archive/` |
| Saves | `/home/fabian/ROMs_Archive/saves/` |
| Cores | `/home/fabian/RetroGamingBox/cores/` |
| Config | `/home/fabian/RetroGamingBox/configs/` |

### Shaders

- **CRT (para TV):** `./scripts/switch_shader.sh crt`
- **LCD (para monitores):** `./scripts/switch_shader.sh lcd`
- **Pixel-Perfect:** `./scripts/switch_shader.sh pixel`
- **Off:** `./scripts/switch_shader.sh off`

### Themes ES-DE

- **Steam Deck (default):** Oscuro, minimalista
- **PS5:** Moderno, gradientes azules
- **Nintendo Switch:** Colores vibrantes

Para instalar themes en ES-DE:
```bash
./scripts/switch_theme.sh steamdeck  # Instalar theme Steam Deck
```

---

## Scraper

Generar metadata automática:

```bash
# Scrapear todos los sistemas
./scripts/scraper.sh all

# Scrapear un sistema específico
./scripts/scraper.sh snes
./scripts/scraper.sh psx

# Forzar re-scraping
./scripts/scraper.sh force
```

---

## Optimización

El script `start_retrobox.sh` optimiza automáticamente:

1. **CPU:** Establece governor a `performance`
2. **GPU:** Activa modo rendimiento
3. **Sistema:** Cierra apps innecesarias
4. **Cursor:** Oculta cursor automáticamente

---

## Solución de Problemas

### "EmulationStation no encontrado"

Instala ES-DE manualmente:
1. Descarga desde https://es-de.org
2. Instala el .deb: `sudo dpkg -i emulationstation-de-*.deb`

### "Cores no cargan"

Verifica que los cores estén en:
```bash
ls /home/fabian/RetroGamingBox/cores/
```

### "Shaders no funcionan"

Los shaders deben estar en formato `.glslp`. Verifica:
```bash
ls /home/fabian/RetroGamingBox/shaders/*/
```

---

## Contribuir

1. Fork el repositorio
2. Crea una rama (`git checkout -b feature/nueva-funcion`)
3. Commit cambios (`git commit -m 'Agregar nueva función'`)
4. Push a la rama (`git push origin feature/nueva-funcion`)
5. Abre un Pull Request

---

## Licencia

Este proyecto es de código abierto bajo licencia MIT. Puedes usarlo, modificarlo y distribuirlo libremente.

---

## Créditos

- **RetroArch:** https://www.retroarch.com/
- **ES-DE:** https://es-de.org/
- **Libretro Cores:** https://buildbot.libretro.com/
- **Temas:** Comunidades de ES-DE y libretro

---

## Contacto

- GitHub Issues: Para reportar bugs
- Discord: [Link del servidor]

---

**¡Disfruta tu RetroGamingBox!** 🎮