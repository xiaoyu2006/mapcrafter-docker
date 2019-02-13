#
# Build Image
#

FROM ubuntu as builder
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

FROM ubuntu
MAINTAINER muebau <hb1c@gmx.net>

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /

VOLUME ["/config"]
VOLUME ["/output"]
VOLUME ["/world"]

# Mapcrafter, built in previous stage
COPY --from=builder /tmp/mapcrafter/ /

# Depedencies needed for running Mapcrafter
RUN apt-get update && apt-get install -y libpng-dev libjpeg-turbo8 libboost-iostreams-dev git cmake build-essential libboost-all-dev libjpeg-dev && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD crontab /etc/cron.d/mapcrafter-cron
RUN chmod 0644 /etc/cron.d/mapcrafter-cron
RUN touch /var/log/cron.log
RUN echo "container created" >> /var/log/cron.log

ADD render.sh /render
RUN chmod 0777 /render
ADD render.conf /

CMD cron && tail -f /var/log/cron.log
