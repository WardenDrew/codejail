#!/bin/bash

declare -a ref_dirs;

while [ $# -gt 0 ]; do
  case "$1" in
    --ref=*)
      ref_path=$(echo "${1#*=}" | cut -d: -f1);
      ref_name=$(echo "${1#*=}" | cut -d: -f2);
      if [[ -z "$ref_path" ]]; then
        echo "Malformed --ref could not determine path!";
        exit -1;
      fi
      if [[ -z "$ref_name" ]]; then
        echo "Malformed --ref could not determine name!";
        exit -1;
      fi

      ref_path=$(realpath "$ref_path");
      if [ ! -e "$ref_path" ]; then
        echo "--ref path does not exist!";
        exit -1;
      fi
      
      echo "Mounting ${ref_path} readonly at ~/ref/${ref_name}";
      ref_dirs+=(--mount "type=bind,src=${ref_path},dst=/home/codejail/ref/${ref_name},ro");
      ref_path=
      ref_name=
      ;;
    esac
  shift;
done

# Ensure codex config dir on host is created as the current user so the docker
# subsystem doesnt create it as root
mkdir -p ~/.codex;

docker build \
  --build-arg USER_ID=$(id -u) \
  --build-arg GROUP_ID=$(id -g) \
  -t localhost/codejail \
  -f ~/codejail/Dockerfile \
  ~/codejail;

docker run \
  --rm \
  -it \
  --name codejail \
  -u $(id -u):$(id -g) \
  -v ~/.codex:/home/codejail/.codex \
  -v ${PWD}:/home/codejail/cell \
  "${ref_dirs[@]}" \
  localhost/codejail \
  bash;
