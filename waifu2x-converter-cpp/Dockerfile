FROM ubuntu:24.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libopencv-dev \
    libgoogle-glog-dev \
    libgflags-dev \
    opencl-headers \
    ocl-icd-opencl-dev \
    && rm -rf /var/lib/apt/*

WORKDIR /src
RUN git clone https://github.com/DeadSix27/waifu2x-converter-cpp.git . &&\
    mkdir build && cd build &&\
    cmake .. &&\
    make -j$(nproc)

#----------------------------------------
FROM ubuntu:24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    libopencv-dev \
    libgoogle-glog-dev \
    ocl-icd-libopencl1 \
    && rm -rf /var/lib/apt/*

WORKDIR /opt/bin
COPY --from=builder /src/build/waifu2x-converter-cpp .
COPY --from=builder /src/build/libw2xc.so .
COPY --from=builder /src/models_rgb/* /usr/local/share/waifu2x-converter-cpp/

ENV LD_LIBRARY_PATH=/opt/bin

WORKDIR /work
ENTRYPOINT ["/opt/bin/waifu2x-converter-cpp"]
CMD ["--help"]
