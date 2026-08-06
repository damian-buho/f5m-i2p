# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT

ARG B19_JAVA_BASE_IMAGE=registry.invalid/b19/java/oracle-25:latest
ARG B19_PYTHON_SERIES=3.14
ARG B19_PYTHON_BASE_IMAGE=registry.invalid/b19/python-${B19_PYTHON_SERIES}:latest

# Standalone python (for extract-b32-address) — copied as static binaries, same
# pattern as b19/node. Avoids a runtime apt dependency for one helper script.
FROM ${B19_PYTHON_BASE_IMAGE} AS b19-python-source

FROM ${B19_JAVA_BASE_IMAGE} AS b19-proxy-i2p

ARG B19_VERBOSITY
ARG LANG
ARG M6E_AI=N
ARG M6E_APT_CACHE_HOST
ARG M6E_APT_CACHE_PORT
ARG M6E_BUILD_DEBUG
ARG M6E_NEAR_CACHE_HOST
ARG M6E_NAMESPACE
ARG M6E_PROJECT
# Stage-scoped: a global ARG must be re-declared here for the COPY path below.
ARG B19_PYTHON_SERIES=3.14
ARG M6E_VERSION
ARG TARGETARCH

ENV B19_JAVA_XMS="128m"                                 \
    B19_JAVA_XMX="256m"                                 \
    F5M_I2P_BROWSER_LAUNCH_ENABLED="false"              \
    F5M_I2P_CONSOLE_PORT="7657"                         \
    F5M_I2P_EEPSITE_ENABLED="true"                      \
    F5M_I2P_EEPSITE_INBOUND_LENGTH="3"                  \
    F5M_I2P_EEPSITE_INBOUND_QUANTITY="2"                \
    # Absolute: the httpserver tunnel resolves a relative privKeyFile against
    # the router dir (/app), but 200-prepare-eepsite.sh loads the key at
    # ${XDG_DATA_HOME}/eepsite/ — a relative default made the provisioned
    # identity unreachable, so I2P silently minted a throwaway on first start.
    F5M_I2P_EEPSITE_KEY_FILE="${XDG_DATA_HOME}/eepsite/eepPriv.dat" \
    F5M_I2P_EEPSITE_OUTBOUND_LENGTH="3"                 \
    F5M_I2P_EEPSITE_OUTBOUND_QUANTITY="2"               \
    # Empty: pass the original Host through unchanged (reverse-proxy eepsite).
    F5M_I2P_EEPSITE_SPOOFED_HOST=""                     \
    F5M_I2P_EEPSITE_TARGET_HOST="localhost"             \
    F5M_I2P_EEPSITE_TARGET_PORT="8080"                  \
    F5M_I2P_GIT_SSH_ENABLED="false"                     \
    F5M_I2P_HOST="localhost"                            \
    # Hidden mode: skip the SSU reachability probe (it never completes in a
    # container with no published UDP port — see router.config.j2).
    F5M_I2P_HIDDEN_MODE="true"                          \
    F5M_I2P_HTTPS_PROXY_ENABLED="false"                 \
    F5M_I2P_HTTP_PROXY_ENABLED="true"                   \
    F5M_I2P_IPV4_FIREWALLED="true"                      \
    F5M_I2P_IPV6="false"                                \
    F5M_I2P_IRC_ENABLED="false"                         \
    F5M_I2P_JETTY_ENABLED="false"                       \
    F5M_I2P_POP3_ENABLED="false"                        \
    F5M_I2P_SAM_ENABLED="false"                         \
    F5M_I2P_SMTP_ENABLED="false"                        \
    F5M_I2P_UPNP="false"                                \
    I2P_CONFIG_DIR="${B19_HOME}"                        \
    PATH="/opt/python/bin:${B19_HOME}:${PATH}"

USER 0

WORKDIR ${B19_HOME}

# Python for extract-b32-address (eepsite .b32.i2p derivation). Copied, not
# installed — same approach as b19/node.
COPY --from=b19-python-source /usr/local/bin/python3*                              /opt/python/bin/
COPY --from=b19-python-source /usr/local/lib/python${B19_PYTHON_SERIES}/           /opt/python/lib/python${B19_PYTHON_SERIES}/

COPY --chown=${B19_UID}:${B19_GID} .container/root/ /

RUN --mount=type=bind,from=fetch,source=.,target=/fetch                                           \
    --mount=type=cache,target=${B19_DOWNLOAD_PATH},sharing=shared                                 \
    --mount=type=cache,id=apt-cache-${B19_UBUNTU_SERIES},target=/var/cache/apt,sharing=shared     \
    --mount=type=cache,id=apt-lists-${B19_UBUNTU_SERIES},target=/var/lib/apt,sharing=shared       \
    --mount=type=tmpfs,target=${B19_TEMP_PATH}                                                    \
    build-stage root

# hadolint ignore=DL3066 # B19_UID comes from the root
USER ${B19_UID}

COPY --chown=${B19_UID}:${B19_GID} .container/user/ /

RUN --mount=type=bind,from=fetch,source=.,target=/fetch                                             \
    --mount=type=cache,target=${B19_DOWNLOAD_PATH},sharing=shared,uid=${B19_UID},gid=${B19_GID}     \
    --mount=type=tmpfs,target=${B19_TEMP_PATH}                                                      \
    build-stage user

# ENTRYPOINT ["entrypoint.d"] is inherited
# HEALTHCHECK CMD ["healthcheck.d"] is inherited
# Don't use CMD ["sleep", "infinity"] here
# No baked-in Traefik labels: routing is compose-owned (o9s convention), and a
# label here would auto-expose the router console on any Traefik doing Docker
# discovery — an admin surface that must be opt-in per deployment.
