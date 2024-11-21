FROM debian:bookworm

# Install necessary packages 
RUN apt-get update && apt-get install -y \
    curl \
    git \
    tar \
    jq \
    sudo \
    libicu-dev \
    libkrb5-3 \
    zlib1g && \
    apt-get clean

# Create a new user for the runner
RUN useradd -m github && \
    echo "github ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set the working directory
WORKDIR /home/github

# Download and extract GitHub Actions Runner
RUN curl -o actions-runner-linux-x64-2.320.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.320.0/actions-runner-linux-x64-2.320.0.tar.gz && \
    tar xzf ./actions-runner-linux-x64-2.320.0.tar.gz && \
    rm actions-runner-linux-x64-2.320.0.tar.gz

# Set ownership for the GitHub user
RUN chown -R github:github /home/github

# Switch to root user for file operations
USER root

# Copy the entrypoint script and set executable permissions
COPY entrypoint.sh /home/github/entrypoint.sh
RUN chmod +x /home/github/entrypoint.sh

# Switch back to the GitHub user
USER github

# Set the entrypoint
ENTRYPOINT ["/home/github/entrypoint.sh"]
