# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT

ARG B19_JAVA_IMAGE=registry.invalid/b19/java:temurin-26
ARG B19_UBUNTU_BASE_IMAGE=registry.invalid/b19/ubuntu:resolute

FROM ${B19_JAVA_IMAGE} AS f5m-i2p-compile-java

ARG B19_COLOR
ARG B19_FETCH_DOCKER_CACHE
ARG B19_FETCH_LOCAL_CACHE
ARG B19_OFFGRID_MODE
ARG B19_VERBOSITY
ARG LANG=""
ARG M6E_AI=N
ARG M6E_APT_CACHE_HOST=""
ARG M6E_APT_CACHE_PORT=""
ARG M6E_BUILD_DEBUG=""
ARG M6E_NEAR_CACHE_HOST=""
ARG M6E_NAMESPACE
ARG M6E_PROJECT
ARG TARGETARCH

COPY --chown=${B19_UID}:${B19_GID} .container/compile-java/ /

# hadolint ignore=DL3066 # B19_UID comes from the root
USER ${B19_UID}

WORKDIR ${B19_HOME}

RUN --mount=type=bind,from=fetch,source=.,target=/fetch                                             \
    --mount=type=cache,target=${B19_DOWNLOAD_PATH},sharing=shared,uid=${B19_UID},gid=${B19_GID}     \
    --mount=type=tmpfs,target=${B19_TEMP_PATH}                                                      \
    build-stage compile-java

USER 0

RUN --mount=type=tmpfs,target=${B19_TEMP_PATH}                                                      \
    build-stage export

# hadolint ignore=DL3066 # B19_UID comes from the root
USER ${B19_UID}

FROM ${B19_UBUNTU_BASE_IMAGE} AS b19-proxy-i2p

ARG B19_COLOR
ARG B19_FETCH_DOCKER_CACHE
ARG B19_FETCH_LOCAL_CACHE
ARG B19_OFFGRID_MODE
ARG B19_VERBOSITY
ARG LANG=""
ARG M6E_AI=N
ARG M6E_APT_CACHE_HOST=""
ARG M6E_APT_CACHE_PORT=""
ARG M6E_BUILD_DEBUG=""
ARG M6E_NEAR_CACHE_HOST=""
ARG M6E_NAMESPACE
ARG M6E_PROJECT
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
    # host:port the eepsite tunnel forwards to. Deliberately NOT split into a
    # *_PORT var: check-ports rejects any numeric *PORT env (80 is a WHATWG bad
    # port), but this is an outbound destination, not a listening socket.
    F5M_I2P_EEPSITE_TARGET="localhost:8080"             \
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
    F5M_I2P_RESEED_PRESET_ENABLED="true"                \
    # host:port in one var, same reason as F5M_I2P_EEPSITE_TARGET above.
    F5M_I2P_RESEED_PROXY=""                             \
    F5M_I2P_RESEED_PROXY_ENABLED="false"                \
    F5M_I2P_RESEED_PROXY_TYPE="HTTP"                    \
    F5M_I2P_RESEED_URLS=""                              \
    F5M_I2P_SAM_ENABLED="false"                         \
    F5M_I2P_SMTP_ENABLED="false"                        \
    F5M_I2P_SUBSCRIPTIONS_PRESET_ENABLED="true"         \
    F5M_I2P_SUBSCRIPTIONS_URLS=""                       \
    F5M_I2P_UPNP="false"                                \
    I2P_CONFIG_DIR="${B19_HOME}"                        \
    PATH="${B19_HOME}:${PATH}"

USER 0

WORKDIR ${B19_HOME}

COPY --from=f5m-i2p-compile-java /export/ /
COPY --chown=${B19_UID}:${B19_GID} .container/root/ /

RUN --mount=type=bind,from=fetch,source=.,target=/fetch                                           \
    --mount=type=cache,target=${B19_DOWNLOAD_PATH},sharing=shared                                 \
    --mount=type=cache,id=apt-cache-${B19_UBUNTU_SERIES}-${TARGETARCH},target=/var/cache/apt,sharing=shared     \
    --mount=type=cache,id=apt-lists-${B19_UBUNTU_SERIES}-${TARGETARCH},target=/var/lib/apt,sharing=shared       \
    --mount=type=tmpfs,target=${B19_TEMP_PATH}                                                    \
    build-stage root

# hadolint ignore=DL3066 # B19_UID comes from the root
USER ${B19_UID}

COPY --chown=${B19_UID}:${B19_GID} .container/user/ /

ARG M6E_VERSION
RUN --mount=type=bind,from=fetch,source=.,target=/fetch                                             \
    --mount=type=cache,target=${B19_DOWNLOAD_PATH},sharing=shared,uid=${B19_UID},gid=${B19_GID}     \
    --mount=type=tmpfs,target=${B19_TEMP_PATH}                                                      \
    build-stage user

# This image cannot do its job offline, so a lost outside must read as unhealthy.
ENV B19_HEALTH_EGRESS=true

# ENTRYPOINT ["entrypoint.d"] is inherited
# HEALTHCHECK CMD ["healthcheck.d"] is inherited
# Don't use CMD ["sleep", "infinity"] here
# No baked-in Traefik labels: routing is compose-owned (o9s convention), and a
# label here would auto-expose the router console on any Traefik doing Docker
# discovery — an admin surface that must be opt-in per deployment.
