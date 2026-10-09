#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT

  # Installer output under B19_HOME, minus the volume, the JMX exporter and the installer answers
  while IFS= read -r I2P_EXPORT_ENTRY; do
    b19-run "I2P" "$(_p "Export %s" "${I2P_EXPORT_ENTRY}")" -- cp --archive --parents "${I2P_EXPORT_ENTRY}" /export/
  done < <(fd --hidden --no-ignore --max-depth 1 --exclude .i2p --exclude jmx-exporter --exclude 'response.txt*' . "${B19_HOME}")

  b19-run "I2P" "$(_p "Export %s" "/deps/i2p/version.deps")" -- cp --archive --parents /deps/i2p/version.deps /export/
