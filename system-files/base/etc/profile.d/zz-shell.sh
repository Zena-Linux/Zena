#!/bin/sh

CONFIG="$HOME/.config/shell"
PREFERRED_SHELL=""

case "$-" in *i*) ;; *) return 0 ;; esac

[ -n "$SKIP_PREFERRED_SHELL" ] && return 0

if [ -r "$CONFIG" ]; then
  PREFERRED_SHELL="$(head -n 1 "$CONFIG" | tr -d '\r')"
fi

if [ -z "$PREFERRED_SHELL" ] || [ ! -x "$PREFERRED_SHELL" ] || [ "$(basename "$PREFERRED_SHELL")" = "bash" ]; then
  return 0
fi

case "$(basename "$PREFERRED_SHELL")" in
  fish) LOGIN_OP="--login" ;;
  zsh|ksh|mksh|dash|sh|ash|busybox) LOGIN_OP="-l" ;;
  *)    LOGIN_OP="" ;;
esac

if [ -n "$LOGIN_OP" ]; then
    exec "$PREFERRED_SHELL" "$LOGIN_OP"
else
    exec "$PREFERRED_SHELL"
fi
