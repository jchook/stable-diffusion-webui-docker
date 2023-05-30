#!/bin/bash

# ANSI Shadow from https://manytools.org/hacker-tools/ascii-banner/
echo "

 █████╗ ██╗   ██╗████████╗ ██████╗  ██╗ ██╗ ██╗ ██╗ ██╗
██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗███║███║███║███║███║
███████║██║   ██║   ██║   ██║   ██║╚██║╚██║╚██║╚██║╚██║
██╔══██║██║   ██║   ██║   ██║   ██║ ██║ ██║ ██║ ██║ ██║
██║  ██║╚██████╔╝   ██║   ╚██████╔╝ ██║ ██║ ██║ ██║ ██║
╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝  ╚═╝ ╚═╝ ╚═╝ ╚═╝ ╚═╝
" >&2

# Check for webui git repo
if [ -d stable-diffusion-webui ]; then
  echo "Found stable-diffusion-webui" >&2
elif [ -n "$WEBUI_DOWNLOAD" ]; then
  echo "Cloning stable-diffusion-webui..." >&2
  git clone --branch "${WEBUI_BRANCH:-v1.3.0}" https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
else
  echo "Missing stable-diffusion-webui" >&2
  exit 1
fi

# Refocus
cd stable-diffusion-webui

# If you don't have a base checkpoint the webui.py script will die with:
#
# > No checkpoints found. When searching for checkpoints, looked at:
# >  - file /home/app/stable-diffusion-webui/model.ckpt
# >  - directory /home/app/stable-diffusion-webui/models/Stable-diffusion
#
# So we'll automatically download one here...
if [ -f ./model.ckpt ]; then
  echo "Found model.ckpt" >&2
elif [ -d ./models/Stable-diffusion ]; then
  echo "Found models/Stable-diffusion" >&2
elif [ -n "$WEBUI_DOWNLOAD" ]; then
  echo "Downloading stable-difussion-1-4.ckpt..." >&2
  echo "TODO!" >&2
else
  echo "Missing stable diffusion base model." >&2
  exit 1
fi

# Execute whatever
echo "# $*" >&2
exec "$@"
