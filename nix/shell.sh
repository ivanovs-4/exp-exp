#!/usr/bin/env bash
set -e

GIT_HASH=$(git rev-parse HEAD)
tag=$(git tag -l --points-at HEAD)
if [ ! -z $tag ]; then
  GIT_TAG_ARG="--arg gitTag \"\\\"$tag\\\"\""
fi
GIT_BRANCH=$(git branch | grep \* | cut -d ' ' -f2)

set -x
NIX_PATH=$GIT_NIX_PATH$NIX_PATH nix-shell --command "cd ../; return" \
  --arg gitHash "\"$GIT_HASH\"" \
  $GIT_TAG_ARG \
  --arg gitBranch "\"$GIT_BRANCH\"" \
  "$@"
