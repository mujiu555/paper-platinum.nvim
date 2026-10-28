#!/usr/bin/env bash
# Optional real Kitty rendering under a private X server; no user Kitty config.
set -euo pipefail
style=${1:-light}
case "$style" in light|dark) ;; *) exit 2;; esac
scene=${PAPER_SCENE:-preview}
case "$scene" in preview) suffix=''; font=13;; gallery) suffix='-gallery'; font=11;; *) exit 2;; esac
mkdir -p doc/images
capture_dir=$(mktemp -d /tmp/paper-capture.XXXXXX)
Xvfb -displayfd 3 -screen 0 1440x960x24 -nolisten tcp 3>"$capture_dir/display" >"$capture_dir/xvfb.log" 2>&1 &
xvfb_pid=$!
kitty_pid=''
trap 'if [ -n "$kitty_pid" ]; then kill "$kitty_pid" 2>/dev/null || true; fi; kill "$xvfb_pid" 2>/dev/null || true' EXIT
for attempt in {1..30}; do [ -s "$capture_dir/display" ] && break; sleep 0.1; done
export DISPLAY=":"$(cat "$capture_dir/display")
export PAPER_STYLE="$style"
export NVIM_LOG_FILE="$capture_dir/nvim.log"
export XDG_STATE_HOME="$capture_dir/state"
GLFW_IM_MODULE=none kitty --config NONE -o linux_display_server=x11 -o remember_window_size=no -o initial_window_width=1440 -o initial_window_height=960 -o font_size="$font" -o background_opacity=1 -o enable_audio_bell=no nvim -u NONE -i NONE -c "luafile tests/$scene.lua" >"$capture_dir/kitty.log" 2>&1 &
kitty_pid=$!
sleep 3
kill -0 "$kitty_pid"
magick import -display "$DISPLAY" -window root "doc/images/$style$suffix.png"
printf 'Captured %s; logs: %s\n' "doc/images/$style$suffix.png" "$capture_dir"
