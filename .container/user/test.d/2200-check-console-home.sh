#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT

set -eou pipefail

# shellcheck source=/dev/null
. b19-i18n

# The setup wizard is suppressed by a flag in router.config, and an unseeded router dir sends the console root to /welcome
I2P_CONSOLE_PORT="${F5M_I2P_CONSOLE_PORT:-7657}"
console_url="http://localhost:${I2P_CONSOLE_PORT}/"
redirect="$(curl --silent --output /dev/null --write-out '%{redirect_url}' --max-time 15 "${console_url}")"

if [ "${redirect}" = "${console_url}welcome" ]; then
  b19-log bad "TEST.D" "$(_p "Console root opened the setup wizard (%s)" "${redirect}")"
  exit 1
fi

b19-log good "TEST.D" "$(_p "Console root lands on %s" "${redirect}")"
