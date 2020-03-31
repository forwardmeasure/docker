ARG BASE_IMAGE_NAME
FROM ${BASE_IMAGE_NAME}
LABEL maintainer "Prashanth Nandavanam <pn@forwardmeasure.com>"

RUN yum install -y \
        cuda-libraries-$CUDA_PKG_VERSION \
        cuda-nvtx-$CUDA_PKG_VERSION \
        libcublas10-10.2.2.89-1 \
        libnccl-2.6.4-1+cuda10.2 \
        libcudnn7-7.6.5.33-1.cuda10.2 \
        libnvinfer7 libnvparsers7 libnvonnxparsers7 libnvinfer-plugin7 \
        && \
        rm -rf /var/cache/yum/*
