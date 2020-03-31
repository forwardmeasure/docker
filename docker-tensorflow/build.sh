#!/bin/bash -x

export SCRIPTS_DIR="$( cd "$( echo "${BASH_SOURCE[0]%/*}/" )"; pwd )"

export BASE_NAME="distributions"
export DISTRIBUTION="ubi8"
export CUDA_VERSION="10.2"

export PROJECT_NAME=docker-devlibs
export REPO_BASE=forwardmeasure
export BUILD_IMAGE_DIR=${SCRIPTS_DIR}/distributions/${DISTRIBUTION}

#export BASE_IMAGE_NAME=forwardmeasure/docker-cuda-devel
export BASE_IMAGE_NAME=forwardmeasure/docker-cuda-devel-full
export BASE_IMAGE_TAG=${CUDA_VERSION}-${DISTRIBUTION}

export IMAGE_NAME=${REPO_BASE}/${PROJECT_NAME}
export TAG=${CUDA_VERSION}-${DISTRIBUTION}
export BASE_IMAGE_TAG=${CUDA_VERSION}-${DISTRIBUTION}

docker build -t ${IMAGE_NAME}:${TAG} \
		     --build-arg BASE_IMAGE_NAME=${BASE_IMAGE_NAME}:${BASE_IMAGE_TAG} \
             -f ${BUILD_IMAGE_DIR}/Dockerfile .

ret=$?
echo "Result of docker build command = $ret"

if [[ $ret -eq 0 ]]
then
	# docker push ${IMAGE_NAME}:${TAG}
	echo "Done"
fi
