## Running a postgresql container to store data

The sample `uaa.yml` configuration tells the UAA server to store its data in a postgresql database. If you change it to something else, then skip to the next chapter.

To easily create a postgresql database on your local dev environment, use Docker. The following command creates a local [postgresql container](https://registry.hub.docker.com/_/postgres/) with a default database called 'postgres' and a default user 'postgres'.

```
docker run -d --name uaa-db postgres
```

## Running the UAA server

To run the UAA server, first you'll need a configuration file. UAA accepts a YAML config file where the default clients and users can be defined among some other things, like where to store the data. You can find a basic configuration in the project repository. The default configuration stores data in a postgresql database whose connection parameters are defined in environment variables (that are automatically set when a database container is linked with the name *db*).

This docker container reads the configuration file `uaa.yml` from the `/uaa` folder. The container can accept configuration files from an URL, or from a shared volume. To run a UAA server with a configuration file in a shared volume, run this command:

```
docker run -d --link uaa-db:db -v /tmp/uaa:/uaa:rw hortonworks/cloudbreak-uaa:2.7.1
```

If you are using boot2docker on OSX, host volume sharing only shares the host folder in boot2docker, so make sure your configuration is in boot2docker's `/tmp/uaa` folder.

To get the configuration from an URL:

```
docker run -d --link uaa-db:db -e UAA_CONFIG_URL=https://raw.githubusercontent.com/sequenceiq/docker-uaa/master/uaa.yml hortonworks/cloudbreak-uaa:2.7.1
```
