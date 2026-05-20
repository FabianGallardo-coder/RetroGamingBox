#!/bin/bash
# =====================================================
# INSTALL_SHADERS.SH - Instalar shaders para RetroArch
# =====================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHADERS_DIR="/home/fabian/RetroGamingBox/shaders"
LOG_FILE="$SCRIPT_DIR/logs/shaders_install.log"

echo "=============================================="
echo "INSTALANDO SHADERS PARA RETROARCH"
echo "=============================================="

mkdir -p "$SHADERS_DIR"/{crt,lcd,pixel}
mkdir -p "$(dirname "$LOG_FILE")"

# URL base de shaders libretro
SHADER_REPO="https://github.com/libretro/glsl-shaders"

echo "Descargando shaders básicos..."

# Shader CRT simple (scanlines básicas)
cat > "$SHADERS_DIR/crt/CRT-Básico.glslp" << 'EOF'
shaders = 1
shader0 = shaders/crt/crtsimple.glsl
filter = nearest
scale_type_x = viewport
scale_type_y = viewport
scale = 1.0
EOF

# Crear shader CRT simple
mkdir -p "$SHADERS_DIR/crt/shaders/crt"
cat > "$SHADERS_DIR/crt/shaders/crt/crtsimple.glsl" << 'EOF'
/*
 * CRT Scanlines Shader Simple
 * Una versión simplificada de scanlines para RetroArch
 */

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 Resolution;
uniform sampler2D Texture;

void main(void) {
    vec2 uv = gl_FragCoord.xy / Resolution.xy;
    vec3 color = texture2D(Texture, uv).rgb;

    // Aplicar efecto de scanlines
    float scanline = sin(uv.y * Resolution.y * 1.5) * 0.04;
    color.rgb -= scanline;

    gl_FragColor = vec4(color, 1.0);
}
EOF

# Shader LCD (sin efecto, solo limpieza)
cat > "$SHADERS_DIR/lcd/LCD-Clean.glslp" << 'EOF'
shaders = 1
shader0 = shaders/lcd/lcdclean.glsl
filter = linear
scale_type_x = source
scale_type_y = source
scale = 1.0
EOF

mkdir -p "$SHADERS_DIR/lcd/shaders/lcd"
cat > "$SHADERS_DIR/lcd/shaders/lcd/lcdclean.glsl" << 'EOF'
/*
 * LCD Clean Shader
 * Elimina efectos CRT para pantallas LCD modernas
 */

#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D Texture;

void main(void) {
    gl_FragColor = texture2D(Texture, gl_FragCoord.xy / 1.0);
}
EOF

# Shader Pixel-Perfect
cat > "$SHADERS_DIR/pixel/PIXEL-Perfect.glslp" << 'EOF'
shaders = 0
filter = nearest
scale_type_x = source
scale_type_y = source
EOF

# CRT Royale (versión simplificada)
cat > "$SHADERS_DIR/crt/CRT-Royale.glslp" << 'EOF'
shaders = 1
shader0 = shaders/crt-royale/crt-royale.glsl
filter = nearest
scale_type_x = source
scale_type_y = source
scale = 1.0
EOF

mkdir -p "$SHADERS_DIR/crt/shaders/crt-royale"
cat > "$SHADERS_DIR/crt/shaders/crt-royale/crt-royale.glsl" << 'EOF'
/*
 * CRT Royale Shader (Versión Simple)
 * Efecto CRT para pantallas de TV
 */

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 OutputSize;
uniform vec2 TextureSize;
uniform sampler2D Texture;

void main(void) {
    vec2 uv = gl_FragCoord.xy / OutputSize.xy;
    vec2 texUV = uv * (OutputSize.xy / TextureSize.xy);

    vec3 color = texture2D(Texture, texUV).rgb;

    // Simular scanlines
    float scanline = sin(uv.y * OutputSize.y * 0.5) * 0.04;
    color.rgb -= scanline;

    // Simular curvatura CRT básica
    vec2 center = uv - 0.5;
    float dist = length(center);
    color.rgb *= 1.0 - dist * 0.2;

    gl_FragColor = vec4(color, 1.0);
}
EOF

echo ""
echo "✓ Shaders instalados:"
echo ""
echo "  Directorio: $SHADERS_DIR"
echo ""
ls -la "$SHADERS_DIR"/*/

echo ""
echo "=============================================="
echo "USO DE SHADERS"
echo "=============================================="
echo ""
echo "Para activar un shader, edita la configuración de RetroArch"
echo "o usa el script switch_shader.sh:"
echo ""
echo "  ./scripts/switch_shader.sh crt    # Activar CRT"
echo "  ./scripts/switch_shader.sh lcd    # Activar LCD"
echo "  ./scripts/switch_shader.sh pixel  # Pixel-perfect"
echo "  ./scripts/switch_shader.sh off    # Desactivar"
echo ""
echo "También puedes activar shaders manualmente en RetroArch:"
echo "  1. Abre RetroArch (./launch.sh)"
echo "  2. Ve a Settings > Video > Shaders"
echo "  3. Carga el preset .glslp que necesites"