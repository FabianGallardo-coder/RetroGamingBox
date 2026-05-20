# =====================================================
# SWITCH_SHADER.SH - Cambiar preset de shader rápidamente
# Uso: ./switch_shader.sh [crt|lcd|pixel|off]
# =====================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RETROARCH_CFG="/home/fabian/RetroGamingBox/configs/retroarch/retroarch.cfg"

# Rutas de shaders
SHADER_CRT="/home/fabian/RetroGamingBox/shaders/crt/CRT-Royale.glslp"
SHADER_LCD="/home/fabian/RetroGamingBox/shaders/lcd/LCD-Clean.glslp"
SHADER_PIXEL="/home/fabian/RetroGamingBox/shaders/pixel/PIXEL-Perfect.glslp"

show_help() {
    echo "Uso: $0 [opción]"
    echo ""
    echo "Opciones:"
    echo "  crt     - Activar shader CRT (para pantallas de TV)"
    echo "  lcd     - Activar shader LCD (para pantallas modernas)"
    echo "  pixel   - Activar modo pixel-perfect (escala entera)"
    echo "  off     - Desactivar shaders"
    echo ""
    echo "Ejemplo:"
    echo "  $0 crt    # Activa CRT-Royale"
}

apply_shader() {
    local shader_type="$1"
    local shader_path=""

    case "$shader_type" in
        crt)
            if [ -f "$SHADER_CRT" ]; then
                shader_path="$SHADER_CRT"
                echo "Activando shader CRT (CRT-Royale)..."
            else
                echo "ERROR: Shader CRT no encontrado: $SHADER_CRT"
                echo "Instala los shaders con: ./install_shaders.sh"
                exit 1
            fi
            ;;
        lcd)
            if [ -f "$SHADER_LCD" ]; then
                shader_path="$SHADER_LCD"
                echo "Activando shader LCD..."
            else
                echo "ERROR: Shader LCD no encontrado: $SHADER_LCD"
                exit 1
            fi
            ;;
        pixel)
            echo "Activando modo pixel-perfect (integer scaling)..."
            # Desactivar shaders pero mantener integer scaling
            sed -i 's/video_shader_enable = "true"/video_shader_enable = "false"/' "$RETROARCH_CFG"
            sed -i 's/video_scale_integer = "false"/video_scale_integer = "true"/' "$RETROARCH_CFG"
            echo "✓ Pixel-perfect activado (shaders desactivados)"
            return 0
            ;;
        off)
            echo "Desactivando shaders..."
            sed -i 's/video_shader_enable = "true"/video_shader_enable = "false"/' "$RETROARCH_CFG"
            sed -i 's|^video_shader = .*|video_shader = "false"|' "$RETROARCH_CFG"
            echo "✓ Shaders desactivados"
            return 0
            ;;
        *)
            echo "ERROR: Opción desconocida: $shader_type"
            show_help
            exit 1
            ;;
    esac

    if [ -n "$shader_path" ]; then
        # Activar shader
        sed -i 's/video_shader_enable = "false"/video_shader_enable = "true"/' "$RETROARCH_CFG"
        sed -i "s|^video_shader = .*|video_shader = \"$shader_path\"|" "$RETROARCH_CFG"
        echo "✓ Shader activado: $shader_path"
    fi
}

# Verificar que el archivo de config existe
if [ ! -f "$RETROARCH_CFG" ]; then
    echo "ERROR: No se encontró config de RetroArch: $RETROARCH_CFG"
    exit 1
fi

# Verificar argumentos
if [ $# -eq 0 ]; then
    show_help
    exit 0
fi

apply_shader "$1"