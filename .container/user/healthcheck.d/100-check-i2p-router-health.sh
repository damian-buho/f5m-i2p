#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT

set -o pipefail
# shellcheck source=../tools.d/b19-i18n

# Router console is the only externally-observable liveness signal we expose:
# the router has no RPC, no health endpoint, no log file a one-liner can parse.
# Default port 7657 matches the baked-in F5M_I2P_CONSOLE_PORT; the orchestrator
# already sources b19-i18n before running us, so _ and b19-log are in scope.
I2P_CONSOLE_PORT="${F5M_I2P_CONSOLE_PORT:-7657}"

if [ "${I2P_CONSOLE_PORT}" = "disabled" ] || [ -z "${I2P_CONSOLE_PORT}" ]; then
  b19-log good "HEALTH.D" "$(_p "I2P console check skipped (port: %s)" "${I2P_CONSOLE_PORT}")"
  exit 0
fi

if ! curl --silent --fail --output /dev/null --max-time 5 --head "http://localhost:${I2P_CONSOLE_PORT}/" >/dev/null 2>&1; then
  b19-log bad "HEALTH.D" "$(_p "I2P console not responding (port: %s)" "${I2P_CONSOLE_PORT}")"
  exit 1
fi

b19-log good "HEALTH.D" "$(_p "I2P router is healthy (port: %s)" "${I2P_CONSOLE_PORT}")"
exit 0
