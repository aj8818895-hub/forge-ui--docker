# ==========================================================
# Base image with CUDA support (for GPU-enabled environments)
# ==========================================================
FROM nvidia/cuda:12.8.1-cudnn8-runtime-ubuntu22.04

LABEL maintainer="you@example.com"

# Prevent interactive prompts during apt installs
ENV DEBIAN_FRONTEND=noninteractive

# ----------------------------------------------------------
# 1️⃣ Install system dependencies and Python
# ----------------------------------------------------------
RUN apt-get update && apt-get install -y \
    git curl ca-certificates wget build-essential \
    python3.10 python3.10-dev python3.10-venv python3-pip \
    && rm -rf /var/lib/apt/lists/*

# ----------------------------------------------------------
# 2️⃣ Upgrade pip and essential Python tools
# ----------------------------------------------------------
RUN python3.10 -m pip install --upgrade pip setuptools wheel

# ----------------------------------------------------------
# 3️⃣ Set up the working directory
# ----------------------------------------------------------
WORKDIR /workspace

# ----------------------------------------------------------
# 4️⃣ Copy dependency list first (for Docker layer caching)
# ----------------------------------------------------------
COPY requirements.txt .

# ----------------------------------------------------------
# 5️⃣ Install Python dependencies
# ----------------------------------------------------------
RUN pip install --no-cache-dir -r requirements.txt

# ----------------------------------------------------------
# 6️⃣ Copy the rest of your project files
# ----------------------------------------------------------
COPY . .

# ----------------------------------------------------------
# 7️⃣ Make your start script executable
# ----------------------------------------------------------
RUN chmod +x /workspace/start.sh

# ----------------------------------------------------------
# 8️⃣ Expose the app port
# ----------------------------------------------------------
EXPOSE 7860

# ----------------------------------------------------------
# 9️⃣ Default container start command
# ----------------------------------------------------------
CMD ["/workspace/start.sh"]
