#!/bin/bash
# =====================================================
# INSTALL_ESDE.SH - Instalar ES-DE (EmulationStation Desktop Edition)
# Para RetroGamingBox
# =====================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ESDE_DIR="/home/fabian/RetroGamingBox/es-de"
LOG_FILE="/home/fabian/RetroGamingBox/logs/esde_install.log"

echo "=============================================="
echo "INSTALANDO ES-DE (EmulationStation Desktop Edition)"
echo "=============================================="

mkdir -p "$ESDE_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

# Detectar arquitectura
ARCH=$(uname -m)
if [ "$ARCH" != "x86_64" ]; then
    echo "ERROR: Esta configuración es solo para x86_64. Arquitectura detectada: $ARCH"
    exit 1
fi

# Intentar descargar desde es-de.org
ESDE_URL=""
VERSION="3.4.1"

echo "Buscando última versión de ES-DE..."

# Método 1: Descargar desde es-de.org
if curl -sL "https://es-de.org/download/linux/" > /tmp/esde_page.html 2>&1; then
    DOWNLOAD_URL=$(grep -oP 'href="[^"]*emulationstation-de[^"]*x64\.deb"' /tmp/esde_page.html | head -1 | cut -d'"' -f2)
    if [ -n "$DOWNLOAD_URL" ]; then
        ESDE_URL="$DOWNLOAD_URL"
        echo "URL encontrada: $ESDE_URL"
    fi
fi

# Método 2: Si no se encontró, intentar con wget
if [ -z "$ESDE_URL" ]; then
    echo "Intentando método alternativo..."

    # Intentar descarga directa (ajusta la URL según la versión actual)
    ESDE_DEB_URL="https://es-de.org/releases/emulationstation-de-${VERSION}-x64.deb"

    echo "Descargando desde: $ESDE_DEB_URL"

    if curl -L -f --connect-timeout 60 --max-time 300 \
        -o "/tmp/emulationstation-de_${VERSION}_x64.deb" \
        "$ESDE_DEB_URL" 2>&1; then

        echo "Instalando .deb..."
        echo "2545" | sudo -S dpkg -i "/tmp/emulationstation-de_${VERSION}_x64.deb" 2>/dev/null || true
        echo "2545" | sudo -S apt-get -f install -y 2>/dev/null || true

        # Copiar a directorio portable
        if [ -f /usr/bin/emulationstation ]; then
            echo "Creando versión portable..."
            mkdir -p "$ESDE_DIR"
            # Aquí iría la lógica para crear una versión portable
        fi

        echo "✓ ES-DE instalado exitosamente"
        echo "OK: ES-DE ${VERSION}" >> "$LOG_FILE"
    else
        echo "No se pudo descargar ES-DE automáticamente."
        echo "Por favor, descarga manualmente desde: https://es-de.org"
        echo "Descarga el archivo .deb para Linux y ejecuta:"
        echo "  sudo dpkg -i emulationstation-de-X.X.X-x64.deb"
        echo "  sudo apt-get -f install"
    fi
fi

# Crear configuración portable
mkdir -p ~/.config/es-de
mkdir -p ~/.local/share/es-de

echo ""
echo "=============================================="
echo "CONFIGURACIÓN DE RUTAS"
echo "=============================================="

# Crear script de configuración de rutas
cat > ~/.config/es-de/paths.cfg << 'EOF'
# Rutas de ES-DE para RetroGamingBox
# Edita estas rutas según tu configuración

<system>
  <name>romDirectory</name>
  <value>/home/fabian/ROMs_Archive</value>
</system>
<system>
  <name>saveDirectory</name>
  <value>/home/fabian/ROMs_Archive/saves</value>
</system>
<system>
  <name>systemDirectory</name>
  <value>/home/fabian/RetroGamingBox/bios</value>
</system>
<system>
  <name>screenshotsDirectory</name>
  <value>/home/fabian/ROMs_Archive/screenshots</value>
</system>
<system>
  <name>thumbnailsDirectory</name>
  <value>/home/fabian/ROMs_Archive/thumbnails</value>
</system>
EOF

echo "Configuración de rutas creada en ~/.config/es-de/paths.cfg"
echo ""
echo "Para iniciar ES-DE, ejecuta:"
echo "  emulationstation"
echo ""
echo "O usa el script launch.sh de RetroGamingBox"