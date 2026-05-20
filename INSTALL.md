# Instalación de RetroGamingBox

## Guía paso a paso para instalar RetroGamingBox en Linux Mint 22.3

---

## Método 1: Instalación Rápida (Recomendado)

### 1. Clonar el repositorio

```bash
cd /home/fabian
git clone https://github.com/tu-usuario/RetroGamingBox.git
cd RetroGamingBox
```

### 2. Hacer ejecutables los scripts

```bash
chmod +x launch.sh
chmod +x scripts/*.sh
```

### 3. Verificar dependencias

```bash
# Instalar dependencias necesarias
sudo apt update
sudo apt install -y retroarch libretro-cores ffmpeg p7zip-full unclutter xdotool
```

### 4. Organizar tus ROMs

Crea la estructura de carpetas:

```bash
mkdir -p /home/fabian/ROMs_Archive/{snes,nes,gbc,gba,genesis,n64,psx,dreamcast,psp,mame,saturn,gc,wii,nds,atari,saves,screenshots,thumbnails}
```

Coloca tus archivos ROM en las carpetas correspondientes.

### 5. Primer inicio

```bash
./launch.sh
```

---

## Método 2: Instalación Manual

### Paso 1: Estructura de carpetas

```bash
mkdir -p ~/RetroGamingBox/{configs/retroarch,cores,themes,shaders,overlays,bios,media,scripts,saves,logs,temp,backups}
mkdir -p ~/ROMs_Archive/{snes,nes,gbc,gba,genesis,n64,psx,dreamcast,mame,saves,screenshots,thumbnails}
```

### Paso 2: Instalar RetroArch

```bash
sudo apt install -y retroarch
```

### Paso 3: Copiar cores

```bash
# Los cores del sistema
cp /usr/lib/x86_64-linux-gnu/libretro/*_libretro.so ~/RetroGamingBox/cores/
```

### Paso 4: Descargar ES-DE

```bash
# Ve a https://es-de.org y descarga la versión para Linux
# Luego:
sudo dpkg -i emulationstation-de-*.deb
sudo apt-get -f install
```

### Paso 5: Configurar variables de entorno

Agrega a tu `~/.bashrc`:

```bash
export RETROGAMING_DIR="$HOME/RetroGamingBox"
export XDG_CONFIG_HOME="$HOME/.config"
export RETROARCH_CONFIG="$RETROGAMING_DIR/configs/retroarch/retroarch.cfg"
alias retrobox='cd $RETROGAMING_DIR && ./launch.sh'
```

---

## Instalación de Cores Adicionales

### Desde APT (disponibles en Ubuntu 24.04)

```bash
sudo apt install -y \
  libretro-core-info \
  libretro-beetle-pce-fast \
  libretro-beetle-psx \
  libretro-bsnes-mercury-balanced \
  libretro-desmume \
  libretro-gambatte \
  libretro-mgba \
  libretro-nestopia \
  libretro-genesisplusgx \
  libretro-snes9x
```

### Desde buildbot.libretro.com (más cores)

```bash
./scripts/install_cores.sh
```

---

## Configuración Post-Instalación

### 1. Configurar ES-DE

```bash
# La primera vez que inicies ES-DE, configurará las rutas automáticamente
emulationstation
```

### 2. Agregar sistemas manualmente (opcional)

Edita `~/.config/es-de/systems.cfg`:

```xml
<system>
    <name>snes</name>
    <fullname>Super Nintendo Entertainment System</fullname>
    <path>/home/tu-usuario/ROMs_Archive/snes</path>
    <extension>.zip .sfc .smc .fig .swc</extension>
    <command>retroarch -L ~/.config/retroarch/cores/snes9x_libretro.so "%ROM%"</command>
    <platform>snes</platform>
    <theme>snes</theme>
</system>
```

### 3. Configurar Scraping

```bash
# Instalar skyscraper
sudo apt install -y skyscraper

# Configurar credenciales ScreenScraper (opcional)
mkdir -p ~/.config/skyscraper
cat > ~/.config/skyscraper/config.ini << 'EOF'
[options]
modules = screenscraper,tgdb
screenscraperuser = TU_USUARIO
screenscraperpass = TU_CONTRASEÑA
EOF
```

---

## Verificación de Instalación

### Test 1: RetroArch

```bash
./launch.sh
# Debería abrir RetroArch con el menú Ozone
```

### Test 2: Cores

```bash
retroarch -L ~/RetroGamingBox/cores/snes9x_libretro.so --check
```

### Test 3: ES-DE

```bash
emulationstation
# Debería mostrar el menú principal
```

### Test 4: Shaders

```bash
./scripts/switch_shader.sh crt
```

---

## Solución de Problemas

### Error: "Cannot locate system"

Solución: Verifica que las carpetas de ROMs existan y contengan archivos

### Error: "Core not found"

Solución: Verifica que los cores estén en `~/RetroGamingBox/cores/`

### Error: "Permission denied" en scripts

Solución:
```bash
chmod +x scripts/*.sh
```

### Error: ES-DE no detecta ROMs

Solución: Verifica los permisos de las carpetas
```bash
chmod -R 755 ~/ROMs_Archive
```

---

## Desinstalación

### Solo RetroGamingBox (mantener ROMs)

```bash
rm -rf ~/RetroGamingBox
```

### Desinstalar todo

```bash
# RetroGamingBox
rm -rf ~/RetroGamingBox

# ROMs y saves
rm -rf ~/ROMs_Archive

# Configs de usuario
rm -rf ~/.config/es-de
rm -rf ~/.config/retroarch

# Paquetes del sistema
sudo apt remove -y retroarch libretro-cores
```

---

## Actualización

```bash
cd ~/RetroGamingBox
git pull origin main
./scripts/install_cores.sh  # Re-instalar cores si es necesario
```

---

## Soporte

- **Issues:** https://github.com/tu-usuario/RetroGamingBox/issues
- **Wiki:** https://github.com/tu-usuario/RetroGamingBox/wiki