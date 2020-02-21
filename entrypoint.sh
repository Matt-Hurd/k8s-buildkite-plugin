#!/bin/bash
set -xeuo pipefail

git config --global credential.helper "store --file=/secrets/git-credentials"

if [[ -f /secrets/ssh-key ]]; then
  eval "$(ssh-agent -s)"
  ssh-add -k /secrets/ssh-key
fi

if [[ -d /local ]]; then
  cp /usr/local/bin/buildkite-agent /local/
fi

gcloud container clusters get-credentials buildkite-agents --zone us-central1-b --project sigma-1330

exec /usr/local/bin/buildkite-agent "$@"
