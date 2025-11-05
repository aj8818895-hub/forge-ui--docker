# Use a CUDA runtime base so GPU works in the container (if your host GPU drivers match)
FROM nvidia/cuda:12.8.1-cudnn8-runtime-ubuntu22.04

LABEL maintainer="you@example.com"
ENV DEBIAN_FRONTEND=noninteractive

# 1) Install system packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl ca-certificates wget build-essential python3.10 python3.10-dev python3-pip \
    && rm -rf /var/lib/apt/lists/*

# 2) Upgrade pip and wheel
RUN python3.10 -m pip install --upgrade pip setuptools wheel

# 3) Create workspace directory
WORKDIR /workspace

# 4) Copy requirements first (layer caching) and install
COPY requirements.txt /workspace/requirements.txt
RUN pip install --no-cache-dir -r /workspace/requirements.txt

# 5) Copy the rest of the project
COPY . /workspace

# 6) Make start.sh executable
RUN chmod +x /workspace/start.sh

# 7) Expose the port the UI uses
EXPOSE 7860

# 8) Default command: run our start script
CMD ["/workspace/start.sh"]
