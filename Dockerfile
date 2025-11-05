# Use CUDA runtime base image (for GPU support)
FROM nvidia/cuda:12.8.1-cudnn8-runtime-ubuntu22.04

LABEL maintainer="you@example.com"

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# 1) Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl ca-certificates wget build-essential \
    python3.10 python3.10-dev python3.10-venv python3-pip \
    && rm -rf /var/lib/apt/lists/*

# 2) Upgrade pip & install essential Python tools
RUN python3.10 -m pip install --upgrade pip setuptools wheel

# 3) Create app directory
WORKDIR /workspace

# 4) Copy dependency file first (for layer caching)
COPY requirements.txt .

# 5) Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# 6) Copy the rest of your project
COPY . .

# 7) Make your start script executable
RUN chmod +x /workspace/start.sh

# 8) Expose port (adjust if needed)
EXPOSE 7860

# 9) Default start command
CMD ["/workspace/start.sh"]
