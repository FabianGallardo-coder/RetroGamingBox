# =====================================================
# ES-DE THEMES PARA RETROGAMINGBOX
# =====================================================
# Theme: Steam Deck Style (Default)
# Estilo: Oscuro, minimalista, moderno
# =====================================================

# Estructura del theme
THEME_STRUCTURE='
/home/fabian/RetroGamingBox/themes/steamdeck/
├── theme.xml
├── graphicalsets/
│   └── simple/
│       └── simple.svg
├── layouts/
│   ├── system.xslt
│   ├── gamelist.xslt
│   └── menu.xslt
└── colors/
    └── colors.xml
'

# Crear estructura del theme
mkdir -p "/home/fabian/RetroGamingBox/themes/steamdeck"/{graphicalsets/simple,layouts,colors}

# theme.xml principal - Theme estilo Steam Deck
cat > "/home/fabian/RetroGamingBox/themes/steamdeck/theme.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<theme>
    <format_version>4</format_version>
    <include>./colors/colors.xml</include>

    <!-- View Definitions -->
    <view name="system">
        <header>
            <text name="systemName">{system.name}</text>
        </header>
        <grid name="gamegrid">
            <itemSize>0.20 0.25</itemSize>
            <padding>0.02</padding>
        </grid>
    </view>

    <view name="menu">
        <menuBackground />
        <menuItem name="item">
            <selector>●</selector>
            <text>{menu.name}</text>
        </menuItem>
    </view>

    <!-- Colores del theme Steam Deck -->
    <variables>
        <menuBackground>#1a1a2e</menuBackground>
        <menuText>#ffffff</menuText>
        <primaryColor>#4a9eff</primaryColor>
        <secondaryColor>#7b68ee</secondaryColor>
        <selectedColor>#00d9ff</selectedColor>
    </variables>
</theme>
EOF

# Colors - Colores oscuros estilo Steam Deck
cat > "/home/fabian/RetroGamingBox/themes/steamdeck/colors/colors.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<theme>
    <color name="menuBackground">#1a1a2e</color>
    <color name="menuText">#ffffff</color>
    <color name="primary">#4a9eff</color>
    <color name="secondary">#7b68ee</color>
    <color name="selected">#00d9ff</color>
    <color name="background">#0f0f1a</color>
    <color name="gameBackground">#16213e</color>
    <color name="border">#2a2a4e</color>
</theme>
EOF

# Layout básico del sistema
cat > "/home/fabian/RetroGamingBox/themes/steamdeck/layouts/system.xslt" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes"/>

    <xsl:template match="/">
        <html>
            <head>
                <style>
                    body {
                        font-family: 'Segoe UI', sans-serif;
                        background: #1a1a2e;
                        color: #ffffff;
                        margin: 0;
                        padding: 20px;
                    }
                    .system-header {
                        font-size: 2em;
                        color: #4a9eff;
                        margin-bottom: 20px;
                    }
                    .game-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                        gap: 20px;
                    }
                    .game-card {
                        background: #16213e;
                        border-radius: 10px;
                        padding: 10px;
                        transition: transform 0.2s;
                    }
                    .game-card:hover {
                        transform: scale(1.05);
                        box-shadow: 0 0 20px rgba(0, 217, 255, 0.3);
                    }
                    .game-name {
                        text-align: center;
                        margin-top: 10px;
                        font-size: 0.9em;
                    }
                </style>
            </head>
            <body>
                <div class="system-header">
                    <xsl:value-of select="systemList/system/name"/>
                </div>
                <div class="game-grid">
                    <xsl:for-each select="systemList/system/gameList/game">
                        <div class="game-card">
                            <div class="game-name"><xsl:value-of select="name"/></div>
                        </div>
                    </xsl:for-each>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
EOF

echo "✓ Theme Steam Deck instalado"