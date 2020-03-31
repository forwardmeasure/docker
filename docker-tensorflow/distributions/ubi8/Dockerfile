ARG BASE_IMAGE_NAME
FROM ${BASE_IMAGE_NAME} AS BASE_STAGE
LABEL maintainer "Prashanth Nandavanam <pn@forwardmeasure.com>"

ARG cmake_version=3.16.2
ARG bazel_version=0.29.1
ARG compiler=gcc_8
ARG compute_engine=cuda_10

LABEL version="1.0.0" \
    description="Tensorflow C++ CUDA 10.2 Runtime Server"

ENV CONAN_USER_HOME=/opt/conan \
    SW_BUILD_DIR=/opt/forwardmeasure/build \
    SW_DOWNLOADS_DIR=/opt/forwardmeasure/downloads \
    CMAKE_SCRIPT=install_cmake.py \
    BAZEL_SCRIPT=install_bazel.py \
    CMAKE_VERSION=$cmake_version \
    BAZEL_VERSION=$bazel_version \
    CMAKE_INSTALL_DIR=/opt/cmake/${CMAKE_VERSION} \
    BAZEL_INSTALL_DIR=/opt/google/bazel/${BAZEL_VERSION} \
    COMPILER=$compiler \
    ACCELERATION_ENGINE=$compute_engine

ENV CONAN_BUILD_DIR=${SW_BUILD_DIR}/conan \
    PATH="$PATH:${CMAKE_INSTALL_DIR}/bin:${BAZEL_INSTALL_DIR}/bin" \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_COLLATE=C \
    LC_CTYPE=en_US.UTF-8

RUN yum update -y; yum clean all; yum -y upgrade && \
    yum install -y glibc-langpack-en curl grep sed gcc gcc-c++ gcc-gfortran wget unzip pkg-config \
    make autoconf libtool tar xz cpio patch file golang python36 python36-devel git \
    java-1.8.0-openjdk-devel

RUN rm -f /var/lib/rpm/__db* && rm -rf /var/lib/rpmrebuilddb.* && \
    rpm --rebuilddb &> /dev/null; cp -rf /var/lib/rpmrebuilddb.*/* /var/lib/rpm; rm -rf /var/lib/rpmrebuilddb.*

RUN mkdir -p ${SW_DOWNLOADS_DIR} && mv /usr/bin/git /usr/bin/git.exe
COPY common/git /usr/bin/git

# Download CMake and Bazel installers
COPY common/${CMAKE_SCRIPT} common/${BAZEL_SCRIPT} ${SW_DOWNLOADS_DIR}/

RUN alternatives --set python /usr/bin/python3 && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1 && \
    pip install numpy conan;

#Install CMake
RUN cd ${SW_DOWNLOADS_DIR} && python ./${CMAKE_SCRIPT} --cmake-version=${CMAKE_VERSION} \
    --cmake-install-dir=${CMAKE_INSTALL_DIR} \
    --cmake-build-dir=${SW_BUILD_DIR}/cmake

#Install Bazel
RUN cd ${SW_DOWNLOADS_DIR} && python ./${BAZEL_SCRIPT} --bazel-version=${BAZEL_VERSION} \
    --bazel-install-dir=${BAZEL_INSTALL_DIR} \
    --bazel-build-dir=${SW_BUILD_DIR}/bazel

# Ensure that we pick up libraries in
ENV PATH ${CUDA_HOME}/bin:${PATH}
ENV LD_LIBRARY_PATH ${CUDA_HOME}/lib64:${CUDNN_HOME}/lib64

# Weird fix-up for libnsl
RUN ln -s /usr/lib64/libnsl.so.2 /usr/lib64/libnsl.so

FROM BASE_STAGE as DEV_LIBS_CONAN_SETUP

RUN git clone https://github.com/forwardmeasure/conan ${CONAN_BUILD_DIR}
#COPY conan ${CONAN_BUILD_DIR}
RUN ${CONAN_BUILD_DIR}/conan_export.sh -d ${CONAN_BUILD_DIR}/recipes

# Install CUDA version
FROM DEV_LIBS_CONAN_SETUP AS DEV_LIBS_WITH_NO_TF
RUN ${CONAN_BUILD_DIR}/conan_install.sh -e ${ACCELERATION_ENGINE} -c ${COMPILER} -o all -f ${CONAN_BUILD_DIR}/conanfile.txt && \
    conan remove "*" -s -b -f

# Install CPU version
FROM DEV_LIBS_CONAN_SETUP AS DEV_LIBS_WITH_NO_TF
RUN ${CONAN_BUILD_DIR}/conan_install.sh -e cpu -c ${COMPILER} -o all -f ${CONAN_BUILD_DIR}/conanfile.txt && \
    conan remove "*" -s -b -f

ADD distributions/ubi8/entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
