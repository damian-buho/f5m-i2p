#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT

set -eou pipefail

# shellcheck source=/dev/null
. b19-i18n

# The eepsite is an I2P-only service whose tunnel reverse-proxies to a webserver, so nothing local answers on the target unless one is wired — CI and a bare run have none
if [ "${F5M_I2P_EEPSITE_ENABLED:-false}" != "true" ]; then
  b19-log warn "TEST.D" "$(_ "Eepsite disabled, skipping tunnel check")"
  exit 0
fi

TUNNELS_CONFIG="${B19_HOME}/i2ptunnel.config"
EEPSITE_TUNNEL="${TUNNELS_CONFIG}.d/03-I2P webserver-i2ptunnel.config"

if [ ! -f "${EEPSITE_TUNNEL}" ]; then
  b19-log warn "TEST.D" "$(_p "Eepsite tunnel not started yet, skipping (%s)" "${EEPSITE_TUNNEL}")"
  exit 0
fi

# A relative key path resolves against the router dir, so I2P mints a throwaway identity
key_file="$(sed -n 's/^privKeyFile=//p' "${EEPSITE_TUNNEL}")"
if [ "${key_file#/}" = "${key_file}" ]; then
  b19-log bad "TEST.D" "$(_p "Eepsite key file is not absolute: %s" "${key_file}")"
  exit 1
fi

b19-log good "TEST.D" "$(_p "Eepsite tunnel is configured with an absolute key path (%s)" "${key_file}")"
