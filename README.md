# DotNet API running on Minikube Example

This solution contains a dotnet API running in Minikube.

### Prerequisites

Before we dive into the steps involved in deploying a .NET API to Minikube, there are a few prerequisites that you should have in place:

- [Docker](https://www.docker.com/): You will need to have Docker installed on your local machine. Docker is a platform that enables developers to build, package, and deploy applications in containers.

- [Kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl): The Kubernetes command-line tool, kubectl, allows you to run commands against Kubernetes clusters.

- [.NET 7](https://dotnet.microsoft.com/en-us/download/dotnet/7.0): You will need to have the .NET 7 SDK installed on your local machine.

- [Minikube](https://minikube.sigs.k8s.io/docs/start/): You should have Minikube installed on your local machine. Minikube is a lightweight Kubernetes implementation that enables developers to run a single-node Kubernetes cluster on their local machine.

## Getting Started (Quick Version)

Open up PowerShell and navigate to the **simple-minikube-dotnet-example** folder.

Make sure minikube is started by running: 

```
minikube start
``` 

Then run:

```
.\build.ps1
``` 

If successful then you should be given URL. Copy and paste this URL browser of a API request tool and don't forget to add the API route *"/weatherforecast"*. 

For example if the URL was **http://127.0.0.1:59148** then use **http://127.0.0.1:59148/weatherforecast**.


## Steps

### Step 1: Create a .NET API

The first step in deploying a .NET API to Minikube is to create the API itself. You can use Visual Studio or the .NET CLI to create a new .NET API project. For this example, we will use the .NET CLI. Open a command prompt or terminal window and run the following command:

```
dotnet new webapi -n MyApi
``` 

This command creates a new .NET API project named MyApi. You can open this project in your favorite code editor and modify it to suit your needs.

### Step 2: Start Minikube

The next step is to start Minikube. To do this, open a command prompt or terminal window and run the following command:

```
minikube start
```

This command starts a single-node Kubernetes cluster using the default configuration.

### Step 3: Containerize the .NET API

Once you have created your .NET API, the next step is to containerize it using Docker. To do this, create a Dockerfile in the root directory of your .NET API project with the following contents:

```
FROM mcr.microsoft.com/dotnet/sdk:7.0-alpine AS build-env
WORKDIR /app

COPY . ./
RUN dotnet restore
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:7.0-alpine
WORKDIR /app
COPY --from=build-env /app/out .

ENTRYPOINT ["dotnet", "MyApi.dll"]
```

To build the Docker image and prove the docker file is correct, run the following command from the root directory of your .NET API project:

```
docker build -t myapi:latest .
```

This command builds the Docker image and tags it as myapi:latest.

To make the image available for minikube run the following command and then run the previous command in the same shell window.

```
minikube -p minikube docker-env --shell powershell | Invoke-Expression
```

### Step 4: Deploy the .NET API to Minikube

To deploy the .NET API to Minikube, you need to create a Kubernetes deployment manifest. Create a file named deployment.yaml in the root directory of your .NET API project with the following contents:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapi
spec:
  selector:
    matchLabels:
      app: myapi
  replicas: 1
  template:
    metadata:
      labels:
        app: myapi
    spec:
      containers:
      - name: myapi
        image: myapi:latest
        ports:
        - containerPort: 80
```

This manifest specifies a deployment named myapi that runs one replica of the myapi container, which was built in step 3. The container listens on port 80.

To deploy the API to Minikube, run the following command:

```
kubectl apply -f deployment.yaml
```

This command creates a deployment named myapi and starts a single replica of the myapi container.

### Step 5: Expose the .NET API

To expose the .NET API to the outside world, you need to create a Kubernetes service. Create a file named service.yaml in the root directory of your .NET API project with the following contents:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: myapi
spec:
  selector:
    app: myapi
  ports:
  - name: http
    port: 80
    targetPort: 80
  type: NodePort
```

This manifest specifies a service named myapi that selects the myapi deployment using the app label. The service exposes port 80 and maps it to port 80 of the myapi container. It also exposes the service on a NodePort, which makes it accessible from outside the Kubernetes cluster.

To create the service, run the following command:

```
kubectl apply -f service.yaml
```

This command creates a service named myapi and maps port 80 of the myapi container to a randomly generated NodePort.

### Step 6: Test the .NET API

To test the .NET API, Minikube a command that set's up a tunnel so you can hit your service/API. Run the following command to get the URL:

```
minikube service myapi 
```

If successful then you should be given URL. Copy and paste this URL browser of a API request tool and don't forget to add the API route *"/weatherforecast"*. 

For example if the URL was **http://127.0.0.1:59148** then use **http://127.0.0.1:59148/weatherforecast**. 