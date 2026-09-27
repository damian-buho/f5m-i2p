#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT

set -eou pipefail

# shellcheck source=/dev/null
. b19-i18n

# Every console graph is drawn with Java2D, so a fontless image answers 500 on viewstat.jsp while the rest of the console stays healthy
I2P_CONSOLE_PORT="${F5M_I2P_CONSOLE_PORT:-7657}"
GRAPH_URL="http://localhost:${I2P_CONSOLE_PORT}/viewstat.jsp?stat=bw.combined&showEvents=false&period=60000&periodCount=180&end=0&width=1200&height=300&hideLegend=false"

content_type="$(curl --silent --output /dev/null --write-out '%{content_type}' --max-time 15 "${GRAPH_URL}")"

if [ "${content_type%%/*}" != "image" ]; then
  b19-log bad "TEST.D" "$(_p "Console graph is not an image (content type: %s)" "${content_type}")"
  exit 1
fi

b19-log good "TEST.D" "$(_p "Console graph renders (%s)" "${content_type}")"
