# College Application Tracker
## Summary
This project launches the different components of College Application Tracker.  Currently, College Application Tracker has three components that need to be started for the application to work.  They are:

* Postgres Database with a "college" db instance
* Nginx webserver that hosts the Angular2 artifacts
* A Spring Boot application

## Starting the application
To start the application, make sure you have docker installed in your machine.  You can install [Docker Machine](https://docs.docker.com/machine/install-machine/) in the environment of your choice.

After you've installed Docker Machine, you can do the following.
```
$ docker-compose up
```

This will start the Postgres database with a "college" db instance listening in port 55432, the nginx webserver listening in port 80 and the Spring Boot application listening in port 8080.

## Accessing the application
### PostgreSQL
You can access the database using the following settings:
```
url=jdbc:postgresql://localhost:55432/college
username=tracker_user
password=tr@ck3r_u53r
```
### Swagger Documenation
You can access the API documentation [here](http://localhost:8080/swagger-ui.html).
### College Application Tracker
You can access the application at [http://localhost](http://localhost:8080/swagger-ui.html).

## Shutting down the application
```
$ docker-compose down
```

This will stop and remove the container as well as any network, images and volumes associated with this application.
