#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT

# Sourced by the entrypoint harness (set -e): fall off the end, never exit.
  ensure_router_key() {
    if [ -f "$1" ] && ! grep --quiet -- "^$2=" "$1"
    then
      printf '%s=%s\n' "$2" "$3" >> "$1"
      SEEDED_ANY=true
    fi
  }
  PRESET_FILE="${B19_HOME}/presets/reseeds.txt"
  PRESET_URLS=""
  if [ "${F5M_I2P_RESEED_PRESET_ENABLED:-true}" = "true" ]
  then
    if [ -r "${PRESET_FILE}" ]
    then
      PRESET_URLS="$(sed -e 's/#.*//' "${PRESET_FILE}")"
    else
      b19-log warn "I2P" "$(_p "Preset file %s unreadable, using only F5M_I2P_RESEED_URLS" "${PRESET_FILE}")"
    fi
  fi
  # Preset first, operator URLs appended; each entry is a directory URL with trailing slash.
  MERGED_URLS="$(printf '%s\n%s' "${PRESET_URLS}" "${F5M_I2P_RESEED_URLS:-}" | tr ',' '\n' | tr -s '[:space:]' '\n' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | grep '^https\?://' | sed -e 's|\([^/]\)$|\1/|' | awk '!seen[$0]++')"
  if [ -n "${MERGED_URLS}" ]
  then
    RESEED_CSV="$(printf '%s' "${MERGED_URLS}" | paste --serial --delimiters ',')"
    SEEDED_ANY=false
    ensure_router_key "${B19_HOME}/router.config" "i2p.reseedURL" "${RESEED_CSV}"
    ensure_router_key "${B19_HOME}/.i2p/router.config" "i2p.reseedURL" "${RESEED_CSV}"
    if [ "${SEEDED_ANY}" = "true" ]
    then
      b19-log good "I2P" "$(_p "Seeded reseed URL list with %s servers" "$(printf '%s\n' "${MERGED_URLS}" | wc -l)")"
    else
      b19-log info "I2P" "$(_ "Keeping existing reseed URL list")"
    fi
  else
    b19-log info "I2P" "$(_ "No reseed URLs configured, the router will use its built-in list")"
  fi
  if [ "${F5M_I2P_RESEED_PROXY_ENABLED:-false}" = "true" ]
  then
    PROXY_TYPE="$(printf '%s' "${F5M_I2P_RESEED_PROXY_TYPE:-HTTP}" | tr '[:lower:]' '[:upper:]')"
    case "${PROXY_TYPE}" in
      HTTP|SOCKS4|SOCKS5|INTERNAL) ;;
      *) b19-log warn "I2P" "$(_p "Unknown reseed proxy type %s, falling back to HTTP" "${PROXY_TYPE}")"; PROXY_TYPE="HTTP" ;;
    esac
    PROXY_HOST=""
    PROXY_PORT=""
    PROXY_VALID=true
    if [ "${PROXY_TYPE}" = "INTERNAL" ]
    then
      # The I2P outproxy needs no host or port; the router derives localhost:4444 itself.
      b19-log info "I2P" "$(_ "Reseed proxy type INTERNAL ignores F5M_I2P_RESEED_PROXY")"
    else
      PROXY_HOST="${F5M_I2P_RESEED_PROXY%:*}"
      PROXY_PORT="${F5M_I2P_RESEED_PROXY##*:}"
      if [ -z "${F5M_I2P_RESEED_PROXY:-}" ] || [ "${PROXY_HOST}" = "${PROXY_PORT}" ]
      then
        b19-log warn "I2P" "$(_p "Reseed proxy enabled but F5M_I2P_RESEED_PROXY is not host:port: %s" "${F5M_I2P_RESEED_PROXY:-}")"
        PROXY_VALID=false
      fi
    fi
    if [ "${PROXY_VALID}" = "true" ]
    then
      SEEDED_ANY=false
      for _target in "${B19_HOME}/router.config" "${B19_HOME}/.i2p/router.config"
      do
        ensure_router_key "${_target}" "router.reseedSSLProxyEnable" "true"
        ensure_router_key "${_target}" "router.reseedSSLProxyType" "${PROXY_TYPE}"
        ensure_router_key "${_target}" "router.reseedSSLProxyHost" "${PROXY_HOST}"
        ensure_router_key "${_target}" "router.reseedSSLProxyPort" "${PROXY_PORT}"
      done
      if [ "${SEEDED_ANY}" = "true" ]
      then
        b19-log good "I2P" "$(_p "Seeded reseed proxy %s via %s:%s" "${PROXY_TYPE}" "${PROXY_HOST:-localhost}" "${PROXY_PORT:-4444}")"
      else
        b19-log info "I2P" "$(_ "Keeping existing reseed proxy settings")"
      fi
    fi
  fi
