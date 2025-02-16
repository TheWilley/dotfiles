#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    # Determine bar name based on primary status
    if xrandr --query | grep "^$m connected primary"; then
      bar_name="top-primary"
    else
      bar_name="top-secondary"
    fi

    MONITOR="$m" polybar --reload "$bar_name" &
  done
else
  polybar --reload top-primary &
fi

echo "Bars launched..."
