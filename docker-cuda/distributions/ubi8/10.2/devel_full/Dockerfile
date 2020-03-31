FROM registry.access.redhat.com/ubi8/ubi:latest
LABEL maintainer "Prashanth Nandavanam <pn@forwardmeasure.com>"

RUN NVIDIA_GPGKEY_SUM=d1be581509378368edeec8c1eb2958702feedf3bc3d17011adbf24efacce4ab5 && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/7fa2af80.pub | sed '/^Version/d' > /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA && \
    echo "$NVIDIA_GPGKEY_SUM  /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA" | sha256sum -c --strict -

COPY cuda.repo /etc/yum.repos.d/cuda.repo

ENV CUDA_VERSION 10.2.89
ENV CUDA_PKG_VERSION 10-2-$CUDA_VERSION-1

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN yum install -y \
    cuda-cudart-$CUDA_PKG_VERSION \
    cuda-compat-10-2 \
    && \
    ln -s cuda-10.2 /usr/local/cuda

# Cleanup RPM DB, since it seems to be getting corrupted
RUN rm -f /var/lib/rpm/__db* && rm -rf /var/lib/rpmrebuilddb.* && rpm --rebuilddb &> /dev/null; cp -rf /var/lib/rpmrebuilddb.*/* /var/lib/rpm; rm -rf /var/lib/rpmrebuilddb.*

RUN yum install -y \
    pciutils lshw \
    cuda-libraries-$CUDA_PKG_VERSION \
    cuda-nvtx-$CUDA_PKG_VERSION \
    libcublas10-10.2.2.89-1 \
    libnccl-2.6.4-1+cuda10.2 \
    libcudnn7-7.6.5.33-1.cuda10.2 \
    libnvinfer7 libnvparsers7 libnvonnxparsers7 libnvinfer-plugin7

# Cleanup RPM DB, since it seems to be getting corrupted
RUN rm -f /var/lib/rpm/__db* && rm -rf /var/lib/rpmrebuilddb.* && rpm --rebuilddb &> /dev/null; cp -rf /var/lib/rpmrebuilddb.*/* /var/lib/rpm; rm -rf /var/lib/rpmrebuilddb.*

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

# Cleanup RPM DB, since it seems to be getting corrupted
RUN rm -f /var/lib/rpm/__db* && rm -rf /var/lib/rpmrebuilddb.* && rpm --rebuilddb &> /dev/null; cp -rf /var/lib/rpmrebuilddb.*/* /var/lib/rpm; rm -rf /var/lib/rpmrebuilddb.*

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.2 brand=tesla,driver>=384,driver<385 brand=tesla,driver>=396,driver<397 brand=tesla,driver>=410,driver<411 brand=tesla,driver>=418,driver<419"

ENV CUDA_HOME /usr/local/cuda
ENV PATH /usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib64
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs

# Lock in the versions
RUN rm /etc/yum.repos.d/cuda.repo