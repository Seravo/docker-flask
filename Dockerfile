# This can be *any* Ubuntu/Debian base image with sufficient Python3 version
# available
FROM ghcr.io/seravo/ubuntu:jammy

ARG APT_PROXY

ENV APPDIR /app
ENV VEDIR /ve
ENV LOG_FILTER_REGEX ^((?!\/healthcheck).)*$

RUN sed -i 's/main$/main universe/g' /etc/apt/sources.list && \
    export DEBIAN_FRONTEND="noninteractive" && \
    /usr/sbin/apt-setup && \
    apt-get --assume-yes upgrade && \
    apt-get --assume-yes install \
        curl \
        entr \
        procps \
        python3 \
        python3-dev \
        python3-flask \
        python3-pip \
        python3-pytest \
        python3-setuptools \
        python3-venv \
        python3-wheel \
        uwsgi \
        uwsgi-plugin-python3 && \
    /usr/sbin/apt-cleanup

RUN mkdir -p "${APPDIR}" "${VEDIR}"

RUN adduser --disabled-password --gecos "user,,," user && \
    chown user "${VEDIR}"

COPY entrypoint.sh /entrypoint.sh

WORKDIR "${APPDIR}"
USER user

RUN python3 -m venv --system-site-packages "${VEDIR}" && \
    echo 'export PATH="${VEDIR}:${PATH}"' >> /home/user/.profile

ENTRYPOINT ["/entrypoint.sh"]

HEALTHCHECK --interval=10s --timeout=5s --start-period=5s --retries=3 CMD curl -f http://localhost:8080/ || exit 1
EXPOSE 8080/tcp
