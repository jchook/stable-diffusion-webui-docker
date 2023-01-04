# This Dockerfile requires nvidia-docker
# https://hub.docker.com/r/nvidia/cuda
#
# This much match the CUDA version of your driver
# Run the nvidia-smi command to check the version
FROM nvidia/cuda:12.0.0-runtime-ubuntu22.04

# Hint: set these to your user ID
ARG APP_UID=1000
ARG APP_GID=1000

# Install
# See https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki/Dependencies
RUN apt-get -y update \
  && apt-get -y install libgl1 libglib2.0-0 git python3 python3-venv python3-pip sudo vim wget

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

# Hint: mount this volume to avoid downloading every time
VOLUME /home/app/project
WORKDIR /home/app/project

# Set the install location of stable-diffusion-webui
ENV install_dir /home/app/project

# See https://huggingface.co/docs/transformers/installation#cache-setup
ENV HF_HOME /home/app/project/huggingface

# Copy the entrypoint, etc
COPY ./rootfs/ /

# The AUTOMATIC1111 python app doesn't respond to SIGTERM, so be more forceful
# Waiting on https://github.com/AUTOMATIC1111/stable-diffusion-webui/pull/6334
STOPSIGNAL SIGINT

# Set the entrypoint
# This checks for important runtime dependencies before running webui.sh
ENTRYPOINT [ "/entrypoint.sh" ]

# Run webui.sh by default
CMD ["bash", "./webui.sh", "--listen", "--port", "7860"]

