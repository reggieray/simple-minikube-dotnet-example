Write-Host "1. Connect to minikube docker env..." -ForegroundColor Green
minikube -p minikube docker-env --shell powershell | Invoke-Expression

Write-Host "2. Building docker image..." -ForegroundColor Green
docker build .\MyApi -t myapi:latest -f MyApi/Dockerfile

Write-Host "3. Creating deployment..." -ForegroundColor Green
kubectl apply -f deployment.yaml

Write-Host "4. Creating service to expose API..." -ForegroundColor Green
kubectl apply -f service.yaml

Write-Host "5. Starting tunnel to service..." -ForegroundColor Green
minikube service myapi 