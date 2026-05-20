#!/bin/bash
# =====================================================
# LAUNCH.SH - Launcher principal de RetroGamingBox
# =====================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RETROGAMING_DIR="$SCRIPT_DIR"

# Cargar configuración de entorno
export RETROGAMING_DIR="$SCRIPT_DIR"
export XDG_CONFIG_HOME="$SCRIPT_DIR/configs"

# Usar config portable de RetroArch
export RETROARCH_CONFIG="$SCRIPT_DIR/configs/retroarch/retroarch.cfg"

# Verificar si RetroArch está instalado
if ! command -v retroarch &> /dev/null; then
    echo "ERROR: RetroArch no está instalado"
    echo "Instálalo con: sudo apt install retroarch"
    exit 1
fi

# Verificar si existe la config
if [ ! -f "$RETROARCH_CONFIG" ]; then
    echo "ERROR: No se encontró configuración: $RETROARCH_CONFIG"
    exit 1
fi

# Lanzar RetroArch con la config portable
echo "Iniciando RetroGamingBox..."
exec retroarch -c "$RETROARCH_CONFIG"