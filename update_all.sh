#!/usr/bin/env bash
set -euo pipefail

EXCEL="${1:-feeds.xlsx}"           # puoi passare un excel diverso come 1° argomento
OUTDIR="output_feeds"
PYTHON="${PYTHON:-python3}"        # usa un venv impostando PYTHON, es: PYTHON=.venv/bin/python
SCRIPT="batch_make_feeds.py"
BRANCH="main"
REMOTE="origin"

echo ">>> Genero feed da '$EXCEL'..."
$PYTHON "$SCRIPT" --excel "$EXCEL" --out "$OUTDIR"

echo ">>> Pubblico su GitHub (solo se ci sono modifiche)..."
git add "$OUTDIR"/*.xml "$OUTDIR/feeds.opml" 2>/dev/null || true
git commit -m "Auto-update feeds $(date '+%Y-%m-%d %H:%M:%S')" || echo "Niente da committare"
git push "$REMOTE" "$BRANCH" || true

echo
echo "✔ Pronto. OPML per Feeder:"
echo "  https://raw.githubusercontent.com/trank1955/my-feeds/refs/heads/$BRANCH/$OUTDIR/feeds.opml"
echo
echo "Suggerimento: per un Excel diverso, usa:  ./update_all.sh TUO.xlsx"
