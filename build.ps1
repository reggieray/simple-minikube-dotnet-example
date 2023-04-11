# point shell to minikube's docker-daemon
minikube -p minikube docker-env --shell powershell | Invoke-Expression

# build docker image 
docker build .\MyApi -t myapi:latest -f MyApi/Dockerfile

# create deployment
kubectl apply -f deployment.yaml

# create service exposing api
kubectl apply -f service.yaml

# create tunnel for service
minikube service myapi 