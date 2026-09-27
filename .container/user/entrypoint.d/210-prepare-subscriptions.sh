#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT

# Sourced by the entrypoint harness (set -e): fall off the end, never exit.
  I2P_DOT_DIR="${B19_HOME}/.i2p"
  SUBSCRIPTIONS_FILE="${I2P_DOT_DIR}/addressbook/subscriptions.txt"
  if [ -f "${SUBSCRIPTIONS_FILE}" ]
  then
    b19-log info "I2P" "$(_p "Keeping existing addressbook subscriptions at %s" "${SUBSCRIPTIONS_FILE}")"
  else
    PRESET_FILE="${B19_HOME}/presets/subscriptions.txt"
    PRESET_URLS=""
    if [ "${F5M_I2P_SUBSCRIPTIONS_PRESET_ENABLED:-true}" = "true" ]
    then
      if [ -r "${PRESET_FILE}" ]
      then
        PRESET_URLS="$(sed -e 's/#.*//' "${PRESET_FILE}")"
      else
        b19-log warn "I2P" "$(_p "Preset file %s unreadable, using only F5M_I2P_SUBSCRIPTIONS_URLS" "${PRESET_FILE}")"
      fi
    fi
    # Preset first (trust order), operator URLs appended, duplicates dropped.
    MERGED_URLS="$(printf '%s\n%s' "${PRESET_URLS}" "${F5M_I2P_SUBSCRIPTIONS_URLS:-}" | tr ',' '\n' | tr -s '[:space:]' '\n' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | grep -v '^$' | awk '!seen[$0]++')"
    if [ -z "${MERGED_URLS}" ]
    then
      b19-log info "I2P" "$(_ "No addressbook subscriptions configured, the router will use its own default")"
    else
      mkdir -p "${I2P_DOT_DIR}/addressbook"
      printf '# Seeded from the preset file plus F5M_I2P_SUBSCRIPTIONS_URLS; edits survive restarts.\n%s\n' "${MERGED_URLS}" > "${SUBSCRIPTIONS_FILE}"
      chmod 0600 "${SUBSCRIPTIONS_FILE}"
      b19-log good "I2P" "$(_p "Seeded %s subscriptions into %s" "$(printf '%s\n' "${MERGED_URLS}" | wc -l)" "${SUBSCRIPTIONS_FILE}")"
    fi
  fi
