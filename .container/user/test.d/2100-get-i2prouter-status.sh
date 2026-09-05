#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT

  set -eou pipefail

  # i2prouter status checks the wrapper pid file; the wrapper creates it
  # asynchronously after `i2prouter console` starts and the JVM is launching.
  # Healthcheck (100-check-i2p-router-health.sh) waits for the console (port
  # 7657 ≈ 4 s), but test.d may still race the pid file. Retry with backoff so
  # the test does not flake on slow CI runners (observed on
  # ci-f5m-i2p-6282-1 where healthcheck passed at 0 s yet status reported
  # “I2P Service is not running” once).
  for _ in 1 2 3 4 5 6 7 8 9 10; do
    if i2prouter status; then
      exit 0
    fi
    sleep 1
  done
  # final attempt — propagate its exit code and output
  i2prouter status
