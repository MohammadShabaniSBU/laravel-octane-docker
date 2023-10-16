# Laravel Image With Octane Support

To use this image, you need to bind/copy your app to the `/app` directory and use one of the supervisor configs. Then you should bind the proper supervisor config to `/etc/supervisord.conf`.

## Sample docker-compose

```yml
version: '3'

services:
  app:
    image: ghcr.io/mohammadshabanisbu/laravel-octane-docker:8.2-dev
    container_name: container-name
    restart: always
    working_dir: /app
    volumes:
      - .:/app
      - .docker/supervisord.conf:/etc/supervisord.conf
    ports:
      - 80:8080
```

In this example the docker-compose file is in root directory of project and the supervisor config is in `.docker/supervisord.conf` file.