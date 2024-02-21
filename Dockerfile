FROM python:3.13.0a4-slim-bullseye

ARG BUILD_VER
ARG BUILD_REV
ARG BUILD_DATE

ENV BUILD_VER ${BUILD_VER}
ENV BUILD_REV ${BUILD_REV}
ENV BUILD_DATE ${BUILD_DATE}

RUN apt-get update && apt-get install -y \
  dnsutils \
  net-tools \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY . .

RUN useradd -d /home/dockle -m -s /bin/bash dockle
USER dockle

HEALTHCHECK --interval=5m --timeout=3s CMD curl -f http://localhost:65413/ || exit 1

EXPOSE 65413

CMD [ "python", "./dsvpwa.py" , "--host", "0.0.0.0" ]
