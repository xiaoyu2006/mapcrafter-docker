#!/bin/bash
if [ ! -f /config/render.conf ]; then
    cp /render.conf /config/render.conf
fi

RUNNINGMAPCRAFTERS=$(pgrep -c mapcrafter)
if [ $RUNNINGMAPCRAFTERS == "0" ]; then
    mapcrafter -c /config/render.conf -j 2 >> /var/log/cron.log 2>&1
else
    echo "Found $RUNNINGMAPCRAFTERS instances of mapcrafter. So no new instance was started." >> /var/log/cron.log
fi
