#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT

set -eou pipefail

# shellcheck source=/dev/null
. b19-i18n

SUBSCRIPTIONS_FILE="${B19_HOME}/.i2p/addressbook/subscriptions.txt"
if [ ! -s "${SUBSCRIPTIONS_FILE}" ]; then
  b19-log bad "TEST.D" "$(_p "Addressbook subscriptions missing or empty: %s" "${SUBSCRIPTIONS_FILE}")"
  exit 1
fi
# Every entry is an absolute URL to a hosts.txt file; parser strips # comments.
BAD_URLS="$(sed -e 's/#.*//' "${SUBSCRIPTIONS_FILE}" | tr -s '[:space:]' '\n' | grep -v '^$' | grep -v '^https\?://' || true)"
if [ -n "${BAD_URLS}" ]; then
  b19-log bad "TEST.D" "$(_p "Non-URL entries in %s: %s" "${SUBSCRIPTIONS_FILE}" "${BAD_URLS}")"
  exit 1
fi
if [ "${F5M_I2P_SUBSCRIPTIONS_PRESET_ENABLED:-true}" = "true" ]; then
  FIRST_URL="$(sed -e 's/#.*//' "${SUBSCRIPTIONS_FILE}" | tr -s '[:space:]' '\n' | grep -v '^$' | head -n 1)"
  if [ "${FIRST_URL}" != "http://i2p-projekt.i2p/hosts.txt" ]; then
    b19-log bad "TEST.D" "$(_p "Preset subscriptions must list the default source first, found: %s" "${FIRST_URL}")"
    exit 1
  fi
fi
b19-log good "TEST.D" "$(_p "Addressbook subscriptions are valid (%s)" "${SUBSCRIPTIONS_FILE}")"
