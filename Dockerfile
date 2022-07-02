FROM python:3.10.4-slim-bullseye

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

EXPOSE 65413

CMD [ "python", "./dsvpwa.py" , "--host", "0.0.0.0" ]
