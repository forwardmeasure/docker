ARG IMAGE_NAME
FROM ${IMAGE_NAME}:10.2-runtime-ubuntu18.04
LABEL maintainer "NVIDIA CORPORATION <cudatools@nvidia.com>"

ENV CUDA_VERSION 10.2.89
ENV CUDA_PKG_VERSION 10-2-$CUDA_VERSION-1
ENV NCCL_VERSION 2.6.4
ENV CUDNN_VERSION 7.6.5.32

RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

RUN apt-get update && apt-get install -y --no-install-recommends  \
    cuda-cudart-$CUDA_PKG_VERSION \
    cuda-compat-10-2 \
    && \
    ln -s cuda-10.2 /usr/local/cuda

RUN apt-get update && apt-get install -y --no-install-recommends \
    pciutils lshw \
    cuda-libraries-$CUDA_PKG_VERSION \
    cuda-nvtx-$CUDA_PKG_VERSION \
    libcublas10-10.2.2.89-1 \
    libnccl-2.6.4-1+cuda10.2 \
    libcudnn7-7.6.5.33-1.cuda10.2 \
    libnvinfer7 libnvparsers7 libnvonnxparsers7 libnvinfer-plugin7

RUN apt-get update && apt-get install -y --no-install-recommends \
        cuda-nvml-dev-$CUDA_PKG_VERSION \
        cuda-command-line-tools-$CUDA_PKG_VERSION \
        cuda-libraries-dev-$CUDA_PKG_VERSION \
        cuda-minimal-build-$CUDA_PKG_VERSION \
        libcublas-devel-10.2.2.89-1 \
        libnccl-devel-2.6.4-1+cuda10.2 \
        libcudnn7-devel-7.6.5.33-1.cuda10.2 \
        libnvinfer-devel libnvparsers-devel libnvonnxparsers-devel libnvinfer-plugin-devel && \
        apt-mark hold libnccl2 && \
        apt-mark hold libcudnn7

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.2 brand=tesla,driver>=384,driver<385 brand=tesla,driver>=396,driver<397 brand=tesla,driver>=410,driver<411 brand=tesla,driver>=418,driver<419"

ENV CUDA_HOME /usr/local/cuda
ENV PATH /usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib64
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs
