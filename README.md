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

# Setting this up in Docker Swarm

To set this up in Docker Swarm, I created a version 3 compose file (docker-compose-swarm.yml).  In this scenario, I defined a network called.  The postgresql database and the college application server will be running with in that network. Additionally, I've specified that the college application server should start of with 2 instances each with 50% of the CPU across the cores and 500MB of RAM.  I've also instructed Docker Swarm to immediately restart if one of the instances fails.

Here are the commands that you need to create a Docker Swarm environment.

* Create a couple of VM's using docker-machine.  I am assuming that you have VirtualBox setup already.
```
$ docker-machine create --driver virtualbox college01
$ docker-machine create --driver virtualbox college02
```

* List your docker machines
```
$ docker-machine ls
```
Note: Please note the IP of college01.  You will need that IP in the next step

* Create a swarm and tag college01 as the manager
The first one (college01) will act as the manager.  It is the one that will execute docker commands and authenticates other workers to join the swarm.  The second (college02) will be a worker.  You might need to use the advertise-addr when performing a `docker swarm init` in college01.  If so, please note the IP address of college01 when you ran the `docker-machine ls`.  You will need to use that IP address when you initialize the swarm.
```
$ docker-machine ssh college01 "docker swarm init --advertise-addr <college01 IP>:2377"
```
This command will spit out something the join command that you need to run to join workers in the swarm.

* Join college02 in the swarm
```
$ docker-machine ssh college02 "docker swarm join --token <token> <ip>:<port>"
```

* SSH to college01 and list the nodes
```
$ docker-machine ssh college01
docker@college01:~$ docker node ls
```
You will see that college01 is tagged as the leader.  college02 joined the swarm as a worker.

* Deploy College App Tracker to the Swarm
In order to deploy the application to the swarm, we need to run docker compose file in college01 (the leader).  To do this, we need to first copy the files necessary to run the application.
```
$ docker-machine scp docker-compose-swarm.yml college01:~
$ docker-machine scp college_tracker.env college01:~
$ docker-machine scp init_db.sql college01:~
$ docker-machine ssh college01 "docker stack deploy -c docker-compose-swarm.yml erwindev"
```
If ssh to the instances and perform `docker ps`, you will see the instances that are running in those machines.

* Accessing the application
To access the application, you can either go to http://<ip address of college01/college02>.  

* Install a lighweight container management UI
To view all of your container and services in a nice looking user interface, we will install [Portainer](http://portainer.io).
The first thing you will need to do is ssh to college01 and install Portainer as a service.

```
$ docker-machine ssh college01
docker@college01:~$ docker service create \
    --name portainer \
    --publish 9000:9000 \
    --constraint 'node.role == manager' \
    --mount type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock \
    portainer/portainer \
    -H unix:///var/run/docker.sock
```
You should be able to pull up Portainer at http://<IP of college01>:9000

* Cleaning up
```
$ docker-machine ssh college01 "docker stack rm erwindev"
```
