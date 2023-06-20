# AUTOMATIC1111 Stable Diffusion Web UI Docker

Dockerized
[AUTOMATIC1111/stable-diffusion-webui](https://github.com/AUTOMATIC1111/stable-diffusion-webui)
for generating images with Stable Diffusion on Linux.


## Features

- [x] **Simple and focused** - Only AUTOMATIC1111's webui, nothing else.
- [x] **Easy set-up** - One command to both install and launch.
- [x] **Easy config** - Manage your entire webui directory on the host.
- [x] **Straightforward** - Nothing fancy. Default settings. Simple Dockerfile.
- [x] **Non-root** - Files are owned by your user. Nothing runs as root.
- [x] **Fast** - Start-up and shutdown are as snappy as running natively.

## Requirements

- Linux (for now)
- An Nvidia GPU (hardware)
- Docker (>= 19)
- [nvidia-docker](https://github.com/NVIDIA/nvidia-docker)

## How to Use

Enjoy a streamlined experience with [`just`](https://github.com/casey/just):

```sh
# Build with your user ID
just build

# Test if your environment is supported
just test-gpu

# Run
just up
```

Otherwise, you can use the standard docker tools as expected:

```sh
docker compose up
```

## See Also

- [jchook/kohya-trainer-docker](https://github.com/jchook/kohya-trainer-docker/). - train models to use with this webui
- [AbdBarho/stable-diffusion-webui-docker](https://github.com/AbdBarho/stable-diffusion-webui-docker) - alternative docker interface for this webui

