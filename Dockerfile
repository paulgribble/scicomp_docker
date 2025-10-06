# Good, small, multi-arch base
FROM python:3.12-slim

# System deps commonly needed for scientific Python wheels
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential git curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Avoid __pycache__, and get unbuffered logs
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Create a non-root user (better practice)
RUN useradd -m -u 1000 student
USER student
WORKDIR /home/student

# Copy and install deps (pin versions!)
COPY requirements.txt .
RUN python -m pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

CMD ["python", "-m", "ipykernel"]

