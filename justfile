set positional-arguments

build:
  docker-compose build webui

sh:
  docker-compose run webui bash

ls:
  docker-compose run webui ls -la

test-gpu:
  docker-compose run webui python3 -c 'import torch; torch.cuda.is_available()'

up *args:
  docker-compose up "$@"
