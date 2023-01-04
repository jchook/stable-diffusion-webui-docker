# This Dockerfile requires nvidia-docker
# https://hub.docker.com/r/nvidia/cuda
#
# This much match the CUDA version of your driver
# Run the nvidia-smi command to check the version
FROM nvidia/cuda:12.0.0-runtime-ubuntu22.04

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

# Not sure if we can pre-install for the venv
#RUN pip install gfpgan clip open_clip fastapi
#RUN pip3 install accelerate torch torchvision

# Switch from root
USER $APP_UID:$APP_GID

# You must mount ./project/stable-diffusion-webui with a model.ckpt file
# TODO: automatically download this if it doesn't exist
VOLUME /home/app/project
WORKDIR /home/app/project

# TODO: Not sure if this carries into webui.sh
ENV install_dir /home/app/project

# See https://huggingface.co/docs/datasets/cache
ENV HF_DATASETS_CACHE /home/app/project/huggingface/datasets

COPY ./rootfs/ /
ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["bash", "./webui.sh"]
