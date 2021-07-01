#
# Build Image
#

FROM ubuntu:20.04 as mapcrafter1.12-builder

ENV DEBIAN_FRONTEND noninteractive

# Get dependency
RUN apt-get update && \
    apt-get install -y libpng-dev libjpeg-turbo8 git cmake build-essential libboost-all-dev libjpeg-dev

# Add the git repo and build it
RUN mkdir /git && cd /git && \
    git clone --single-branch --depth=1 https://github.com/ynf-mc/mapcrafter.git && \
    cd mapcrafter && \
    mkdir build && cd build && \
    cmake .. && \
    make -j4 && \
    mkdir /mapcrafter && \
    make DESTDIR=/mapcrafter install

#
# Final Image
#

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /

VOLUME ["/workspace"]

# Mapcrafter, built in previous stage
COPY --from=mapcrafter1.12-builder /mapcrafter/ /

# Depedencies needed for running Mapcrafter
RUN apt-get update && apt-get install -y \
        libpng16-16 \
        libjpeg-turbo-progs \
        libboost-iostreams1.71.0 \
        libboost-system1.71.0 \
        libboost-filesystem1.71.0 \
        libboost-program-options1.71.0 && \
        apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
        ldconfig

WORKDIR /workspace

ENTRYPOINT ["sh", "-c", "mapcrafter $1"]
