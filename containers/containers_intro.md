# Containers in a Nutshell

This lab will help you get oriented with Docker and why we are using it. 

## Docker Overview

- [Docker](https://www.docker.com/)
- [Docker Hub Registry](https://hub.docker.com/)
    - Images uploaded to this registry are maintained by the community and have no support from Docker directly.
- [Docker Store](https://store.docker.com/)
    - This link is only provided as a reference. More details on Docker Store can be found [here](https://docs.docker.com/docker-store/).
    - The Docker Store provides Docker Verified images (as well as access to Docker Hub images). These Docker Verified images are verified by Docker, have a high level of security, and generally subscribe to Docker best practices.
    - In an enterprise setting, this likely would be the route to choose (as depending on publisher) may include a paid support level.

"Docker provides a method of developing, shipping, and running applications. Docker provides the ability to package and run an application in a loosely isolated environment called a container. The isolation and security allow you to run many containers simultaneously on a given host. Containers are lightweight because they don’t need the extra load of a hypervisor, but run directly within the host machine’s kernel. This means you can run more containers on a given hardware combination than if you were using virtual machines. You can even run Docker containers within host machines that are actually virtual machines!" [Source](https://docs.docker.com/engine/docker-overview/)

In the context of Docker, an **image** is the binary file that contains your code, your code packages, and any system level dependencies. A **container** is an instance of an image. 

This will make more sense during the lab. Right now, it's important to note that at a high-level the following points are key takeaways for containers [Source](https://docs.docker.com/engine/docker-overview/#what-can-i-use-docker-for):

- Fast, consistent delivery of your applications
    - Work in standardized environments using local containers which provide your applications and services.
- Responsive deployment and scaling
    - Because of the portability and how lightweight Docker is, you can dynamically manage workloads, scale up/tear down services with ease in near real-time.
- Running more workloads on the same hardware
    - You can increase app density on the same hardware over hypervisor-based virtual machines, so you can use more of your compute capacity to achieve your business goals. Docker is perfect for high density environments and for small and medium deployments where you need to do more with fewer resources (e.g. the Raspberry Pi).

Let's get into it!

Docker project (open-sourced by dotCloud in March '13) consists of several main parts (applications) and elements (used by these parts) which are all [mostly] built on top of already existing functionality, libraries and frameworks offered by the Linux kernel and third-parties (e.g. LXC, device-mapper, aufs etc.).

### Main Docker Parts

- docker daemon: used to manage docker containers on the host it runs
- docker CLI: used to command and communicate with the docker daemon
- docker hub registry: a repository (public or private) for docker images
- docker store: a trusted repository of images maintained by docker or first-party developers

### Main Docker Elements

- docker containers: directories containing everything-your-application
- docker images: snapshots of containers or base OS (e.g. Ubuntu) images
- Dockerfiles: scripts automating the building process of images

### Installing Docker

We will install the **Docker Community Edition** on your host machine. You can download it here: [Docker Community Edition](https://www.docker.com/community-edition).

Verify successful installation by opening your host machine's shell and enter:

```
docker run hello-world
```

You will see some output similar to:

```
Hello from Docker!
This message shows that your installation appears to be working correctly.
...
```

You can search for images available on Docker Hub by using the docker command with the `search` subcommand. For example, to search for the Ubuntu image, type:

```
docker search ubuntu   
```

Alternatively, you can search on the [Docker Hub Registry](https://hub.docker.com/) website.

In the OFFICIAL column, OK indicates an image built and supported by the company behind the project. Once you've identified the image that you would like to use, you can download it to your computer using the `pull` subcommand, like so:

```
docker pull ubuntu
```

After an image has been downloaded, you may then run a container using the downloaded image with the `run` subcommand. If an image has not been downloaded when docker is executed with the `run` subcommand, the Docker client will first download the image, then run a container using it:

```bash
docker run ubuntu
```

To see the images that have been downloaded to your computer, type:

```
docker images
```

The output should look similar to the following:

```
Output
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ubuntu              latest              d355ed3537e9        7 days ago          120.8 MB
hello-world         latest              1815c82652c0        2 weeks ago         967 B
```

The `hello-world` container you ran in the previous is an example of a container that runs and exits, after emitting a test message. Containers, however, can be much more useful than that, and they can be interactive. After all, they are similar to virtual machines, only more resource-friendly.

As an example, let's run a container using the latest image of Ubuntu. The combination of the -i and -t switches gives you interactive shell access into the container:

```
docker run -it ubuntu
```

Your command prompt should change to reflect the fact that you're now working inside the container and should take this form:

```
root@33b7ca72ea69:/#
```

Important: Note the container id in the command prompt. In the above example, it is 33b7ca72ea69.

Now you may run any command inside the container. For example, let's update the package database inside the container. No need to prefix any command with sudo, because you're operating inside the container with root privileges:

```
container$: apt-get update
```

Then install any application in it. Let's install NodeJS, for example.

```
container$: apt-get install -y nodejs
```

This command pulled an [Ubuntu image from Docker Hub](https://hub.docker.com/_/ubuntu/). Docker uses a file called `Dockerfile` to describe how a Docker image should consist of, we'll see more of this later.

Exit the container:

```
container$: exit
```

### Building a Dockerfile

We will do this from scratch (following this [guide](https://docs.docker.com/get-started/part2/#define-a-container-with-a-dockerfile)).



## Setting up a Kubernetes (K8s) cluster

Most of the information in this lab is taken from [here](https://docs.microsoft.com/en-us/azure/container-service/kubernetes/container-service-kubernetes-walkthrough).

### Create resource group

```
az group create --name k8sTest --location eastus
```

### Create K8s cluster

```
az acs create --orchestrator-type kubernetes --resource-group k8sTest --name myK8sCluster --generate-ssh-keys
```

### Install K8s CLI if not installed

```
az acs kubernetes install-cli
```

**Note:** If you are running on Windows withim `cmd` or `PowerShell`, you may need to add the folder of where Kubernetes binary was installed to your path.

### Connect to K8s cluster

```
az acs kubernetes get-credentials --resource-group k8sTest --name myK8sCluster
```

### Show nodes

Find all the nodes within the cluster adn their statuses.

```
kubectl get nodes
```

Output: 

```
NAME                    STATUS                     AGE       VERSION
k8s-agent-e256a22c-0    Ready                      17m       v1.6.6
k8s-agent-e256a22c-1    Ready                      17m       v1.6.6
k8s-agent-e256a22c-2    Ready                      17m       v1.6.6
k8s-master-e256a22c-0   Ready,SchedulingDisabled   17m       v1.6.6
```

### View K8s UI via proxy

K8s has a full web UI that you can use to view and control your containers and nodes.

```
az acs kubernetes browse --resource-group k8sTest --name myK8sCluster
```

### Exploring K8s deployment with NGINX

Taken from [here](https://github.com/kubernetes/kubernetes/blob/master/examples/simple-nginx.md).

#### Running your first containers in Kubernetes

From this point onwards, it is assumed that `kubectl` is on your path from one of the getting started guides.

The [`kubectl run`](https://kubernetes.io/docs/user-guide/kubectl/kubectl_run.md) line below will create two [nginx](https://registry.hub.docker.com/_/nginx/) [pods](https://kubernetes.io/docs/user-guide/pods.md) listening on port 80. It will also create a [deployment](https://kubernetes.io/docs/user-guide/deployments.md) named `my-nginx` to ensure that there are always two pods running.

```bash
kubectl run my-nginx --image=nginx --replicas=2 --port=80
```

Once the pods are created, you can list them to see what is up and running:

```
kubectl get pods
```

You can also see the deployment that was created:

```
kubectl get deployment
```

#### Exposing your pods to the internet.

On some platforms (for example Azure) the kubectl command can integrate with your cloud provider to add a [public IP address](https://kubernetes.io/docs/user-guide/services.md#publishing-services---service-types) for the pods,
to do this run:

```
kubectl expose deployment my-nginx --port=80 --type=LoadBalancer
```

This should print the service that has been created, and map an external IP address to the service. Where to find this external IP address will depend on the environment you run in.  For instance, for Google Compute Engine the external IP address is listed as part of the newly created service and can be retrieved by running

```bash
kubectl get services
```

In order to access your nginx landing page, you also have to make sure that traffic from external IPs is allowed. Do this by opening a firewall to allow traffic on port 80.

#### Cleanup

To delete the two replicated containers, delete the deployment:

```bash
kubectl delete deployment my-nginx
```

#### Next: Configuration files

Most people will eventually want to use declarative configuration files for creating/modifying their applications.  A [simplified introduction](https://kubernetes.io/docs/user-guide/deploying-applications.md)
is given in a different document.

Save the following file as `azure-vote.yml`

```yaml
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: azure-vote-back
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: azure-vote-back
    spec:
      containers:
      - name: azure-vote-back
        image: redis
        ports:
        - containerPort: 6379
          name: redis
---
apiVersion: v1
kind: Service
metadata:
  name: azure-vote-back
spec:
  ports:
  - port: 6379
  selector:
    app: azure-vote-back
---
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: azure-vote-front
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: azure-vote-front
    spec:
      containers:
      - name: azure-vote-front
        image: microsoft/azure-vote-front:redis-v1
        ports:
        - containerPort: 80
        env:
        - name: REDIS
          value: "azure-vote-back"
---
apiVersion: v1
kind: Service
metadata:
  name: azure-vote-front
spec:
  type: LoadBalancer
  ports:
  - port: 80
  selector:
    app: azure-vote-front
```

Now you deploy the configuration file (an Azure vote app).

```
kubectl create -f azure-vote.yml
```

Output:

```
deployment "azure-vote-back" created
service "azure-vote-back" created
deployment "azure-vote-front" created
service "azure-vote-front" created
```

To monitor progress type:

```
kubectl get service azure-vote-front --watch
```

You can now browse to the external IP address to see the Azure Vote App.

![](https://docs.microsoft.com/en-us/azure/container-service/kubernetes/media/container-service-kubernetes-walkthrough/azure-vote.png)

## Delete the cluster

```
az group delete --name k8sTest --yes --no-wait
```

## Azure Container Instance (ACI) (preview - 9/6/17)

### Create a resource group

```
az group create --name aci_grp --location eastus
```

Here is an example of Azure Container Instance:

![](https://azurecomcdn.azureedge.net/mediahandler/acomblog/media/Default/blog/5f9c966d-1b84-4be1-8484-3b22ff325deb.gif)

### Deploy a NGINX container

Following command will ask for a load balancer with an externally reachable IP address.

```
az container create -g aci_grp --name nginx --image library/nginx --ip-address public
```

You'll have to wait until it's deployed, but you can check that with the following command. Copy/paste the IP address once the resource has entered the `ProvisioningState` of `Succeeded`.

```
az container show --name nginx --resource-group aci_grp -o table
```

You also can specify resources at time of creation:

```
az container create -g aci_grp --name nginx --image library/nginx --ip-address public –cpu 2 --memory 5
```

Another great project to check out if you're using ACI and K8s is: [ACI Connector for Kubernetes](https://github.com/azure/aci-connector-k8s)

Here is a demo of the ACI Connector for K8s:

![](https://azurecomcdn.azureedge.net/mediahandler/acomblog/media/Default/blog/ad5b4178-b792-4354-b3af-cb9e7de955ea.gif)