FROM tensorflow/tensorflow:1.3.0-gpu-py3
MAINTAINER ville.rantanen@reaktor.com

RUN apt-get update && apt-get install -y python3-pip git curl pkg-config
RUN apt-get install -y libav-tools caca-utils fswebcam unzip  \
  build-essential cmake pkg-config libjpeg8-dev \
  libtiff5-dev libjasper-dev libpng12-dev \
  libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev \
  libgtk2.0-dev libx264-dev libatlas-base-dev gfortran \
        libfreetype6-dev \
        libicu-dev \
        libjbig-dev \
        libjpeg8-dev \
        libpng12-dev \
        libtbb-dev \
        libssl-dev \
        libsqlite3-dev \
        libtk8.6 \
        liblzma-dev \
        zlib1g-dev \
     && apt-get clean
RUN pip3 install setuptools scikit-image numpy 
RUN bash -c "cd /usr/local && curl https://repo.continuum.io/pkgs/free/linux-64/mkl-2017.0.3-0.tar.bz2 | tar xvj && ldconfig"
ENV OPENCVVER=3.3.0
RUN ["/bin/bash","-c","cd /tmp && curl https://codeload.github.com/opencv/opencv/zip/$OPENCVVER > opencv.zip && \
  unzip opencv.zip && cd opencv-$OPENCVVER && mkdir -p build && cd build && \
  cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -DBUILD_opencv_java=OFF \
  -DWITH_CUDA=OFF \
  -DENABLE_AVX=ON \
  -DWITH_OPENGL=ON \
  -DWITH_OPENCL=ON \
  -DWITH_IPP=ON \
  -DWITH_TBB=ON \
  -DWITH_EIGEN=ON \
  -DWITH_V4L=ON \
  -DBUILD_TESTS=OFF \
  -DBUILD_PERF_TESTS=OFF \
  -DCMAKE_BUILD_TYPE=RELEASE \
  -DCMAKE_INSTALL_PREFIX=$(python3 -c 'import sys; print(sys.prefix)') \
  -DPYTHON_EXECUTABLE=$(which python3) \
  -DPYTHON_INCLUDE_DIR=$(python3 -c 'from distutils.sysconfig import get_python_inc; print(get_python_inc())') \
  -DPYTHON_PACKAGES_PATH=$(python3 -c 'from distutils.sysconfig import get_python_lib; print(get_python_lib())') \
        -D BUILD_EXAMPLES=ON ..  && \
  make -j2 && \
  make install && ldconfig && rm -rf /tmp/opencv.zip /tmp/opencv-$OPENCVVER"]


RUN pip3 install Cython sklearn

ADD darkflow/ /opt/darkflow/
ADD flow /opt/flow
ADD setup.py /opt/setup.py
RUN cd /opt && pip3 install .




