#!/bin/bash
# =====================================================
# INSTALL_CORES.SH - Instalar cores libretro para RetroGamingBox
# Versión: Instala desde APT y copia a carpeta portable
# =====================================================

set -e

COREBOT_DIR="/home/fabian/RetroGamingBox/cores"
LOG_FILE="/home/fabian/RetroGamingBox/logs/cores_install.log"
SYSTEM_CORES="/usr/lib/x86_64-linux-gnu/libretro"

echo "=============================================="
echo "INSTALANDO CORES LIBRETRO"
echo "=============================================="

mkdir -p "$COREBOT_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

# Cores disponibles en apt para Ubuntu 24.04
CORES_APT=(
    "libretro-core-info"
    "libretro-beetle-pce-fast"
    "libretro-beetle-psx"
    "libretro-beetle-vb"
    "libretro-beetle-wswan"
    "libretro-bsnes-mercury-balanced"
    "libretro-bsnes-mercury-performance"
    "libretro-desmume"
    "libretro-gambatte"
    "libretro-mgba"
    "libretro-nestopia"
    "libretro-genesisplusgx"
    "libretro-snes9x"
)

# Cores adicionales a buscar
OTROS_CORES=(
    "mesen"
    "mupen64plus-next"
    "flycast"
    "ppsspp"
    "fbneo"
    "mame2003-plus"
    "stella"
    "melonds"
    "beetle-saturn"
    "dolphin"
    "sameboy"
)

echo "Instalando cores desde APT..."
echo "2545" | sudo -S apt-get install -y "${CORES_APT[@]}" 2>/dev/null || true

echo ""
echo "Copiando cores a directorio portable..."
echo ""

TOTAL=0
COPIED=0
SKIPPED=0

# Copiar cores del sistema
if [ -d "$SYSTEM_CORES" ]; then
    for core_file in "$SYSTEM_CORES"/*_libretro.so; do
        if [ -f "$core_file" ]; then
            TOTAL=$((TOTAL + 1))
            CORE_NAME=$(basename "$core_file")
            if [ ! -f "$COREBOT_DIR/$CORE_NAME" ]; then
                cp "$core_file" "$COREBOT_DIR/$CORE_NAME"
                echo "  ✓ $CORE_NAME"
                COPIED=$((COPIED + 1))
            else
                echo "  - $CORE_NAME (ya existe)"
                SKIPPED=$((SKIPPED + 1))
            fi
        fi
    done
fi

echo ""
echo "=============================================="
echo "RESUMEN:"
echo "  Copiados: $COPIED"
echo "  Omitidos: $SKIPPED"
echo "  Total cores: $TOTAL"
echo "=============================================="

echo ""
echo "Cores instalados en: $COREBOT_DIR"
ls -lh "$COREBOT_DIR"/*.so 2>/dev/null | awk '{print "  " $9 " (" $5 ")"}'