# Spring Cloud Config Client app

This application uses configuration services provided by the config-server. See config-server project for more detail on how to run it as a stand-alone, a docker instance, or an Openshift application.

The deployment of the config-server is located at this url `config-server-myproject.192.168.1.63.nip.io`

## Essential commands

To use this project effectively, consider using the following scripts:

### Run locally using Maven:

We need `PORT` and `EUREKA_SERVER` variables defined for this service to run

```
export PORT=8282

export EUREKA_SERVER=http://discovery-server-myproject.192.168.1.63.nip.io/eureka

./mvnw clean spring-boot:run
```
You can visit the following URLs:

```
http://192.168.1.63:8181
http://192.168.1.63:8181/v2/api-docs
http://192.168.1.63:8181/swagger-ui.html

```
 
---

## Docker Imange Build

The following steps build the discovery-server executable, build a docker image, test the image, label it and then push it up to the docker hub.

1. run `./mvnw clean package`
2. run `sudo docker build --build-arg JAR_FILE=target/config-server-0.0.1.jar -t discovery-server:latest .`
3. run `sudo docker run -it -p 8761:8761 discovery-server:latest`
4. run `sudo docker tag discovery-server:latest drtran/discovery-server:latest`
5. run `sudo docker push drtran/discovery-server:latest`

## Openshift Launch

Make sure your openshift runs (i.e. `sudo ./oc cluster up`

1. run `oc login -u system:admin`
2. run `oc import-image drtran/discovery-server --from drtran/discovery-image --insecure --confirm=true --all=true`
3. run `oc adm policy add-scc-to-user anyuid -z default`
4. run `oc login -u developer -p developer`
5. run `oc new-app drtran/discovery-server`
6. run `oc logs -f pods/discovery-server-x-xxxxx`
7. run `oc expose --port 8761 pods discovery-server-x-xxxxx`
8. run `oc expose svc discovery-server-x-xxxxx`
9. run `oc describe route discovery-server-x-xxxxx`
10. run `oc get all -o name` - my result looks like this:

```

deploymentconfigs/discovery-server
imagestreams/discovery-server
routes/discovery-server-1-8pfk4
pods/discovery-server-1-8pfk4
replicationcontrollers/discovery-server-1
services/discovery-server-1-8pfk4

```














