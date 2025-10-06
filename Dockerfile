# Small, multi-arch Python base
FROM python:3.12-slim

# System packages commonly needed to build scientific wheels
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential git curl ca-certificates tini \
 && rm -rf /var/lib/apt/lists/*

# Safer defaults
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1

# Create non-root user
ARG USERNAME=student
ARG UID=1000
RUN useradd -m -u ${UID} ${USERNAME}

# Ensure user-level pip scripts are on PATH
ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"

# Silence IPython's CPR warning globally (simple prompt)
ENV IPY_SIMPLE_PROMPT=1

# Install Python deps as the non-root user
USER ${USERNAME}

COPY --chown=${USERNAME}:${USERNAME} requirements.txt /home/${USERNAME}/requirements.txt
RUN python -m pip install --upgrade pip && \
    pip install -r /home/${USERNAME}/requirements.txt

# Default working area for students
WORKDIR /home/${USERNAME}/work
EXPOSE 8888

