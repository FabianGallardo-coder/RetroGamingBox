#!/bin/bash
# =====================================================
# INSTALL_ALL_CORES.SH - Instalar TODOS los cores para RetroGamingBox
# Compatible con Intel Iris Xe / Linux Mint
# =====================================================

set -e

COREBOT_DIR="/home/fabian/RetroGamingBox/cores"
LOG_FILE="/home/fabian/RetroGamingBox/logs/cores_install.log"
BUILD_URL="https://buildbot.libretro.com/nightly/linux/x86_64/latest/"

echo "=============================================="
echo "INSTALANDO TODOS LOS CORES LIBRETRO"
echo "=============================================="

mkdir -p "$COREBOT_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

# Cores prioritarios para tu sistema
CORES_PRIORITY=(
    "mesen_libretro"
    "mupen64plus_next_libretro"
    "flycast_libretro"
    "ppsspp_libretro"
    "mednafen_saturn_libretro"
    "fbneo_libretro"
    "mame2003_plus_libretro"
    "dolphin_libretro"
    "melonds_libretro"
    "stella_libretro"
    "genesis_plus_gx_libretro"
    "snes9x_libretro"
    "gambatte_libretro"
    "mgba_libretro"
    "nestopia_libretro"
    "desmume_libretro"
    "mednafen_psx_libretro"
    "bsnes2014_balanced_libretro"
    "beetle_pce_fast_libretro"
    "mednafen_wswan_libretro"
    "mednafen_vb_libretro"
)

echo "Descargando cores desde buildbot.libretro.com..."
echo ""

download_core() {
    local core_name="$1"
    local zip_url="${BUILD_URL}${core_name}.so.zip"
    local zip_file="/tmp/${core_name}.zip"
    local so_file="${COREBOT_DIR}/${core_name}.so"

    echo -n "  [$core_name]... "

    # Si ya existe, saltar
    if [ -f "$so_file" ]; then
        echo "ya existe, omitiendo"
        return 0
    fi

    # Descargar
    if curl -L -f --connect-timeout 30 --max-time 180 \
        -o "$zip_file" "$zip_url" 2>/dev/null; then

        # Extraer
        if unzip -o "$zip_file" -d "$COREBOT_DIR" 2>/dev/null; then
            # Buscar el archivo .so extraído
            local extracted=$(find "$COREBOT_DIR" -maxdepth 1 -name "${core_name}.so" 2>/dev/null | head -1)
            if [ -n "$extracted" ] && [ "$extracted" != "$so_file" ]; then
                mv "$extracted" "$so_file" 2>/dev/null || true
            fi

            rm -f "$zip_file"
            echo "✓"
            return 0
        else
            rm -f "$zip_file"
            echo "✗ (error al extraer)"
            return 1
        fi
    else
        echo "✗ (no disponible)"
        return 1
    fi
}

TOTAL=${#CORES_PRIORITY[@]}
SUCCESS=0
FAILED=0

for core in "${CORES_PRIORITY[@]}"; do
    if download_core "$core"; then
        SUCCESS=$((SUCCESS + 1))
    else
        FAILED=$((FAILED + 1))
    fi
done

echo ""
echo "=============================================="
echo "RESUMEN:"
echo "  Exitosos: $SUCCESS"
echo "  Fallidos: $FAILED"
echo "  Total: $TOTAL"
echo "=============================================="

echo ""
echo "Cores instalados:"
ls -lh "$COREBOT_DIR"/*.so 2>/dev/null | awk '{print "  " $9 " (" $5 ")"}' | xargs -n1 basename 2>/dev/null

echo ""
echo "Log guardado en: $LOG_FILE"