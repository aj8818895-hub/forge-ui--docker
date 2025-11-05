# Use a clean and fast base image (no CUDA or conda lock issues)
FROM python:3.10-slim

# Set a label for info
LABEL maintainer="yourname@example.com"

# Prevent interactive prompts during package installs
ENV DEBIAN_FRONTEND=noninteractive

# Install basic system dependencies
RUN apt-get update && apt-get install -y \
    git curl wget build-essential ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Upgrade pip and install essential Python tools
RUN python3 -m pip install --upgrade pip setuptools wheel

# Copy dependency list (add your project dependencies in requirements.txt)
COPY requirements.txt .

# Install Python dependencies (no cache for smaller image)
RUN pip install --no-cache-dir -r requirements.txt

# Copy your entire project into the container
COPY . .

# Make your start script executable
RUN chmod +x /workspace/start.sh

# Expose port for your Forge UI backend (adjust if needed)
EXPOSE 7860

# Start your app
CMD ["/workspace/start.sh"]
