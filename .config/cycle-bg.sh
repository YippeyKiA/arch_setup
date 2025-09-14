#!/usr/bin/env bash
# Cycle wallpaper video for ALL monitors in sync using mpvpaper user services.

set -euo pipefail

# === SETTINGS ===
VIDDIR="$HOME/Videos"
# Services and their matching monitors (same index = same monitor)
SERVICES=(mpvpaper-dp1.service mpvpaper-dp2.service mpvpaper-hdmi2.service)
MONITORS=(DP-1                DP-2                HDMI-A-2)

STATE_DIR="$HOME/.cache"
LIST_FILE="$STATE_DIR/bg_list.txt"
IDX_FILE="$STATE_DIR/bg_index"

mkdir -p "$STATE_DIR"

# Build the list of candidate videos (sorted for stable cycling)
mapfile -t FILES < <(find "$VIDDIR" -maxdepth 1 -type f \
  \( -iname '*.mp4' -o -iname '*.webm' -o -iname '*.mkv' \) \
  | sort -V)

if (( ${#FILES[@]} == 0 )); then
  notify-send "cycle-bg" "No videos found in $VIDDIR (mp4/webm/mkv)" 2>/dev/null || true
  exit 1
fi

# If the list changed since last time, reset the index
NEW_LIST_HASH="$(printf '%s\n' "${FILES[@]}" | sha1sum | awk '{print $1}')"
OLD_LIST_HASH="$(awk 'NR==1{print $0}' "$LIST_FILE" 2>/dev/null || true)"
if [[ "$NEW_LIST_HASH" != "$OLD_LIST_HASH" ]]; then
  printf '%s\n' "$NEW_LIST_HASH" > "$LIST_FILE"
  : > "$IDX_FILE"  # reset index
fi

# Read/advance index
idx=$(cat "$IDX_FILE" 2>/dev/null || echo 0)
if ! [[ "$idx" =~ ^[0-9]+$ ]]; then idx=0; fi
idx=$(( (idx + 1) % ${#FILES[@]} ))
echo "$idx" > "$IDX_FILE"

NEXT="${FILES[$idx]}"

# Write a drop-in override for each service to point at the same NEXT video
for i in "${!SERVICES[@]}"; do
  srv="${SERVICES[$i]}"
  mon="${MONITORS[$i]}"
  od="$HOME/.config/systemd/user/${srv}.d"
  mkdir -p "$od"
  cat >"$od/override.conf" <<EOF
[Service]
ExecStart=
ExecStart=/usr/bin/mpvpaper -o --loop --no-audio $mon "$NEXT"
EOF
done

# Apply and restart all services
systemctl --user daemon-reload
for s in "${SERVICES[@]}"; do
  systemctl --user reset-failed "$s" 2>/dev/null || true
  systemctl --user restart "$s"
done

# Optional on-screen hint (if you have notify-send)
notify-send "Wallpaper switched" "$(basename -- "$NEXT")" 2>/dev/null || true

