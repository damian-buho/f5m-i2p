#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT

  EEPSITE_DIR="${XDG_DATA_HOME}/eepsite"
  EEPSITE_DROPIN_DIR="${B19_HOME}/.i2p/i2ptunnel.config.d"
  # The manifest is how 250-apply-env-config.sh knows which drop-ins are ours, and how a site removed from mirrors.d loses its tunnel
  EEPSITE_MANIFEST="${B19_HOME}/.i2p/eepsites.list"

  EEPSITE_RENDERED=()
  if [ -f "${EEPSITE_MANIFEST}" ]
  then
    mapfile -t EEPSITE_RENDERED < "${EEPSITE_MANIFEST}"
  fi
  : > "${EEPSITE_MANIFEST}"

  # The env-driven eepsite used to be tunnel.3 of the rendered config, projected into the drop-in dir under this name
  EEPSITE_LEGACY_DROPIN="${EEPSITE_DROPIN_DIR}/03-I2P webserver-i2ptunnel.config"
  if [ -f "${EEPSITE_LEGACY_DROPIN}" ]
  then
    rm -f "${EEPSITE_LEGACY_DROPIN}"
    b19-log info "I2P" "$(_p "Removed the env-driven eepsite drop-in, eepsites are declared by site now: %s" "${EEPSITE_LEGACY_DROPIN}")"
  fi

  if [ "${F5M_I2P_EEPSITE_ENABLED}" != "true" ]
  then
    for stale in "${EEPSITE_RENDERED[@]}"
    do
      rm -f "${EEPSITE_DROPIN_DIR}/${stale}"
    done
    b19-log info "I2P" "$(_ "Eepsites disabled, dropped their tunnels")"
    return
  fi

  if [ ! -d "${EEPSITE_DIR}" ]
  then
    b19-log info "I2P" "$(_ "Creating eepsite directory")"
    mkdir -p "${EEPSITE_DIR}"
  fi

  # One entry per eepsite: name|target|key file
  EEPSITE_SITES=()

  # A mirrors.d file is data, not shell: read it, never source it.
  for MIRROR_FILE in "${F5M_I2P_MIRRORS_DIR:-}"/*.conf
  do
    [ -f "${MIRROR_FILE}" ] || continue
    MIRROR_NAME="$(basename "${MIRROR_FILE}" .conf)"
    if [[ ! "${MIRROR_NAME}" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]]
    then
      b19-log warn "I2P" "$(_p "Skipping mirror file with an unusable site name: %s" "${MIRROR_FILE}")"
      continue
    fi
    MIRROR_TARGET=""
    MIRROR_LINES=()
    if [ -r "${MIRROR_FILE}" ]
    then
      mapfile -t MIRROR_LINES < "${MIRROR_FILE}"
    fi
    for MIRROR_LINE in "${MIRROR_LINES[@]}"
    do
      case "${MIRROR_LINE}" in
        ""|\#*) continue ;;
        target=*) MIRROR_TARGET="${MIRROR_LINE#target=}" ;;
        *)
          b19-log warn "I2P" "$(_p "Skipping malformed mirror file, unknown key in %s: %s" "${MIRROR_FILE}" "${MIRROR_LINE}")"
          continue 2
          ;;
      esac
    done
    MIRROR_TARGET="${MIRROR_TARGET:-${F5M_I2P_MIRROR_TARGET}}"
    if [[ ! "${MIRROR_TARGET}" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*:[0-9]{1,5}$ ]]
    then
      b19-log warn "I2P" "$(_p "Skipping mirror file without a host:port target: %s" "${MIRROR_FILE}")"
      continue
    fi
    EEPSITE_SITES+=("${MIRROR_NAME}|${MIRROR_TARGET}|${EEPSITE_DIR}/${MIRROR_NAME}.dat")
  done

  # No mirrors.d file: the env var alone still publishes one eepsite, keyed by F5M_I2P_EEPSITE_KEY_FILE
  if [ "${#EEPSITE_SITES[@]}" -eq 0 ]
  then
    if [[ ! "${F5M_I2P_EEPSITE_TARGET}" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*:[0-9]{1,5}$ ]]
    then
      b19-log warn "I2P" "$(_p "No eepsite target: set F5M_I2P_EEPSITE_TARGET or mount a mirrors.d site")"
      return
    fi
    EEPSITE_SITES+=("site|${F5M_I2P_EEPSITE_TARGET}|${F5M_I2P_EEPSITE_KEY_FILE}")
  fi

  mkdir -p "${EEPSITE_DROPIN_DIR}"

  for site_def in "${EEPSITE_SITES[@]}"
  do
    IFS="|" read -r SITE_NAME SITE_TARGET SITE_KEY <<< "${site_def}"

    if [ ! -f "${SITE_KEY}" ]
    then
      SITE_SECRET="/run/secrets/f5m.i2p.${SITE_NAME}-eepsite-key"
      if [ -f "${SITE_SECRET}" ]
      then
        b19-log info "I2P" "$(_p "Loading eepsite identity for %s from secret %s" "${SITE_NAME}" "${SITE_SECRET}")"
        cp "${SITE_SECRET}" "${SITE_KEY}"
        chmod 0600 "${SITE_KEY}"
      else
        b19-log info "I2P" "$(_p "No eepsite identity for %s, I2P will generate one on first tunnel start" "${SITE_NAME}")"
      fi
    fi

    IFS=":" read -r SITE_HOST SITE_PORT <<< "${SITE_TARGET}"

    printf '%s.config\n' "${SITE_NAME}" >> "${EEPSITE_MANIFEST}"
    cat > "${EEPSITE_DROPIN_DIR}/${SITE_NAME}.config" <<EOF
# Rendered from the ${SITE_NAME} eepsite declaration — edit the site, not this file
name=${SITE_NAME}
description=Eepsite ${SITE_NAME}
type=httpserver
targetHost=${SITE_HOST}
targetPort=${SITE_PORT}
spoofedHost=${F5M_I2P_EEPSITE_SPOOFED_HOST}
privKeyFile=${SITE_KEY}
i2cpHost=${F5M_I2P_I2CP_BIND}
i2cpPort=7654
option.inbound.nickname=${SITE_NAME}
option.outbound.nickname=${SITE_NAME}
option.i2cp.destination.sigType=7
option.i2cp.leaseSetEncType=6,4
option.inbound.length=${F5M_I2P_EEPSITE_INBOUND_LENGTH}
option.inbound.lengthVariance=0
option.inbound.quantity=${F5M_I2P_EEPSITE_INBOUND_QUANTITY}
option.outbound.length=${F5M_I2P_EEPSITE_OUTBOUND_LENGTH}
option.outbound.lengthVariance=0
option.outbound.quantity=${F5M_I2P_EEPSITE_OUTBOUND_QUANTITY}
startOnLoad=true
EOF
    chmod 0600 "${EEPSITE_DROPIN_DIR}/${SITE_NAME}.config"

    if [ -f "${SITE_KEY}" ]
    then
      B32_ADDR="$(extract-b32-address "${SITE_KEY}" 2>/dev/null || true)"
      if [ -n "${B32_ADDR}" ]
      then
        b19-log good "I2P" "$(_p "Eepsite %s destination: %s (key %s)" "${SITE_NAME}" "${B32_ADDR}" "${SITE_KEY}")"
      else
        b19-log good "I2P" "$(_p "Eepsite %s identity at %s, .b32.i2p available after tunnel startup" "${SITE_NAME}" "${SITE_KEY}")"
      fi
    fi
  done

  for stale in "${EEPSITE_RENDERED[@]}"
  do
    if ! grep --quiet --line-regexp --fixed-strings -- "${stale}" "${EEPSITE_MANIFEST}"
    then
      rm -f "${EEPSITE_DROPIN_DIR}/${stale}"
      b19-log info "I2P" "$(_p "Dropped the tunnel of a site that is no longer declared: %s" "${stale}")"
    fi
  done
  LC_ALL=C sort --unique --output "${EEPSITE_MANIFEST}" "${EEPSITE_MANIFEST}"
  b19-log info "I2P" "$(_p "Rendered %s eepsite tunnels into %s" "${#EEPSITE_SITES[@]}" "${EEPSITE_DROPIN_DIR}")"
