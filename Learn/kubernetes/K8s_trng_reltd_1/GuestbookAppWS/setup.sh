sudo kubectl create -f redis-master-deployment.yaml
sudo kubectl create -f redis-master-service.yaml
sudo kubectl create -f redis-slave-deployment.yaml
sudo kubectl create -f redis-slave-service.yaml
sudo kubectl create -f frontend-deployment.yaml
sudo kubectl create -f frontend-service.yaml
