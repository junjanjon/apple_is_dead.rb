#!/usr/bin/env bash -xe

set -e

NOW=`date +%Y/%m/%d_%H:%M`
ruby apple_is_dead.rb

set +e
git diff --exit-code --quiet
if [[ $? -eq 0 ]]; then exit; fi

git add .
git commit -m "diff commit ${NOW}"
