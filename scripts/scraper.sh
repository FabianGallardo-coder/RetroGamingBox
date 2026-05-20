#!/bin/bash
set -e

echo "=== ES-DE ROM Scraper ==="
echo "Scraping ROMs for metadata (game info, box art, screenshots)..."
echo ""

# ES-DE uses screenscraper.fr by default
# This script configures scraping settings

ES_DE_CONFIG="/home/fabian/.config/es-de/es-de.cfg"

# Update ES-DE config with scraping settings
if grep -q "ScraperSortOrder" "$ES_DE_CONFIG"; then
    sed -i 's/ScraperSortOrder=.*/ScraperSortOrder=rating/' "$ES_DE_CONFIG"
else
    echo "ScraperSortOrder=rating" >> "$ES_DE_CONFIG"
fi

echo "Scraping configuration updated."
echo ""
echo "To scrape ROMs:"
echo "  1. Open ES-DE"
echo "  2. Go to Settings > Scrape"
echo "  3. Select 'Scrape Now'"
echo "  4. Choose systems to scrape"
echo ""
echo "Automatic scraping can be triggered via ES-DE interface."