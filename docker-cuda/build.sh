#/bin/bash
  
export BASE_NAME="distributions"
export DISTRIBUTION="ubi8"
export CUDA_VERSION="10.2"

export PROJECT_NAME=docker-cuda
export REPO_BASE=forwardmeasure
export DIST_BASE_DIR=${BASE_NAME}/${DISTRIBUTION}/${CUDA_VERSION}

export BASE_IMAGE_DIR=${DIST_BASE_DIR}/base
export RUNTIME_IMAGE_DIR=${DIST_BASE_DIR}/runtime
export DEVEL_IMAGE_DIR=${DIST_BASE_DIR}/devel
export DEVEL_FULL_IMAGE_DIR=${DIST_BASE_DIR}/devel_full

export BASE_IMAGE_NAME=${REPO_BASE}/${PROJECT_NAME}-base
export RUNTIME_IMAGE_NAME=${REPO_BASE}/${PROJECT_NAME}-runtime
export DEVEL_IMAGE_NAME=${REPO_BASE}/${PROJECT_NAME}-devel
export DEVEL_FULL_IMAGE_NAME=${REPO_BASE}/${PROJECT_NAME}-devel-full

export TAG=${CUDA_VERSION}-${DISTRIBUTION}

docker build -t "${BASE_IMAGE_NAME}:${TAG}" "${BASE_IMAGE_DIR}"
docker push "${BASE_IMAGE_NAME}:${TAG}"

docker build -t "${RUNTIME_IMAGE_NAME}:${TAG}" \
		     --build-arg BASE_IMAGE_NAME="${BASE_IMAGE_NAME}:${TAG}" "${RUNTIME_IMAGE_DIR}"
docker push "${RUNTIME_IMAGE_NAME}:${TAG}"

docker build -t "${DEVEL_IMAGE_NAME}:${TAG}"\
			 --build-arg BASE_IMAGE_NAME="${RUNTIME_IMAGE_NAME}:${TAG}" "${DEVEL_IMAGE_DIR}"
docker push "${DEVEL_IMAGE_NAME}:${TAG}"

docker build -t "${DEVEL_FULL_IMAGE_NAME}:${TAG}" "${DEVEL_FULL_IMAGE_DIR}"
docker push "${DEVEL_FULL_IMAGE_NAME}:${TAG}"
