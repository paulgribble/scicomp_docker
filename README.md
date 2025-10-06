# scicomp_docker

Make a docker image for scientific computing course (Psychology 9040) and publish it as a github package.

## Student Install and First Run

### Install Docker Desktop

#### macOS (Apple Silicon or Intel)

1. Open: https://docs.docker.com/desktop/install/mac-install/
2. Download the Apple Silicon (M1/M2/M3) build if you have a newer Mac; otherwise choose Intel.
3. Open the .dmg and drag Docker.app to /Applications.
4. Launch Docker; complete any prompts.

#### Windows 10/11

1. Open: https://docs.docker.com/desktop/install/windows-install/
2. Install Docker Desktop and ensure WSL2 backend is enabled (default).
3. Start Docker Desktop.

### Linux (Ubuntu) (optional for Linux users)

```{bash}
sudo apt-get update
sudo apt-get install -y docker.io docker-compose-plugin
sudo usermod -aG docker $USER
# log out and back in, or run: newgrp docker
```

### Verify Installation

In a terminal (macOS Terminal, Windows PowerShell, or Linux shell):

```{bash}
docker run hello-world
```

Expected:

```
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

Then check versions/architecture:

```{bash}
docker version
docker compose version
docker info | grep -E "Architecture|Operating System"
```

Expected:
- Apple Silicon Macs: Architecture: aarch64
- Windows/Intel: Architecture: x86_64

### Pull the course image

```{bash}
docker pull ghcr.io/paulgribble/sci-comp:2025
```

### Start Jupyter Lab

From any working directory you want to use for notebooks:

```{bash}
docker run --rm -it -p 8888:8888 \
  -v "$PWD:/home/student/work" \
  ghcr.io/paulgribble/sci-comp:2025S \
  jupyter lab --ip=0.0.0.0 --no-browser --NotebookApp.token=''
```

Then open the printed URL in your browser (usually http://localhost:8888).


