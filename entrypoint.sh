#!/bin/bash

set -e

if [[ -z "$REPO_URL" || -z "$RUNNER_TOKEN" || -z "$RUNNER_NAME" ]]; then
    echo "Error: REPO_URL, RUNNER_TOKEN, and RUNNER_NAME variables must be defined."
    exit 1
fi

if [ ! -f ".runner" ]; then
    ./config.sh --unattended --replace \
        --name "${RUNNER_NAME}" \
        --url "${REPO_URL}" \
        --token "${RUNNER_TOKEN}"
fi

exec ./run.sh
