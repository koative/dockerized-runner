FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    curl \
    git \
    tar \
    jq \
    sudo && \
    apt-get clean

RUN useradd -m github && \
    echo "github ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR /home/github

RUN curl -o actions-runner-linux-x64-2.320.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.320.0/actions-runner-linux-x64-2.320.0.tar.gz && \
tar xzf ./actions-runner-linux-x64-2.320.0.tar.gz && \
    rm actions-runner-linux-x64.tar.gz

RUN chown -R github:github /home/github

USER github

COPY entrypoint.sh /home/github/entrypoint.sh
RUN chmod +x /home/github/entrypoint.sh

ENTRYPOINT ["/home/github/entrypoint.sh"]
