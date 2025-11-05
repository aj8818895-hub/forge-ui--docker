# ✅ Base image — lightweight and works everywhere (no CUDA)
FROM python:3.10-slim

# Maintainer info (optional)
LABEL maintainer="you@example.com"
ENV DEBIAN_FRONTEND=noninteractive

# 1️⃣ Install basic system packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl wget build-essential python3 python3-pip python3-dev \
    && rm -rf /var/lib/apt/lists/*

# 2️⃣ Upgrade pip and wheel
RUN python -m pip install --upgrade pip setuptools wheel

# 3️⃣ Create working directory
WORKDIR /workspace

# 4️⃣ Copy requirements first (for caching)
COPY requirements.txt /workspace/requirements.txt

# 5️⃣ Install Python dependencies
RUN pip install --no-cache-dir -r /workspace/requirements.txt

# 6️⃣ Copy the rest of your project
COPY . /workspace

# 7️⃣ Make start.sh executable (ignore error if not present)
RUN chmod +x /workspace/start.sh || true

# 8️⃣ Expose app port (for Gradio, Streamlit, etc.)
EXPOSE 7860

# 9️⃣ Run your start script or main app
CMD ["/workspace/start.sh"]
