# mapcrafter
Docker container to run Mapcrafter https://mapcrafter.org

# Usage
## Minecraft 1.13 (and above)
```bash
docker run -d -v /path/to/output:/output -v /path/to/config:/config -v /path/to/world:/world:ro --name mapcrafter muebau/mapcrafter:1.13
```

## Minecraft 1.12 (and below)
```bash
docker run -d -v /path/to/output:/output -v /path/to/config:/config -v /path/to/world:/world:ro --name mapcrafter muebau/mapcrafter:1.12
```

# Volumes
There a three volumes:

## /world
The Minecraft "world" folder is expected here.

## /config
If a special config is needed it can be delivered here. If there is no `render.conf` present a simple one is generated at first start.

## /output
The generated output is put here.
