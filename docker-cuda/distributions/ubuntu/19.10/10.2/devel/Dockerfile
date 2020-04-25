ARG IMAGE_NAME
FROM ${IMAGE_NAME}:10.2-runtime-ubuntu18.04
LABEL maintainer "NVIDIA CORPORATION <cudatools@nvidia.com>"

RUN apt-get update && apt-get install -y --no-install-recommends \
        cuda-nvml-dev-$CUDA_PKG_VERSION \
        cuda-command-line-tools-$CUDA_PKG_VERSION \
        cuda-libraries-dev-$CUDA_PKG_VERSION \
        cuda-minimal-build-$CUDA_PKG_VERSION \
        libnccl-dev=$NCCL_VERSION-1+cuda10.2 \
        libcublas10=10.2.2.89-1 \
        libcublas-dev=10.2.2.89-1 \
        libcudnn7=$CUDNN_VERSION-1+cuda10.2 \
        libcudnn7-dev=$CUDNN_VERSION-1+cuda10.2 \
        cuda-libraries-$CUDA_PKG_VERSION \
        cuda-nvtx-$CUDA_PKG_VERSION \
        libcublas10=10.2.2.89-1 \
        libnccl2=$NCCL_VERSION-1+cuda10.2 && \
        apt-mark hold libnccl2 && \
        apt-mark hold libcudnn7 && \
        rm -rf /var/lib/apt/lists/*

ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs
