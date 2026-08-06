#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT

set -o pipefail
# shellcheck source=../tools.d/b19-i18n

# Check if I2P web console is accessible
# Tests the I2P router's web console interface
# Uses environment variables from the runtime

# I2P web console is typically on port 7657
I2P_CONSOLE_PORT="${F5M_I2P_CONSOLE_PORT:-7657}"

# Skip check if console port is not configured or is disabled
if [ "${I2P_CONSOLE_PORT}" = "disabled" ] || [ -z "${I2P_CONSOLE_PORT}" ]; then
  b19-log good "HEALTH.D" "$(_ "I2P console check skipped (F5M_I2P_CONSOLE_PORT not configured)")"
  exit 0
fi

# Test if I2P console is responding
if ! curl -I -s "http://localhost:${I2P_CONSOLE_PORT}/" >/dev/null 2>&1; then
  b19-log bad "HEALTH.D" "$(_p "I2P console not responding (F5M_I2P_CONSOLE_PORT: %s)" "${I2P_CONSOLE_PORT}")"
  exit 1
fi

b19-log good "HEALTH.D" "$(_p "I2P console is accessible (F5M_I2P_CONSOLE_PORT: %s)" "${I2P_CONSOLE_PORT}")"
exit 0
