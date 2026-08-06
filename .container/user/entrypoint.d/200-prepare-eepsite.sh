#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT

  EEPSITE_DIR="${XDG_DATA_HOME}/eepsite"

  if [ ! -d "${EEPSITE_DIR}" ]
  then
    b19-log info "I2P" "$(_ "Creating eepsite directory")"
    mkdir -p "${EEPSITE_DIR}"
  fi

  if [ ! -f "${EEPSITE_DIR}/eepPriv.dat" ]
  then
    EEPSITE_SECRET="/run/secrets/f5m.i2p.persona-eepsite-key"
    if [ -f "${EEPSITE_SECRET}" ]
    then
      b19-log info "I2P" "$(_p "Loading eepsite identity from secret %s" "${EEPSITE_SECRET}")"
      cp "${EEPSITE_SECRET}" "${EEPSITE_DIR}/eepPriv.dat"
      chmod 0600 "${EEPSITE_DIR}/eepPriv.dat"
    else
      b19-log info "I2P" "$(_p "No eepsite identity at %s, I2P will generate on first tunnel start" "${EEPSITE_DIR}/eepPriv.dat")"
    fi
  fi

  if [ -f "${EEPSITE_DIR}/eepPriv.dat" ]
  then
    b19-log good "I2P" "$(_p "Existing eepsite identity found at %s" "${EEPSITE_DIR}/eepPriv.dat")"

    B32_ADDR=$(extract-b32-address "${EEPSITE_DIR}/eepPriv.dat" 2>/dev/null || true)
    if [ -n "${B32_ADDR}" ]
    then
      b19-log good "I2P" "$(_p "Eepsite destination: %s" "${B32_ADDR}")"
    else
      b19-log info "I2P" "$(_ "Eepsite .b32.i2p address will be available after tunnel startup")"
    fi
  fi
