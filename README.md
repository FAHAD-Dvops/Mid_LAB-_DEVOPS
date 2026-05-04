# DevOps Pipeline for Laravel/PHP Web Application

## Project Structure
```
DEVOPS_LAB/
├── frontend/
│   └── index.html
├── backend/
│   ├── app.py
│   └── requirements.txt
├── docker/
│   ├── Dockerfile
│   └── docker-compose.yml
├── kubernetes/
│   ├── deployment.yaml
│   └── service.yaml
├── terraform/
│   ├── main.tf
│   └── variables.tf
├── jenkins/
│   └── Jenkinsfile
└── .gitignore
```

## Quick Start

### 1. Running Locally
```bash
cd backend
pip install -r requirements.txt
ENVIRONMENT=development python app.py
```

### 2. Docker Setup
```bash
docker-compose up --build
```

### 3. Kubernetes Deployment
```bash
kubectl apply -f kubernetes/
```

### 4. Terraform Deploy (AWS)
```bash
cd terraform
terraform init
terraform plan
terraform apply
```
# Mid_LAB-_DEVOPS
