#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT

set -eou pipefail

# shellcheck source=/dev/null
. b19-i18n

SIGNER_CERT="${B19_HOME}/certificates/reseed/damian.buho_at_proton.me.crt"
# The router rejects reseed.kiota.ch bundles unless its signer certificate ships
if ! grep -q 'BEGIN CERTIFICATE' "${SIGNER_CERT}" 2>/dev/null; then
  b19-log bad "TEST.D" "$(_p "Reseed signer certificate missing: %s" "${SIGNER_CERT}")"
  exit 1
fi
b19-log good "TEST.D" "$(_p "Reseed signer certificate ships (%s)" "${SIGNER_CERT}")"
