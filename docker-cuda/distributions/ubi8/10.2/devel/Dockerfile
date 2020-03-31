ARG BASE_IMAGE_NAME
FROM ${BASE_IMAGE_NAME}
LABEL maintainer "Prashanth Nandavanam <pn@forwardmeasure.com>"

RUN yum install -y \
        cuda-nvml-dev-$CUDA_PKG_VERSION \
        cuda-command-line-tools-$CUDA_PKG_VERSION \
        cuda-libraries-dev-$CUDA_PKG_VERSION \
        cuda-minimal-build-$CUDA_PKG_VERSION \
        libcublas-devel-10.2.2.89-1 \
        libnccl-devel-2.6.4-1+cuda10.2 \
        libcudnn7-devel-7.6.5.33-1.cuda10.2 \
        libnvinfer-devel libnvparsers-devel libnvonnxparsers-devel libnvinfer-plugin-devel \
        && \
        rm -rf /var/cache/yum/*

ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs

# Lock in the versions
RUN rm /etc/yum.repos.d/cuda.repo
