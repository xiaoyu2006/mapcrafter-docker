#
# Build Image
#

FROM ubuntu:18.04 as mapcrafter1.13-builder
MAINTAINER muebau <hb1c@gmx.net>

# Get dependency
RUN apt-get update && apt-get install -y libpng-dev libjpeg-turbo8 libboost-iostreams-dev git cmake build-essential libboost-all-dev libjpeg-dev

# Add the git repo and build it
RUN mkdir /git && cd /git && \
    git clone --single-branch --branch world113 https://github.com/mapcrafter/mapcrafter.git && \
    cd mapcrafter && mkdir build && cd build && \
    cmake .. && \
    make && \
    mkdir /tmp/mapcrafter && \
    make DESTDIR=/tmp/mapcrafter install

#
# Final Image
#

FROM ubuntu:18.04
MAINTAINER muebau <hb1c@gmx.net>

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /

VOLUME ["/config"]
VOLUME ["/output"]
VOLUME ["/world"]

# Mapcrafter, built in previous stage
COPY --from=mapcrafter1.13-builder /tmp/mapcrafter/ /

# Depedencies needed for running Mapcrafter
RUN apt-get update && apt-get install -y cron \
        libpng16-16 \
        libjpeg-turbo-progs \
        libboost-iostreams1.65.1 \
        libboost-system1.65.1 \
        libboost-filesystem1.65.1 \
        libboost-program-options1.65.1 && \
        apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* &&\
        ldconfig

ADD crontab /etc/cron.d/mapcrafter-cron
RUN chmod 0644 /etc/cron.d/mapcrafter-cron

ADD render.sh /render
RUN chmod 0777 /render
ADD render.conf /

CMD cron -f
