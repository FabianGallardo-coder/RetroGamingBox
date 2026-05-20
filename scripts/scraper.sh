#!/bin/bash
# =====================================================
# SCRAPER.SH - Scraper automático para ES-DE
# Usa ScreenScraper + TheGamesDB como backup
# =====================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROMS_DIR="/home/fabian/ROMs_Archive"
GAMELISTS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/es-de/gamelists"
LOG_FILE="$SCRIPT_DIR/logs/scraper.log"

echo "=============================================="
echo "SCRAPER AUTOMÁTICO PARA ES-DE"
echo "=============================================="

# Verificar que skyscraper esté instalado
if ! command -v skyscraper &> /dev/null; then
    echo "Skyscraper no está instalado."
    echo "Instalando..."
    echo "2545" | sudo -S apt-get install -y skyscraper 2>/dev/null || {
        echo "ERROR: No se pudo instalar skyscraper"
        echo "Puedes instalarlo manualmente:"
        echo "  sudo apt install skyscraper"
        exit 1
    }
fi

mkdir -p "$GAMELISTS_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

# Configuración de ScreenScraper
SCREENSCRAPER_USER=""  # Opcional: tu usuario de ScreenScraper.fr
SCREENSCRAPAPER_PASS=""  # Opcional: tu contraseña

# Sistemas a hacer scrape
SYSTEMS=(
    "snes:Nintendo - Super Nintendo"
    "nes:Nintendo - Nintendo Entertainment System"
    "gbc:Nintendo - Game Boy Color"
    "gba:Nintendo - Game Boy Advance"
    "genesis:Sega - Genesis"
    "n64:Nintendo - Nintendo 64"
    "psx:Sony - PlayStation"
    "dreamcast:Sega - Dreamcast"
    "psp:Sony - PlayStation Portable"
    "mame:Arcade - MAME"
    "atari:Atari - Atari 2600"
)

show_help() {
    echo "Uso: $0 [opción]"
    echo ""
    echo "Opciones:"
    echo "  all         - Scraper de todos los sistemas"
    echo "  [sistema]   - Scraper de un sistema específico (snes, nes, gbc, etc.)"
    echo "  update      - Actualizar scraped games existentes"
    echo "  force       - Forzar re-scrape de todos los juegos"
    echo ""
    echo "Sistemas disponibles:"
    for sys in "${SYSTEMS[@]}"; do
        echo "  - ${sys%%:*}"
    done
}

scrape_system() {
    local system="${1%%:*}"
    local fullname="${1##*:}"
    local rom_path="$ROMS_DIR/$system"

    if [ ! -d "$rom_path" ]; then
        echo "  ⚠ Sistema no encontrado: $rom_path"
        return 1
    fi

    echo ""
    echo "──────────────────────────────────────────"
    echo "Scraping: $system ($fullname)"
    echo "──────────────────────────────────────────"

    # Verificar que haya ROMs
    rom_count=$(find "$rom_path" -type f \( -name "*.zip" -o -name "*.nes" -o -name "*.sfc" -o -name "*.smc" -o -name "*.md" -o -name "*.gba" -o -name "*.gbc" -o -name "*.iso" \) 2>/dev/null | wc -l)

    if [ "$rom_count" -eq 0 ]; then
        echo "  ⚠ No se encontraron ROMs en: $rom_path"
        return 1
    fi

    echo "  Encontradas: $rom_count ROMs"

    # Crear directorio para gamelist de este sistema
    mkdir -p "$GAMELISTS_DIR/$system"

    # Opciones de skyscraper
    SCRAPER_OPTS="-p $system -s screenscraper"

    # Añadir credenciales si están configuradas
    if [ -n "$SCREENSCRAPER_USER" ] && [ -n "$SCREENSCRAPAPER_PASS" ]; then
        SCRAPER_OPTS="$SCRAPER_OPTS -u $SCREENSCRAPER_USER:$SCREENSCRAPAPER_PASS"
    fi

    # Output
    SCRAPER_OPTS="$SCRAPER_OPTS -o ~/.config/es-de/gamelists"

    # Ejecutar skyscraper
    echo "  Ejecutando scraper..."
    if skyscraper $SCRAPER_OPTS 2>&1 | tee -a "$LOG_FILE"; then
        echo "  ✓ Sistema '$system' completado"
    else
        echo "  ⚠ Error en '$system', intentando con TheGamesDB..."

        # Fallback a TheGamesDB
        skyscraper -p "$system" -s tgdb -o ~/.config/es-de/gamelists 2>&1 | tee -a "$LOG_FILE" || {
            echo "  ✗ Falló también con TheGamesDB"
        }
    fi

    echo ""
}

# Procesar argumentos
if [ $# -eq 0 ]; then
    show_help
    echo ""
    echo "Ejecutando scraper de TODOS los sistemas..."
    for sys in "${SYSTEMS[@]}"; do
        scrape_system "$sys"
    done
else
    case "$1" in
        help|-h|--help)
            show_help
            exit 0
            ;;
        all)
            for sys in "${SYSTEMS[@]}"; do
                scrape_system "$sys"
            done
            ;;
        update)
            echo "Modo: Actualizar metadata de juegos existentes"
            for sys in "${SYSTEMS[@]}"; do
                scrape_system "$sys"
            done
            ;;
        force)
            echo "Modo: Forzar re-scrape completo"
            # Limpiar gamelists existentes
            rm -f "$GAMELISTS_DIR"/*/*.xml 2>/dev/null || true
            for sys in "${SYSTEMS[@]}"; do
                scrape_system "$sys"
            done
            ;;
        *)
            # Buscar sistema específico
            found=0
            for sys in "${SYSTEMS[@]}"; do
                if [ "${sys%%:*}" = "$1" ]; then
                    scrape_system "$sys"
                    found=1
                    break
                fi
            done
            if [ $found -eq 0 ]; then
                echo "ERROR: Sistema desconocido: $1"
                show_help
                exit 1
            fi
            ;;
    esac
fi

echo ""
echo "=============================================="
echo "SCRAPER COMPLETADO"
echo "=============================================="
echo ""
echo "Gamelists generadas en: $GAMELISTS_DIR"
echo "Log guardado en: $LOG_FILE"
echo ""
echo "Para ver los resultados, abre ES-DE."