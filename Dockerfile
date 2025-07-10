FROM nvidia/cuda:12.2.0-runtime-ubuntu22.04

WORKDIR /cuda-workspace

# Set non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libgl1-mesa-glx \
    libglib2.0-0 \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Set Python3 as default
RUN ln -s /usr/bin/python3 /usr/bin/python

# Upgrade pip
RUN python -m pip install --upgrade pip

# Install other Python packages
RUN pip install --no-cache-dir \
    torch \
    numpy \
    pandas \
    opencv-python \
    scikit-learn \
    matplotlib \
    scipy \
    ruff

# Default command
CMD ["/bin/bash"]