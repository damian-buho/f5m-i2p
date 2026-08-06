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
    b19-log info "I2P" "$(_p "No command provided, will run %s" "I2P console")"
    b19-exec --     \
      i2prouter console

  fi
