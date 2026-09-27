#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT

set -eou pipefail

# shellcheck source=/dev/null
. b19-i18n

ROUTER_CONFIG="${B19_HOME}/.i2p/router.config"
RESEED_LINE="$(sed -n 's/^i2p\.reseedURL=//p' "${ROUTER_CONFIG}" | head -n 1)"
if [ -z "${RESEED_LINE}" ]; then
  b19-log bad "TEST.D" "$(_p "No i2p.reseedURL in %s" "${ROUTER_CONFIG}")"
  exit 1
fi
# The reseeder only fetches directory URLs, so every entry must end with a slash.
BAD_RESEEDS="$(printf '%s' "${RESEED_LINE}" | tr ',' '\n' | grep -v '/$' || true)"
if [ -n "${BAD_RESEEDS}" ]; then
  b19-log bad "TEST.D" "$(_p "Reseed URLs without trailing slash: %s" "${BAD_RESEEDS}")"
  exit 1
fi
if [ "${F5M_I2P_RESEED_PROXY_ENABLED:-false}" != "true" ]; then
  b19-log good "TEST.D" "$(_p "Reseed URL list is valid with %s servers" "$(printf '%s' "${RESEED_LINE}" | tr ',' '\n' | wc -l)")"
  exit 0
fi
EXPECTED_TYPE="$(printf '%s' "${F5M_I2P_RESEED_PROXY_TYPE:-HTTP}" | tr '[:lower:]' '[:upper:]')"
case "${EXPECTED_TYPE}" in
  HTTP|SOCKS4|SOCKS5|INTERNAL) ;;
  *) EXPECTED_TYPE="HTTP" ;;
esac
ACTUAL_TYPE="$(sed -n 's/^router\.reseedSSLProxyType=//p' "${ROUTER_CONFIG}" | head -n 1)"
if [ "${ACTUAL_TYPE}" != "${EXPECTED_TYPE}" ]; then
  b19-log bad "TEST.D" "$(_p "Reseed proxy type is %s, expected %s" "${ACTUAL_TYPE}" "${EXPECTED_TYPE}")"
  exit 1
fi
if [ "$(sed -n 's/^router\.reseedSSLProxyEnable=//p' "${ROUTER_CONFIG}" | head -n 1)" != "true" ]; then
  b19-log bad "TEST.D" "$(_ "Reseed proxy enabled but router.reseedSSLProxyEnable is not true")"
  exit 1
fi
b19-log good "TEST.D" "$(_p "Reseed proxy is configured as %s" "${ACTUAL_TYPE}")"
