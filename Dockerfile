FROM ubuntu:24.10
LABEL Description="PicoSystem Build environment"

# Custom locations for installing Pico-SDK and PicoSystem:
ARG SDK_PATH=/usr/local/pico-sdk
ARG PICOSYSTEM_PATH=/usr/local/picosystem
ARG BLIT_PATH=/usr/local/32blit-sdk
ARG BOARD=pimoroni_picosystem

# Set environment variables for use in cmake:
ENV PICO_SDK_PATH=$SDK_PATH
ENV PICOSYSTEM_DIR=$PICOSYSTEM_PATH
ENV BLIT_DIR=$BLIT_PATH
ENV PICO_BOARD=$BOARD

# Non-interactive:
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/London

RUN echo "PICO SDK:             $PICO_SDK_PATH"
RUN echo "PICOSYSTEM:           $PICOSYSTEM_DIR"
RUN echo "32BLIT:               $BLIT_DIR"
RUN echo "Will build for board: $PICOBOARD"

# Install dependencies and programs:
RUN apt-get update && apt-get -y --no-install-recommends install \
    git \
    ca-certificates \
    python3-full \
    tar \
    wget \
    build-essential \
    gcc-arm-none-eabi \
    libnewlib-arm-none-eabi \
    libstdc++-arm-none-eabi-newlib \
    cmake && \
    apt-get clean

# Install 32blit:
# Python in Ubuntu 24 forces virtual environments, need bash for 'source'
SHELL ["/bin/bash", "-c"]
RUN python3 -m venv /usr/local venv && source venv/bin/activate
RUN pip3 install 32blit

# Install Pico SDK:
RUN git clone --depth 1 --branch 2.0.0 https://github.com/raspberrypi/pico-sdk $SDK_PATH && \
    cd $SDK_PATH && \
    git submodule update --init

# Install Picotool:
RUN git clone --depth 1 --branch 2.0.0 https://github.com/raspberrypi/picotool.git /home/picotool && \
    cd /home/picotool && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    cmake --install . && \
    rm -rf /home/picotool

# Install Picosystem:
RUN git clone https://github.com/pimoroni/picosystem.git $PICOSYSTEM_PATH && \
    cd $PICOSYSTEM_PATH && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc)
    
# Install 32Blit SDK:
RUN git clone https://github.com/32blit/32blit-sdk.git $BLIT_PATH 
