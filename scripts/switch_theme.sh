#!/bin/bash
# =====================================================
# SWITCH_THEME.SH - Cambiar theme de ES-DE rápidamente
# Uso: ./switch_theme.sh [steamdeck|ps5|switch]
# =====================================================

set -e

ESDE_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/es-de"
RETROGAMING_THEMES="/home/fabian/RetroGamingBox/themes"
THEME_LINK="$ESDE_CONFIG_DIR/theme/current"

show_help() {
    echo "Uso: $0 [opción]"
    echo ""
    echo "Opciones:"
    echo "  steamdeck  - Theme estilo Steam Deck (oscuro, minimalista)"
    echo "  ps5        - Theme estilo PlayStation 5 (moderno)"
    echo "  switch     - Theme estilo Nintendo Switch (colores vibrantes)"
    echo "  list       - Listar themes disponibles"
    echo ""
    echo "Ejemplo:"
    echo "  $0 steamdeck    # Activa theme Steam Deck"
}

list_themes() {
    echo "Themes disponibles:"
    echo ""
    for theme_dir in "$RETROGAMING_THEMES"/*; do
        if [ -d "$theme_dir" ]; then
            theme_name=$(basename "$theme_dir")
            description=""

            case "$theme_name" in
                steamdeck)
                    description="Estilo Steam Deck - Oscuro, minimalista"
                    ;;
                ps5)
                    description="Estilo PlayStation 5 - Moderno con gradientes"
                    ;;
                switch)
                    description="Estilo Nintendo Switch - Colores vibrantes, grid"
                    ;;
                *)
                    description="Theme personalizado"
                    ;;
            esac

            echo "  • $theme_name: $description"
        fi
    done
    echo ""
    echo "Themes en ES-DE:"
    if [ -d "$ESDE_CONFIG_DIR/themes" ]; then
        ls "$ESDE_CONFIG_DIR/themes" 2>/dev/null | sed 's/^/  • /'
    else
        echo "  (no hay themes instalados en ES-DE)"
    fi
}

apply_theme() {
    local theme_name="$1"
    local source_theme="$RETROGAMING_THEMES/$theme_name"

    echo "Aplicando theme: $theme_name"

    # Verificar que el theme source existe
    if [ ! -d "$source_theme" ]; then
        echo "ERROR: Theme no encontrado: $source_theme"
        echo "Instala los themes con: ./install_themes.sh"
        return 1
    fi

    # Copiar theme a la carpeta de themes de ES-DE
    mkdir -p "$ESDE_CONFIG_DIR/themes"

    # Si ya existe el theme, reemplazarlo
    if [ -d "$ESDE_CONFIG_DIR/themes/$theme_name" ]; then
        echo "  Reemplazando theme existente..."
        rm -rf "$ESDE_CONFIG_DIR/themes/$theme_name"
    fi

    # Copiar theme
    cp -r "$source_theme" "$ESDE_CONFIG_DIR/themes/"

    echo "✓ Theme '$theme_name' instalado en ES-DE"
    echo ""
    echo "Para activar el theme en ES-DE:"
    echo "  1. Abre ES-DE"
    echo "  2. Ve a Settings > UI Settings > Theme"
    echo "  3. Selecciona '$theme_name'"
    echo ""
    echo "O ejecuta ES-DE con el flag --theme:"
    echo "  emulationstation --theme $theme_name"
}

# Verificar argumentos
if [ $# -eq 0 ]; then
    show_help
    exit 0
fi

case "$1" in
    list)
        list_themes
        ;;
    steamdeck|ps5|switch)
        apply_theme "$1"
        ;;
    help|-h|--help)
        show_help
        ;;
    *)
        echo "ERROR: Theme desconocido: $1"
        show_help
        exit 1
        ;;
esac