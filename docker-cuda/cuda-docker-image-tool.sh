#!/usr/bin/env bash

function usage {
  cat <<EOF
Usage: $0 [options] [command]
Builds or pushes the built-in Spark Docker image.

Commands:
  build       Build image. Requires a repository address to be provided if the image will be
              pushed to a different registry.
  push        Push a pre-built image to a registry. Requires a repository address to be provided.

Options:
  -f file               Dockerfile to build.
  -b base image         The base Docker image to extend from.
  -r repo               Repository address.
  -t tag                Tag to apply to the built image, or to identify the image to be pushed.
  -n                    Build docker image with --no-cache
  -c context            The Docker build context.
  -b arg                Build arg to build or push the image. For multiple build args, this option needs to
                        be used separately for each build arg.

Using minikube when building images will do so directly into minikube's Docker daemon.
There is no need to push the images into minikube in that case, they'll be automatically
available when running applications inside the minikube cluster.

Check the following documentation for more information on using the minikube Docker daemon:

  https://kubernetes.io/docs/getting-started-guides/minikube/#reusing-the-docker-daemon

Examples:
  - Build image in minikube with tag "testing"
    $0 -m -t testing build

  - Build PySpark docker image
    $0 -r docker.io/myrepo -t v2.3.0 -p kubernetes/dockerfiles/spark/bindings/python/Dockerfile build

  - Build and push image with tag "v2.3.0" to docker.io/myrepo
    $0 -r docker.io/myrepo -t v2.3.0 build
    $0 -r docker.io/myrepo -t v2.3.0 push
EOF
}

function error {
  echo "$@" 1>&2
  exit 1
}

function image_ref {
  local image="$1"
  local add_repo="${2:-1}"
  if [ $add_repo = 1 ] && [ -n "$REPO" ]; then
    image="$REPO/$image"
  fi
  if [ -n "$TAG" ]; then
    image="$image:$TAG"
  fi
  echo "$image"
}

function resolve_file {
  local FILE=$1
  if [ -n "$FILE" ]; then
    local DIR=$(dirname $FILE)
    DIR=$(cd $DIR && pwd)
    FILE="${DIR}/$(basename $FILE)"
  fi
  echo $FILE
}

function docker_push {
  local image_name="$1"
  if [ ! -z $(docker images -q "$(image_ref ${image_name})") ]; then
    docker push "$(image_ref ${image_name})"
    if [ $? -ne 0 ]; then
      error "Failed to push $image_name Docker image."
    fi
  else
    echo "$(image_ref ${image_name}) image not found. Skipping push for this image."
  fi
}

function build {
    local DOCKERFILE=$1
    local TAG=$2
    local BUILD_CONTEXT=$3

    local BUILD_ARGS=(${BUILD_PARAMS})

    (docker build $NOCACHEARG "${BUILD_ARGS[@]}" \
        -t "$TAG" \
        -f "$BUILD_CONTEXT"/"$DOCKERFILE" "$BUILD_CONTEXT")

    if [ $? -ne 0 ]; then
        error "Failed to build image, please refer to Docker build output for details."
    fi
}

function push {
    local DOCKERFILE=$1

    docker_push "$DOCKERFILE"
}

if [[ "$@" = *--help ]] || [[ "$@" = *-h ]]; then
  usage
  exit 0
fi

DOCKERFILE="Dockerfile"
REPO=
TAG=
NOCACHEARG=
BUILD_PARAMS=
BUILD_CONTEXT=

while getopts f:r:t:nb:c: option
do
 case "${option}"
 in
 f) DOCKERFILE=${OPTARG};;
 r) REPO=${OPTARG};;
 t) TAG=${OPTARG};;
 n) NOCACHEARG="--no-cache";;
 b) BUILD_PARAMS=${BUILD_PARAMS}" --build-arg "${OPTARG};;
 c) BUILD_CONTEXT=${OPTARG};;
 esac
done

    if [ -z "$DOCKERFILE" ]; then
      usage
      exit 1
    fi

    if [ -z "$TAG" ]; then
      usage
      exit 1
    fi

    if [ -z "$BUILD_CONTEXT" ]; then
      usage
      exit 1
    fi

case "${@: -1}" in
  build)
    build $DOCKERFILE $TAG $BUILD_CONTEXT
    ;;
  push)
    if [ -z "$REPO" ]; then
      usage
      exit 1
    fi
    push
    ;;
  *)
    usage
    exit 1
    ;;
esac