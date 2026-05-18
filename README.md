# RetroGamingBox

A portable, self-contained retro gaming system based on RetroArch with Ozone frontend (Batocera-like experience) that runs on Linux Mint/Ubuntu.

## Features

- RetroArch core emulator system
- Ozone modern grid frontend (resembles Batocera/EmulationStation)
- Keyboard-optimized controls (works with wireless keyboard)
- Performance-optimized for Intel Iris Xe graphics
- Automatic save state management
- Portable directory structure
- Ready for GitHub open-source distribution

## Directory Structure

```
RetroGamingBox/
├── bios/               # System BIOS/firmware files
├── configs/
│   ├── emulationstation/ # (Optional) EmulationStation configs
│   └── retroarch/        # RetroArch configuration
├── cores/              # Libretro cores (optional, uses system by default)
├── media/              # Screenshots, boxart, etc.
│   └── screenshots/
├── roms/               # Your game ROMs, organized by system
│   ├── nes/
│   ├── snes/
│   ├── genesis/
│   ├── gb/
│   ├── gbc/
│   ├── gba/
│   ├── ps1/
│   ├── n64/
│   ├── psp/
│   └── dreamcast/
├── saves/              # Save files and states
├── shaders/            # Video shaders (optional)
├── launch.sh           # Launch script
└── README.md
```

## Quick Start

1. **Install dependencies** (run once):
   ```bash
   sudo apt update
   sudo apt install -y retroarch libretro-* vulkan-tools unclutter
   ```

2. **Add your ROMs** to the appropriate system folders:
   ```
   ~/RetroGamingBox/roms/snes/Super\ Mario\ World.sfc
   ~/RetroGamingBox/roms/genesis/Sonic\ The\ Hedgehog.md
   ```

3. **(Optional) Download BIOS files** if required by certain systems (PS1, N64, etc.) and place them in `bios/`

4. **Launch the system**:
   ```bash
   cd ~/RetroGamingBox
   ./launch.sh
   ```

5. **Controls** (keyboard):
   - A: `X`
   - B: `Z`
   - Y: `A`
   - X: `S`
   - L: `Q`
   - R: `W`
   - Start: `Enter`
   - Select: `Right Shift`
   - D-Pad: Arrow keys
   - Exit RetroArch: Press `Select + Start` (Right Shift + Enter)

## Optional: EmulationStation Frontend

If you prefer EmulationStation over RetroArch's Ozone menu:

1. Install EmulationStation via RetroPie script or compile from source (see notes below)
2. Replace the launch.sh content with:
   ```bash
   #!/bin/bash
   cd "$(dirname "$0")"
   export HOME="$PWD"
   exec emulationstation --no-splash
   ```
3. Configure EmulationStation to use your ROMs directory

## Performance Optimizations

- Video driver: OpenGL (best for Intel Iris Xe)
- Integer scaling enabled (crisp pixel perfect)
- Threaded video/audio/input for better multi-core usage
- Governor management script available (see scripts/ folder)

## Legal Notice

This system is for playing games you legally own. Downloading ROMs for games you do not own is illegal in many jurisdictions. Please respect copyright laws.

## Credits

- RetroArch team for the amazing emulator core
- Libretro developers for all the cores
- Ozone menu developers for the modern frontend
- Inspired by Batocera, Lakka, and RetroPie

## License

MIT License - see LICENSE file