# DEPRECATED

Please visit https://github.com/ayudadigital/gp-passbolt/releases

# Generic Platform - Passbolt Service

## Overview

Docker image and docker-compose sample configuration to bring up a Passbolt Service to the Teecke [Docker Generic Platform (GP)](https://github.com/ayudadigital/docker-generic-platform).

## Configuration

The service is formed by two containers:

- **passbolt**: based on [passbolt/passbolt](https://hub.docker.com/r/passbolt/passbolt) docker image.
- **passboltdb**: based on [MariaDB](https://hub.docker.com/_/mariadb) databasse docker image.

## Operation

1. Create the `passbolt.env` and `mysql.env` files based on the template ones and configure the appropiate keys

    ```console
    $ cp passbolt.env.dist passbolt.env
    $ cp mysql.env.dist mysql.env
    $ grep PUT *.env
    mysql.env.dist:MYSQL_ROOT_PASSWORD=[PUT_YOUR_MYSQL_ROOT_PASSWORD_HERE]
    mysql.env.dist:MYSQL_PASSWORD=[PUT_YOUR_MYSQL_PASSBOLT_PASSWORD_HERE]
    passbolt.env.dist:APP_FULL_BASE_URL=[PUT_YOUR_BASE_URL_HERE]
    passbolt.env.dist:DATASOURCES_DEFAULT_PASSWORD=[PUT_YOUR_MYSQL_PASSBOLT_PASSWORD_HERE]
    $ vim passbolt.env

    [...]

    $ vim mysql.env

    [...]

    $ grep PUT *.env
    mysql.env.dist:MYSQL_ROOT_PASSWORD=root_password
    mysql.env.dist:MYSQL_PASSWORD=passbolt_password
    passbolt.env.dist:APP_FULL_BASE_URL=https://localhost:10443
    passbolt.env.dist:DATASOURCES_DEFAULT_PASSWORD=passbolt_password

    ```

2. Use the `docker-compose.yml.sample` file as your docker-compose configuration file.

3. Install assets with `devcontrol assets-install`.

4. Start with `docker-compose up -d`.

5. Open the url <https://localhost:10443> in a browser to access to the Passbolt gui and complete the configuration.

6. Manage backups of your files:

   1. Make a backup executing `docker-compose exec passbolt backup`.
   2. Find the current backup within the `/var/backups/gp/passbolt/` of the container.
   3. Extract the current backup executing `docker cp $(docker-compose ps -q passbolt):/var/backups/gp gp`.

7. Stop the platform with `docker-compose stop`.

You should create the `admin` user following the [docker setup](https://help.passbolt.com/hosting/install/ce/docker.html) instructions

```console
$ docker-compose exec passbolt su -m -c "/var/www/passbolt/bin/cake \
>                                     passbolt register_user \
>                                     -u user@example.com \
>                                     -f User \
>                                     -l Example \
>                                     -r admin" -s /bin/sh www-data
     ____                  __          ____  
    / __ \____  _____ ____/ /_  ____  / / /_ 
   / /_/ / __ `/ ___/ ___/ __ \/ __ \/ / __/ 
  / ____/ /_/ (__  |__  ) /_/ / /_/ / / /    
 /_/    \__,_/____/____/_.___/\____/_/\__/   

 Open source password manager for teams
---------------------------------------------------------------
User saved successfully.
To start registration follow the link in provided in your mailbox or here: 
https://example.com/setup/install/07a24404-db6d-427b-b749-cdb884e54f5e/49733fb8-0ae3-4b37-8581-639f22e21d60
```

There is one volume created with the database. All data and configuration are on those volumes, so never delete it.

```console
$ docker volume ls|grep "passbolt\|VOLUME"
DRIVER              VOLUME NAME
local               passbolt_database
```

You can use this docker piece with the [Docker Generic Platform](https://github.com/ayudadigital/docker-generic-platform) project.

## Known issues

None known
