#!/bin/bash
if [ ! -f /config/render.conf ]; then
    cp /render.conf /config/render.conf
fi

mapcrafter -c /config/render.conf -j 2 >> /var/log/cron.log 2>&1
