#!/bin/bash
# =====================================================
# START_RETROBOX.SH - Launcher modo consola para RetroGamingBox
# Transforma Linux Mint en una consola de gaming
# =====================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RETROGAMING_DIR="/home/fabian/RetroGamingBox"
LOG_FILE="$RETROGAMING_DIR/logs/retrobox_start.log"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${BLUE}[RetroBox]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[RetroBox]${NC} ✓ $1"
}

log_warning() {
    echo -e "${YELLOW}[RetroBox]${NC} ⚠ $1"
}

log_error() {
    echo -e "${RED}[RetroBox]${NC} ✗ $1"
}

show_banner() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}     ${GREEN}RETROGAMING BOX - LINUX MINT${NC}        ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}     ${YELLOW}Tu consola de gaming portable${NC}        ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════╝${NC}"
    echo ""
}

show_menu() {
    echo "Selecciona una opción:"
    echo ""
    echo "  1.  Iniciar ES-DE (EmulationStation Desktop Edition)"
    echo "  2.  Iniciar RetroArch directamente"
    echo "  3.  Cambiar shader (CRT/LCD/Pixel)"
    echo "  4.  Cambiar theme"
    echo "  5.  Abrir terminal de gestión"
    echo "  6.  Ver información del sistema"
    echo "  7.  Salir al escritorio"
    echo ""
    echo -n "Opción: "
}

# =====================================================
# FUNCIONES DE OPTIMIZACIÓN
# =====================================================

optimize_system() {
    log "Optimizando sistema para gaming..."

    # Establecer governor de CPU a performance
    if [ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]; then
        if command -v pkexec &> /dev/null; then
            echo "2545" | sudo -S pkexec sh -c 'for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do echo performance > $cpu; done' 2>/dev/null || true
        fi
        log_success "CPU: Modo performance activado"
    fi

    # Deshabilitar compositor ( XFCE )
    if command -v xfwm4 &> /dev/null; then
        xfwm4 --compositor=off 2>/dev/null || true
        log_success "Compositor XFCE deshabilitado"
    fi

    # Deshabilitar efectos de escritorio
    xfconf-query -c xfwm4 -p /general/use_compositing -s false 2>/dev/null || true

    # Minimizar apps innecesarias (excepto las esenciales)
    for app in firefox chrome chromium evolution thunderbird; do
        pkill -x "$app" 2>/dev/null || true
    done
    log_success "Aplicaciones innecesarias cerradas"
}

restore_system() {
    log "Restaurando configuración del sistema..."

    # Restaurar governor de CPU
    if [ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]; then
        if command -v pkexec &> /dev/null; then
            echo "2545" | sudo -S pkexec sh -c 'for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do echo powersave > $cpu; done' 2>/dev/null || true
        fi
        log "CPU: Modo powersave restaurado"
    fi

    # Habilitar compositor
    if command -v xfwm4 &> /dev/null; then
        xfwm4 --compositor=on 2>/dev/null || true
    fi

    log_success "Sistema restaurado"
}

# =====================================================
# FUNCIONES DE INICIO
# =====================================================

start_esde() {
    log "Iniciando ES-DE (EmulationStation Desktop Edition)..."

    ES_DE_APPIMAGE="$RETROGAMING_DIR/es-de/ES-DE_x64.AppImage"

    if [ ! -f "$ES_DE_APPIMAGE" ]; then
        log_error "ES-DE AppImage no encontrado: $ES_DE_APPIMAGE"
        return 1
    fi

    chmod +x "$ES_DE_APPIMAGE" 2>/dev/null || true
    "$ES_DE_APPIMAGE" 2>> "$LOG_FILE"
}

start_retroarch() {
    log "Iniciando RetroArch..."

    # Verificar RetroArch
    if ! command -v retroarch &> /dev/null; then
        log_error "RetroArch no está instalado"
        return 1
    fi

    # Usar config portable
    export RETROARCH_CONFIG="$RETROGAMING_DIR/configs/retroarch/retroarch.cfg"

    if [ -f "$RETROARCH_CONFIG" ]; then
        retroarch -c "$RETROARCH_CONFIG" 2>> "$LOG_FILE"
    else
        retroarch 2>> "$LOG_FILE"
    fi
}

show_system_info() {
    echo ""
    echo "╔══════════════════════════════════════════╗"
    echo "║         INFORMACIÓN DEL SISTEMA          ║"
    echo "╠══════════════════════════════════════════╣"
    echo -n "║  OS: "
    uname -sr | tr '\n' ' '
    echo "                    ║"

    echo -n "║  CPU: "
    cat /proc/cpuinfo | grep "model name" | head -1 | cut -d: -f2 | xargs
    echo "   ║"

    echo -n "║  GPU: "
    lspci | grep -i vga | cut -d: -f3 | xargs
    echo "   ║"

    echo -n "║  RAM: "
    free -h | awk '/^Mem:/ {print $2}'
    echo "                          ║"

    echo -n "║  Cores RetroArch: "
    ls "$RETROGAMING_DIR/cores"/*.so 2>/dev/null | wc -l
    echo "                         ║"

    echo -n "║  ES-DE: "
    if command -v emulationstation &> /dev/null; then
        echo -n "Instalado"
    else
        echo -n "No instalado"
    fi
    echo "                    ║"

    echo "╚══════════════════════════════════════════╝"
    echo ""
}

# =====================================================
# PROGRAMA PRINCIPAL
# =====================================================

# Crear directorio de logs
mkdir -p "$RETROGAMING_DIR/logs"

# Parsear argumentos de línea de comandos
if [ $# -gt 0 ]; then
    case "$1" in
        --esde|-e)
            optimize_system
            start_esde
            restore_system
            exit 0
            ;;
        --retroarch|-r)
            optimize_system
            start_retroarch
            restore_system
            exit 0
            ;;
        --help|-h)
            echo "Uso: $0 [opción]"
            echo ""
            echo "Opciones:"
            echo "  --esde, -e      Iniciar ES-DE directamente"
            echo "  --retroarch, -r Iniciar RetroArch directamente"
            echo "  --help, -h      Mostrar esta ayuda"
            exit 0
            ;;
    esac
fi

# Modo interactivo
show_banner

while true; do
    show_menu
    read -r choice

    case "$choice" in
        1)
            optimize_system
            start_esde
            restore_system
            ;;
        2)
            optimize_system
            start_retroarch
            restore_system
            ;;
        3)
            echo ""
            echo "Selecciona shader:"
            echo "  1. CRT (para TV)"
            echo "  2. LCD (para pantallas modernas)"
            echo "  3. Pixel-perfect (escala entera)"
            echo "  4. Desactivar shaders"
            read -r shader_choice
            case "$shader_choice" in
                1) ./scripts/switch_shader.sh crt ;;
                2) ./scripts/switch_shader.sh lcd ;;
                3) ./scripts/switch_shader.sh pixel ;;
                4) ./scripts/switch_shader.sh off ;;
            esac
            ;;
        4)
            ./scripts/switch_theme.sh
            ;;
        5)
            echo "Abriendo terminal..."
            xterm &
            ;;
        6)
            show_system_info
            ;;
        7)
            log "Saliendo al escritorio..."
            exit 0
            ;;
        *)
            log_error "Opción inválida: $choice"
            ;;
    esac

    echo ""
done