# Node App - CI/CD Workflow

This repository contains a simple Node.js application along with a CI/CD workflow that builds, deploys, and monitors the application using various DevOps tools. The workflow automates the process of building a Docker image, deploying it using Helm on Minikube, and managing deployments with Argo CD. **The repository aims to showcase the capabilities of various DevOps tools by integrating them seamlessly to achieve CI/CD.** 

## Technologies Used

- **GitHub Actions**: Automates the CI/CD process and provides an ubuntu machine to mimic local setup
- **Docker**: Containerizes the Node.js application using a Dockerfile
- **Minikube**: Runs a local Kubernetes cluster for testing and displaying logs
- **Helm**: Manages Kubernetes application deployment
- **Argo CD**: Continuous delivery tool for Kubernetes to implement gitOps

## CLI Tools Used

- **docker**: Simply used to build the image with desired tag
- **minikube,kubectl**: CLI tool for Kubernetes cluster management and operations
- **Bash**: Many tasks are programatically automated in the workflow using bash
- **jsonpath**: It's a query language compatible with the kubectl outputs and is really useful for extracting cluster/resource info
- **argocd CLI**: Used to create an application as per desired configuration without creating a manifest file for it

## Workflow Overview

The GitHub Actions workflow `build-and-run.yaml` performs the following steps:

### 1. Checkout Repository
The repository is checked out with full history to ensure the correct branch updates.
```
- name: Check out repository
  uses: actions/checkout@v4
  with:
    fetch-depth: 0
```

### 2. Generate Image Tag
A unique Docker image tag is generated using the commit SHA:
```
IMAGE_TAG="${{ github.sha }}"
IMAGE_NAME="$DOCKER_IMAGE_NAME:$IMAGE_TAG"
```
### 3. Install Minikube and Load Docker Image
- **Minikube** is installed using the `medyagh/setup-minikube`, more on that on [my blog post](https://dev.to/cloud-sky-ops/running-minikube-in-github-workflow-a-step-by-step-guide-p40)
- The built image is loaded into Minikube for deployment using `minikube image load` command

### 4. Installation and Utilization of other Tools
- **Helm** is installed and tested via the template command.

**Output:**

  ![image](https://github.com/user-attachments/assets/73dfa4b4-d65e-4ea0-86cb-e7a8d2b7203b)

- **Argo CD** is installed and `port-forwarded to localhost:8080 in detached mode` after all pods in argocd namespace are in running state. The **Argo CD CLI** is installed for automating app creation in argocd.

**Output:**

![image](https://github.com/user-attachments/assets/586e52b6-e9b8-4d85-8d39-e753ad2658fa)

![image](https://github.com/user-attachments/assets/7091eae4-d47d-483e-affd-5cd748ded17c)

### 5. Update Image Tag in Helm Chart
- The image tag is updated in-place in `values.yaml` and `Chart.yaml` using `sed` with extended regex evaluation:
```
sed -i -E "s/(tag: \")([a-z0-9]*)(\")/tag: \"${{ env.IMAGE_TAG }}\"/" node-app-helm/values.yaml
sed -i -E "s/(appVersion: \")([a-z0-9.]*)(\")/appVersion: \"${{ env.IMAGE_TAG }}\"/" node-app-helm/Chart.yaml
```
- The updates are committed and pushed directly to the `main` branch using SSH authentication.

**This commit change would look like:**

![image](https://github.com/user-attachments/assets/2d14f70e-b201-4974-ada8-eba9f9a3c21f)

### 6. Validate Deployment
- The workflow waits until all pods are in a `Running` state before proceeding.
- The application status is verified using `kubectl` commands.
- Pod logs are captured and printed in the console.

**Output:**

![image](https://github.com/user-attachments/assets/fe297aa1-2984-4cbf-9bbf-26e7bab9afeb)
![image](https://github.com/user-attachments/assets/5d294d69-b157-4bc2-b97a-aa4b916c1f71)

## Conclusion
This setup provides a seamless CI/CD pipeline for deploying a Node.js application in Kubernetes. By integrating GitHub Actions, Docker, Helm, Minikube, and Argo CD, this workflow depicts a POC of real-world automation of a simple build, deploy, and monitoring process.
