# This can be *any* Ubuntu/Debian base image with sufficient Python3 version
# available
FROM docker.io/ypcs/debian:bullseye

ARG APT_PROXY

ENV APPDIR /app
ENV VEDIR /ve
ENV FLASK_APP hello:app

RUN /usr/lib/docker-helpers/apt-setup && \
    /usr/lib/docker-helpers/apt-upgrade && \
    apt-get --assume-yes install \
        curl \
        entr \
        procps \
        python3 \
        python3-dev \
        python3-flask \
        python3-pip \
        python3-setuptools \
        python3-venv \
        python3-wheel \
        uwsgi \
        uwsgi-plugin-python3 && \
    /usr/lib/docker-helpers/apt-cleanup

RUN mkdir -p "${APPDIR}" "${VEDIR}"

RUN adduser --disabled-password --gecos "user,,," user && \
    chown user "${VEDIR}"

COPY hello.py "${APPDIR}/hello.py"
COPY entrypoint.sh /entrypoint.sh

WORKDIR "${APPDIR}"
USER user

RUN python3 -m venv --system-site-packages "${VEDIR}" && \
    echo 'export PATH="${VEDIR}:${PATH}"' >> /home/user/.profile

ENTRYPOINT ["/entrypoint.sh"]

HEALTHCHECK --interval=10s --timeout=5s --start-period=5s --retries=3 CMD curl -f http://localhost:8080/ || exit 1
EXPOSE 8080/tcp
