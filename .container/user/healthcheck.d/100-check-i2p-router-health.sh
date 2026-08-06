#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT

set -o pipefail
# shellcheck source=../tools.d/b19-i18n

# Check if I2P router is healthy via the console (always enabled)
I2P_CONSOLE_PORT="${F5M_I2P_CONSOLE_PORT:-7657}"

if ! curl -I -s "http://localhost:${I2P_CONSOLE_PORT}/" >/dev/null 2>&1; then
  b19-log bad "HEALTH.D" "$(_p "I2P console not responding (port: %s)" "${I2P_CONSOLE_PORT}")"
  exit 1
fi

b19-log good "HEALTH.D" "$(_p "I2P router is healthy (port: %s)" "${I2P_CONSOLE_PORT}")"
exit 0
