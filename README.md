# Dockerized GitHub Self-Hosted Runner

This repository provides a **custom GitHub Actions self-hosted runner** packaged in a Docker container. It is designed to simplify the process of running CI/CD pipelines with GitHub Actions on your own infrastructure.

## Features

- Fully isolated **self-hosted runner** using Docker.
- Easy configuration using environment variables.
- Supports deployment of Dockerized applications directly from GitHub Actions.
- Compatible with private and public repositories.

## Prerequisites

1. **Docker** installed on your server or development machine.
2. A valid **GitHub Actions runner token**. You can generate it from:
   - Repository Settings → Actions → Runners → Add Runner.
3. Optional: Access credentials for container registries (e.g., Docker Hub, GitHub Container Registry).

## Usage
### 1. Clone the Repository
```bash
git clone https://github.com/<your-username>/<repository-name>.git
cd <repository-name>
```

### 2. Build the Docker Image
```bash
docker build -t custom-github-runner .
```

### 3. Run the Runner
```bash
docker run -d --name github-runner \
    -e REPO_URL="https://github.com/<username>/<repository>" \
    -e RUNNER_TOKEN="<your_runner_token>" \
    -e RUNNER_NAME="custom-runner" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    custom-github-runner
```
