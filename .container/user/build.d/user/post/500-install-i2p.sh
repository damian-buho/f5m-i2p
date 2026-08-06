#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT

  eval "$(b19-resolve-dep i2p)"

  b19-fetch "I2P" "${M6E_UPSTREAM__URL}" "${M6E_UPSTREAM__FILE}" "${M6E_UPSTREAM__HASH}"

  b19-run "I2P" "$(_ "Preparing response file")" --     \
    minijinja-cli --autoescape none --env "${B19_HOME}/response.txt.j2" -o "${B19_HOME}/response.txt"

  LANG=C java -jar "${B19_TEMP_PATH}/${M6E_UPSTREAM__FILE}" -console < "${B19_HOME}/response.txt"

  # Remove installer-generated configs (replaced by j2 templates)
  rm -f "${B19_HOME}/i2ptunnel.config"
  rm -f "${B19_HOME}/clients.config"
  rm -f "${B19_HOME}/router.config"
  rm -f "${B19_HOME}/wrapper.config"

  # Remove cgi-context.xml: requires jetty-fcgi jar not bundled with I2P
  rm -f "${B19_HOME}/eepsite/contexts/cgi-context.xml"
