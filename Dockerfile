#
# Build Image
#

FROM ubuntu:20.04 as mapcrafter1.12-builder

ENV DEBIAN_FRONTEND noninteractive

# Get dependency
RUN apt-get update && \
    apt-get install -y libpng-dev libjpeg-turbo8 libboost-iostreams-dev git cmake build-essential libboost-all-dev libjpeg-dev

# Add the git repo and build it
RUN mkdir /git && cd /git && \
    git clone --single-branch --depth=1 https://github.com/xiaoyu2006/mapcrafter.git && \
    cd mapcrafter && \
    mkdir build && cd build && \
    cmake .. && \
    make && \
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
        libboost-iostreams1.65.1 \
        libboost-system1.65.1 \
        libboost-filesystem1.65.1 \
        libboost-program-options1.65.1 && \
        apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
        ldconfig

WORKDIR /workspace

ENTRYPOINT ["sh", "-c", "mapcrafter $1"]
