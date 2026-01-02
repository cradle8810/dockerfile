FROM ubuntu:24.04 AS builder
LABEL org.opencontainers.image.source=https://github.com/cradle8810/dockerfile

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    ffmpeg \
    gpac \
    exiftool \
    && rm -rf /var/lib/apt/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    libopencv-dev \
    libgoogle-glog-dev \
    ocl-icd-libopencl1 \
    && rm -rf /var/lib/apt/*

WORKDIR /opt/bin
COPY --chmod=755 ./convert.sh /opt/bin/convert.sh

WORKDIR /work
ENTRYPOINT ["/opt/bin/convert.sh"]
