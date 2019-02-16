#!/bin/bash
if [ ! -f /config/render.conf ]; then
    echo "No config file found. Created a new one."
    cp /render.conf /config/render.conf
fi

RUNNINGMAPCRAFTERS=$(pgrep -c mapcrafter)
if [ $RUNNINGMAPCRAFTERS == "0" ]; then
    mapcrafter -c /config/render.conf -j 2
else
    echo "Found $RUNNINGMAPCRAFTERS instances of mapcrafter. So no new instance was started."
fi
