# This Dockerfile requires nvidia-docker
# https://hub.docker.com/r/nvidia/cuda
#
# This should match the CUDA version of your host's driver
# Run the nvidia-smi command to check the version
FROM nvidia/cuda:12.0.0-runtime-ubuntu22.04

# Hint: set these to your user ID
# See https://stackoverflow.com/questions/56844746/how-to-set-uid-and-gid-in-docker-compose
ARG APP_UID=1000
ARG APP_GID=1000

# Install
# See https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki/Dependencies
RUN apt-get -y update \
  && apt-get -y install \
    libgl1 \
    libglib2.0-0 \
    libgoogle-perftools-dev \
    git \
    python3 \
    python3-venv \
    python3-pip \
    sudo \
    vim \
    wget

# Create a non-root user
# https://stackoverflow.com/questions/25845538/how-to-use-sudo-inside-a-docker-container
RUN getent passwd "$APP_UID" || ( \
      groupadd --system --gid $APP_GID app \
      && useradd --uid $APP_UID --gid $APP_GID --system \
        --create-home --home-dir /home/app --shell /bin/bash --groups sudo \
        --password "$(openssl passwd -1 app)" app \
  ) \
  && echo 'app ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/33-app

# Switch from root
USER $APP_UID:$APP_GID

# Hint: mount this volume to avoid downloading stuff every time
# See docker-compose.yml for an example
VOLUME /home/app/project
WORKDIR /home/app/project

# Set the install location of stable-diffusion-webui
# See https://github.com/AUTOMATIC1111/stable-diffusion-webui/blob/master/webui-user.sh
ENV install_dir /home/app/project

# Set the cache location for HuggingFace transformers downloads
# See https://huggingface.co/docs/transformers/installation#cache-setup
ENV HF_HOME /home/app/project/huggingface

# Set the branch you want to clone
ENV WEBUI_BRANCH=v1.3.0

# Whether to download the webui and models if they don't exist
ENV WEBUI_DOWNLOAD=1

# Load the tcmalloc library
ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libtcmalloc.so.4

# Copy entrypoint.sh
COPY ./rootfs/ /

# Set the entrypoint
# This checks for important runtime dependencies before running webui.sh
ENTRYPOINT [ "/entrypoint.sh" ]

# Run webui.sh by default
CMD ["bash", "./webui.sh", "--listen", "--port", "7860"]

