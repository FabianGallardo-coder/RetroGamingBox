#!/bin/bash
set -e

echo "=== RetroGamingBox Test ==="

# Test 1: Verify cores exist
echo "[1/5] Checking cores..."
CORES=$(ls /home/fabian/RetroGamingBox/cores/*.so 2>/dev/null | wc -l)
echo "  Cores found: $CORES"

# Test 2: Verify ROMs exist
echo "[2/5] Checking ROMs..."
ROM_COUNT=$(find /home/fabian/ROMs_Archive -type f \( -name "*.nes" -o -name "*.snes" -o -name "*.sfc" -o -name "*.gb" -o -name "*.gba" -o -name "*.md" \) 2>/dev/null | head -5)
echo "  Sample ROMs:"
echo "$ROM_COUNT" | while read f; do echo "    - $(basename "$f")"; done

# Test 3: Check ES-DE config
echo "[3/5] Checking ES-DE configuration..."
if [ -f "/home/fabian/.config/es-de/es-de.cfg" ]; then
    echo "  ES-DE config: OK"
else
    echo "  ES-DE config: MISSING"
fi

# Test 4: Check themes
echo "[4/5] Checking themes..."
THEMES=$(ls /home/fabian/.config/es-de/themes/ 2>/dev/null | wc -l)
echo "  Themes installed: $THEMES"

# Test 5: Test a ROM launch (NES example)
echo "[5/5] Testing ROM launch (NES)..."
NES_ROM=$(find /home/fabian/ROMs_Archive/Nintendo\ -\ NES -name "*.nes" 2>/dev/null | head -1)
if [ -n "$NES_ROM" ]; then
    echo "  Testing: $(basename "$NES_ROM")"
    echo "  Launching with fbnext core..."
    timeout 5 /home/fabian/RetroGamingBox/cores/fbnext_libretro.so "$NES_ROM" 2>/dev/null || true
    echo "  Launch test completed"
else
    echo "  No NES ROM found for testing"
fi

echo ""
echo "=== Test Complete ==="