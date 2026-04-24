#!/usr/bin/env bash
# bundle-audio.sh — fetch public-domain U.S. Army Band recordings and inline them
# into index.html so the app ships with audio ready to play.
#
# Run on a machine with network access, then distribute the resulting index.html.
#
# Recordings are public domain under 17 U.S.C. § 105 (works of U.S. government
# employees in the course of duty). Source: U.S. Army Bands Online via the
# Internet Archive.
#
# Usage:
#   ./bundle-audio.sh                 # use default URLs
#   ./bundle-audio.sh song.mp3 creed.mp3   # use local files instead

set -euo pipefail

cd "$(dirname "$0")"

# Default download URLs — Internet Archive direct MP3 links.
# If these break, browse https://archive.org/details/TheArmyGoesRollingAlong and
# https://archive.org/details/TheSoldiersCreed for current download URLs and pass
# them as args, or download manually and pass file paths.
SONG_URL="https://archive.org/download/TheArmyGoesRollingAlong/TheArmyGoesRollingAlong.mp3"
CREED_URL="https://archive.org/download/TheSoldiersCreed/TheSoldiersCreed.mp3"

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

if [[ $# -eq 2 && -f "$1" && -f "$2" ]]; then
  SONG_MP3="$1"
  CREED_MP3="$2"
  echo "Using local files: $SONG_MP3, $CREED_MP3"
else
  SONG_MP3="$TMPDIR/song.mp3"
  CREED_MP3="$TMPDIR/creed.mp3"
  echo "Downloading Army Song from Internet Archive…"
  curl -fL --retry 3 -o "$SONG_MP3" "$SONG_URL" || {
    echo "Failed to fetch Army Song. Download manually from"
    echo "  https://archive.org/details/TheArmyGoesRollingAlong"
    echo "and run: ./bundle-audio.sh path/to/song.mp3 path/to/creed.mp3"
    exit 1
  }
  echo "Downloading Soldier's Creed from Internet Archive…"
  curl -fL --retry 3 -o "$CREED_MP3" "$CREED_URL" || {
    echo "Failed to fetch Soldier's Creed. Continuing without it."
    CREED_MP3=""
  }
fi

echo "Encoding…"
SONG_B64=$(base64 -w0 "$SONG_MP3" 2>/dev/null || base64 "$SONG_MP3" | tr -d '\n')
CREED_B64=""
if [[ -n "$CREED_MP3" && -f "$CREED_MP3" ]]; then
  CREED_B64=$(base64 -w0 "$CREED_MP3" 2>/dev/null || base64 "$CREED_MP3" | tr -d '\n')
fi

# Inject into index.html using Python (sed chokes on multi-MB strings)
python3 - <<PY
import re, sys
path = "index.html"
src = open(path).read()
song_b64 = """${SONG_B64}"""
creed_b64 = """${CREED_B64}"""
def inject(src, tag_id, b64):
    pat = re.compile(r'(<script id="audio-' + tag_id + r'" type="text/plain">)[^<]*?(</script>)', re.S)
    if not pat.search(src):
        print(f"WARN: tag audio-{tag_id} not found", file=sys.stderr)
        return src
    return pat.sub(lambda m: m.group(1) + b64 + m.group(2), src)
src = inject(src, 'song', song_b64)
if creed_b64:
    src = inject(src, 'creed', creed_b64)
open(path, 'w').write(src)
size = len(src)
print(f"index.html now {size:,} bytes ({size/1024/1024:.1f} MB)")
PY

echo "Done. Verify size: $(du -h index.html | cut -f1)"
