# GitHub/GitLab Setup Guide

## Step 1: Initialize Git Repository Locally

```bash
cd /Users/judas/Downloads/DEVOPS_LAB
git init
```

## Step 2: Configure Git User (if not already configured)

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## Step 3: Add All Files to Staging

```bash
git add .
```

## Step 4: Create Initial Commit

```bash
git commit -m "Initial commit: DevOps pipeline setup with frontend, backend, Docker, Kubernetes, Jenkins, and Terraform"
```

## Step 5: Create Main Branch (if not default)

```bash
git branch -M main
```

## Step 6: Create Development Branch

```bash
git branch dev
git checkout dev
```

## Step 7: Create GitHub/GitLab Repository

### For GitHub:
1. Go to https://github.com/new
2. Create a new repository named `devops-pipeline`
3. Do NOT initialize with README, .gitignore, or license
4. Click "Create repository"

### For GitLab:
1. Go to https://gitlab.com/projects/new
2. Create a new project named `devops-pipeline`
3. Do NOT initialize with README or .gitignore
4. Click "Create project"

## Step 8: Add Remote Origin

**For GitHub:**
```bash
git remote add origin https://github.com/YOUR_USERNAME/devops-pipeline.git
```

**For GitLab:**
```bash
git remote add origin https://gitlab.com/YOUR_USERNAME/devops-pipeline.git
```

## Step 9: Push Main Branch

```bash
git push -u origin main
```

## Step 10: Push Development Branch

```bash
git checkout dev
git push -u origin dev
```

## Step 11: Verify Branches

```bash
git branch -a
```

You should see:
```
  dev
  main
  remotes/origin/dev
  remotes/origin/main
```

---

## File Structure in Repository

```
devops-pipeline/
├── .gitignore                 ✅ Already created
├── README.md                  ✅ Already created
├── Dockerfile                 ✅ Already created
├── docker-compose.yml         ✅ Already created
├── nginx.conf                 ✅ Already created
├── frontend/
│   └── index.html             ✅ Already created
├── backend/
│   ├── app.py                 ✅ Already created
│   └── requirements.txt        ✅ Already created
├── kubernetes/
│   ├── deployment.yaml        ✅ Already created
│   └── service.yaml           ✅ Already created
├── terraform/
│   ├── main.tf                ✅ Already created
│   ├── variables.tf           ✅ Already created
│   └── user_data.sh           ✅ Already created
└── jenkins/
    └── Jenkinsfile            ✅ Already created
```

---

## Branching Strategy

### Main Branch
- Production-ready code
- Only merge from Release/Hotfix branches
- Protected branch (require pull requests)

### Development Branch
- Development environment
- Integration point for features
- All feature branches merge here

### Feature Branches (Optional)
```bash
git checkout -b feature/new-feature dev
# Make changes
git push origin feature/new-feature
# Create Pull Request on GitHub/GitLab
```

---

## Commands Summary

```bash
# Initialize and setup
cd /Users/judas/Downloads/DEVOPS_LAB
git init
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# Stage and commit
git add .
git commit -m "Initial commit: DevOps pipeline setup"

# Create branches
git branch -M main
git branch dev

# Add remote
git remote add origin https://github.com/YOUR_USERNAME/devops-pipeline.git

# Push branches
git push -u origin main
git checkout dev
git push -u origin dev

# Verify
git branch -a
```

---

## Next Steps

After completing GitHub/GitLab setup:
1. ✅ Repository created with main and dev branches
2. ✅ All code pushed to remote
3. ✅ .gitignore configured
4. Ready for **Task 2: Docker Setup**
