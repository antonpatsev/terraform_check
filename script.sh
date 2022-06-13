#!/usr/bin/env bash

set -o nounset   # fail if var undefined
set -o noclobber # don't overwrite exists files via >
set -o pipefail  # fails if pipes (|) fails
set -o errexit   # exit on error
#set -o xtrace  # debug

declare -a DIRS=("2" "3" "4")

error=0
for DIR in "${DIRS[@]}";
do
  echo "Checking $DIR"
  set +e
  fmt_output=$(terraform fmt -list=true -recursive -check -no-color $DIR 2>&1)
  fmt_code=$?
  set -e

  if [ $fmt_code -ne 0 ]; then
    error=1
    echo $fmt_output
  fi
done

if [ $error -ne 0 ]; then
  exit 1
fi
