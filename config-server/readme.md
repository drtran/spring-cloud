# An exercise project 

## Run with Openshift

Assuming that you were successfully deployed the discovery-service on openshift. You then can locate the service endpoint of the discovery server, then run your config server instance using that service endpoint as follows:

```
oc describe routers/discovery-server-x-xxxxx | grep "Requested Host"
./mvnw -Dport=8888 -Deureka.server=http://discovery-server-1-ktrt7-myproject.192.168.1.63.nip.io/eureka -Dgit.repo=https://github.com/drtran/scf-config-repository.git spring-boot:run
```

## Docker Image Build

The following steps build the discovery-server executable, build a docker image, test the image, label it and then push it up to the docker hub. Note that if you build config-server with mvnw command, it will try to contact the discovery server. If you don't have the server running, you would get an exception and you can ignore it. However, you can pass in -Deureka.server=abc property for a working discovery, you can avoid that exception.

1. run `./mvnw clean package` or `./mvnw -Deureka.server=http://discovery-server-1-ktrt7-myproject.192.168.1.63.nip.io/eureka clean package`
2. run `sudo docker build --build-arg JAR_FILE=target/config-server-0.0.1.jar -t config-server:latest .`
3. run `sudo docker run -e PORT_NO=8888 -e PROFILE=default -e EUREKA_SERVER=http://discovery-server-1-ktrt7-myproject.192.168.1.63.nip.io/eureka -e GIT_REPO=https://github.com/drtran/scf-config-repository.git -p 8888:8888 config-server:latest`
4. run `sudo docker tag config-server:latest drtran/config-server:latest`
5. run `sudo docker push drtran/config-server:latest`

## Openshift Launch

Make sure your openshift runs (i.e. `sudo ./oc cluster up`

1. run `oc login -u system:admin`
2. run `oc import-image drtran/config-server --from drtran/config-server --insecure --confirm=true --all=true`
3. run `oc adm policy add-scc-to-user anyuid -z default`
4. run `oc login -u developer -p developer`
5. run `oc new-app --name=config-server -e PORT_NO=8888 -e PROFILE=default -e EUREKA_SERVER=http://discovery-server-1-ktrt7-myproject.192.168.1.63.nip.io/eureka -e GIT_REPO=https://github.com/drtran/scf-config-repository.git drtran/config-server`
6. run `oc logs -f pods/config-server-x-xxxxx`
7. run `oc expose --name=config-server --port 8888 pods config-server-x-xxxxx`
8. run `oc expose svc config-server`
9. run `oc describe route config-server | grep "Requested Host"`
10. run `oc get all -o name` - my result looks like this:

```

deploymentconfigs/config-server
deploymentconfigs/discovery-server
imagestreams/config-server
imagestreams/discovery-server
routes/config-server
routes/discovery-server-1-ktrt7
pods/config-server-1-4hzv4
pods/discovery-server-1-ktrt7
replicationcontrollers/config-server-1
replicationcontrollers/discovery-server-1
services/config-server
services/discovery-server-1-ktrt7


```

## Getting configuration:

```

http://localhost:8888/config-client-app/default
http://localhost:8888/config-client-app/prod
http://localhost:8888/config-client-app.properties

```











