FROM ubuntu:22.04

# Set noninteractive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    git \
    wget \
    curl \
    nano \
    python3 \
    python3-pip \
    python3-venv \
    python-is-python3 \
    build-essential \
    cmake \
    ninja-build \
    libssl-dev \
    libffi-dev \
    libpython3-dev \
    unzip \
	libusb-1.0-0 \
	libusb-1.0-0-dev \
    && rm -rf /var/lib/apt/lists/*

# Install pipx and colcon
RUN python3 -m pip install --upgrade pip
RUN pip install pipx && pipx ensurepath

# Add essential Python packages for ROS/build tools
RUN pip install \
    click \
    future \
    pyparsing \
    pyelftools

# Clone ESP-IDF
RUN git clone --recursive https://github.com/espressif/esp-idf.git /opt/esp-idf

# Install ESP-IDF tools
RUN /opt/esp-idf/install.sh

# Add ESP-IDF to PATH
ENV IDF_PATH=/opt/esp-idf
ENV PATH="$IDF_PATH/tools:$PATH"

# Source ESP-IDF at shell startup
RUN echo 'source /opt/esp-idf/export.sh' >> /etc/bash.bashrc

# Set working directory to /project
WORKDIR /project
