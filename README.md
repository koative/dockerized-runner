
# Dockerized GitHub Self-Hosted Runner

This repository provides a **custom GitHub Actions self-hosted runner** packaged in a Docker container. It is designed to simplify the process of running CI/CD pipelines with GitHub Actions on your own infrastructure.

## Features

- Fully isolated **self-hosted runner** using Docker.
- Easy configuration using environment variables.
- Supports deployment of Dockerized applications directly from GitHub Actions.
- Compatible with private and public repositories.
- Scalable for multiple repositories and workflows.

---

## Prerequisites

1. **Docker** installed on your server or development machine.
2. A valid **GitHub Actions runner token**. You can generate it from:
   - Repository Settings → Actions → Runners → Add Runner.
3. Optional: Access credentials for container registries (e.g., Docker Hub, GitHub Container Registry).

---

## Usage

### 1. Clone the Repository

```bash
git clone https://github.com/koative/dockerized-runner.git
cd dockerized-runner
```

### 2. Build the Docker Image

```bash
docker build -t custom-github-runner .
```

### 3. Run the Runner

Run the container with the required environment variables:

```bash
docker run -d --name github-runner \
    -e REPO_URL="https://github.com/<username>/<repository>" \
    -e RUNNER_TOKEN="<your_runner_token>" \
    -e RUNNER_NAME="custom-runner" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    custom-github-runner
```

Replace the following:
- `<username>/<repository>`: Your GitHub repository URL.
- `<your_runner_token>`: The token obtained from GitHub.
- `custom-runner`: A name for your runner.

---

## Environment Variables

| Variable        | Description                                      | Required |
|------------------|--------------------------------------------------|----------|
| `REPO_URL`      | URL of the GitHub repository.                    | Yes      |
| `RUNNER_TOKEN`  | GitHub Actions token for the self-hosted runner. | Yes      |
| `RUNNER_NAME`   | Name for the runner instance.                    | Yes      |

---

## Updating the Runner

To update the runner or rebuild the container with a newer GitHub Actions Runner version:

1. Update the `Dockerfile` with the latest version:
   ```bash
   RUN curl -o actions-runner-linux-x64.tar.gz -L https://github.com/actions/runner/releases/download/v2.x.x/actions-runner-linux-x64-2.x.x.tar.gz
   ```
   Replace `2.x.x` with the desired version.

2. Rebuild the image:
   ```bash
   docker build -t custom-github-runner .
   ```

3. Restart the container:
   ```bash
   docker stop github-runner
   docker rm github-runner
   docker run -d --name github-runner <your-docker-run-command>
   ```

---

## Troubleshooting

### Common Issues

1. **Missing Environment Variables**:
   If the runner fails to start, ensure all required environment variables are provided. For example:
   ```bash
   Error: REPO_URL, RUNNER_TOKEN, and RUNNER_NAME variables must be defined.
   ```

2. **Token Expired**:
   If your runner stops working due to an expired token, generate a new token from GitHub and restart the container with the updated token.

3. **Logs**:
   Check the container logs to debug issues:
   ```bash
   docker logs github-runner
   ```

4. **Docker Access Issues**:
   Ensure the container has access to the Docker socket by correctly mounting `/var/run/docker.sock`.

---

## Example Workflow

Here is an example GitHub Actions workflow to build and deploy a Dockerized application using this runner:

```yaml
name: Build and Deploy

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: self-hosted

    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Build Docker Image
        run: |
          docker build -t my-app:latest .

      - name: Push to Docker Hub
        env:
          DOCKER_USERNAME: ${{ secrets.DOCKER_USERNAME }}
          DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
        run: |
          echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
          docker tag my-app:latest my-dockerhub-username/my-app:latest
          docker push my-dockerhub-username/my-app:latest

      - name: Deploy Application
        run: |
          docker pull my-dockerhub-username/my-app:latest
          docker stop my-app || true
          docker rm my-app || true
          docker run -d --name my-app -p 80:80 my-dockerhub-username/my-app:latest
```

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.