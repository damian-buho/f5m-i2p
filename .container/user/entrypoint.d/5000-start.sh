#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT

  if [ "${ENTRYPOINT_COMMAND_EXECUTED:-N}" = "N" ]
  then
    # java.io.tmpdir (wrapper.config.j2) points here so I2P's native crypto
    # libs extract to a writable AND executable dir — /tmp is noexec on hardened
    # hosts and the libs fail to load there. Create it before the JVM starts.
    mkdir -p "${XDG_CACHE_HOME}/tmp"
    # Wrapper writes pid/log to ${B19_HOME}/.i2p (i2prouter script default) —
    # a Docker named volume first-created as root:root makes this unwritable
    # and the wrapper exits with “Permission denied” (kiota-i2p healthcheck
    # always unhealthy). Pre-create in volumes.deps fixes NEW volumes; for
    # existing root-owned volumes log a clear remediation and try to recover.
    I2P_DOT_DIR="${B19_HOME}/.i2p"
    mkdir -p "${I2P_DOT_DIR}" 2>/dev/null || true
    if [ ! -w "${I2P_DOT_DIR}" ]; then
      b19-log warn "I2P" "$(_p "Directory %s not writable (owner %s) — wrapper will fail with Permission denied" "${I2P_DOT_DIR}" "$(stat -c %U:%G "${I2P_DOT_DIR}" 2>/dev/null || echo "unknown")")"
      b19-log warn "I2P" "$(_ "Attempting to fix permissions via chmod — if this fails, run once as root: docker run --rm -v <volume>:/vol alpine chown 1000:1000 /vol")"
      chmod u+rwx "${I2P_DOT_DIR}" 2>/dev/null || true
      # Last resort: make world-writable so the wrapper can proceed even if
      # the volume stays root-owned (existing volumes on kiota hosts).
      if [ ! -w "${I2P_DOT_DIR}" ]; then
        chmod 0777 "${I2P_DOT_DIR}" 2>/dev/null || true
      fi
      if [ ! -w "${I2P_DOT_DIR}" ]; then
        b19-log error "I2P" "$(_p "Still not writable: %s — aborting, fix the volume ownership" "${I2P_DOT_DIR}")"
        exit 1
      fi
      b19-log good "I2P" "$(_p "Recovered writability on %s" "${I2P_DOT_DIR}")"
    fi
    # Ensure subdirs the router will need are present with correct ownership
    mkdir -p "${XDG_DATA_HOME}/eepsite" 2>/dev/null || true
    b19-log info "I2P" "$(_p "No command provided, will run %s" "I2P console")"
    b19-exec --     \
      i2prouter console

  fi
