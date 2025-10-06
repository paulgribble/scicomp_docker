# Scientific Computing Environment - Student Setup Guide

Welcome! This guide will help you set up the Python scientific computing environment for this course using Docker and VS Code.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Setup Method 1: VS Code Dev Containers (Recommended)](#setup-method-1-vs-code-dev-containers-recommended)
- [Setup Method 2: Jupyter Server Connection](#setup-method-2-jupyter-server-connection)
- [Verifying Your Setup](#verifying-your-setup)
- [Troubleshooting](#troubleshooting)
- [Daily Workflow](#daily-workflow)

---

## Prerequisites

You'll need to install the following software (all are free):

### 1. Docker Desktop
- **Windows/Mac**: Download from [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/)
- **Linux**: Follow instructions at [docs.docker.com/engine/install](https://docs.docker.com/engine/install/)
- After installation, open Docker Desktop and ensure it's running (you'll see a whale icon in your system tray)

### 2. Visual Studio Code
- Download from [code.visualstudio.com](https://code.visualstudio.com/)
- Install and launch it

### 3. Choose Your Setup Method
Pick ONE of the methods below based on your preference:

---

## Setup Method 1: VS Code Dev Containers (Recommended)

This method provides the smoothest experience - everything runs inside the container automatically.

### Step 1: Install VS Code Extension
1. Open VS Code
2. Click the Extensions icon in the left sidebar (or press `Ctrl+Shift+X` / `Cmd+Shift+X`)
3. Search for **"Dev Containers"** (by Microsoft)
4. Click **Install**

### Step 2: Clone This Repository
```bash
# In your terminal:
git clone https://github.com/paulgribble/scicomp_docker.git
cd scicomp_docker
```

### Step 3: Open in Container
1. In VS Code: **File → Open Folder** → Select the `scicomp_docker` folder
2. You should see a popup: **"Reopen in Container"** - click it!
   - If you don't see the popup: Press `F1` or `Ctrl+Shift+P` / `Cmd+Shift+P` and type **"Dev Containers: Reopen in Container"**
3. Wait while the container builds (first time takes 5-10 minutes)
4. When complete, you'll see "Dev Container: Scientific Computing 2025" in the bottom-left corner

### Step 4: Test It Out
1. Create a new file: `test.ipynb`
2. Click **"Select Kernel"** in the top-right
3. Choose **"Python 3.12.x"**
4. In the first cell, type:
   ```python
   import numpy as np
   import pandas as pd
   import matplotlib.pyplot as plt

   print("NumPy version:", np.__version__)
   print("Setup successful!")
   ```
5. Click the ▶️ button to run the cell

**You're all set!** All your work in this folder will be saved on your computer, even when the container is stopped.

---

## Setup Method 2: Jupyter Server Connection

This method runs Jupyter in Docker, and VS Code connects to it as a kernel.

### Step 1: Install VS Code Extensions
1. Open VS Code
2. Install these extensions:
   - **Python** (by Microsoft)
   - **Jupyter** (by Microsoft)

### Step 2: Pull the Course Image
```bash
# In your terminal:
docker pull ghcr.io/paulgribble/scicomp:2025
```

### Step 3: Create Your Work Directory
```bash
mkdir ~/course-work
cd ~/course-work
```

### Step 4: Start Jupyter Server

**Option A: Using Make (Mac/Linux)**
```bash
make lab-vscode
```

**Option B: Using Helper Scripts**

**Mac/Linux:**
```bash
./start-jupyter.sh
```

**Windows (PowerShell):**
```powershell
.\start-jupyter.bat
```

**Option C: Manual Docker Command**
```bash
docker run --rm -it -p 8888:8888 \
  -v "$PWD:/home/student/work" \
  ghcr.io/paulgribble/scicomp:2025 \
  jupyter lab --ip=0.0.0.0 --no-browser
```

### Step 5: Copy the Jupyter URL
Look for output like this:
```
http://127.0.0.1:8888/lab?token=abc123def456...
```
**Copy the entire URL** (including the token)

### Step 6: Connect VS Code to Jupyter
1. In VS Code, open your work folder
2. Create a new file: `test.ipynb`
3. Click **"Select Kernel"** (top-right)
4. Choose **"Existing Jupyter Server"**
5. Choose **"Enter the URL of the running Jupyter server"**
6. Paste the URL you copied
7. Select **"Python 3 (ipykernel)"**

### Step 7: Test It
Run this in a notebook cell:
```python
import numpy as np
print("NumPy version:", np.__version__)
print("Setup successful!")
```

**Done!** Leave the terminal running while you work. Press `Ctrl+C` to stop Jupyter when you're finished.

---

## Verifying Your Setup

Run this in a notebook to check all packages:

```python
import sys
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import scipy
import sklearn
import IPython
import jupyterlab

packages = {
    "Python": sys.version,
    "NumPy": np.__version__,
    "Pandas": pd.__version__,
    "Matplotlib": matplotlib.__version__,
    "SciPy": scipy.__version__,
    "Scikit-learn": sklearn.__version__,
    "IPython": IPython.__version__,
    "JupyterLab": jupyterlab.__version__
}

for name, version in packages.items():
    print(f"{name:15} {version}")
```

Expected output should show:
- Python 3.12.x
- NumPy 2.3.3
- Pandas 2.3.3
- Matplotlib 3.10.6
- SciPy 1.16.2
- Scikit-learn 1.7.2

---

## Troubleshooting

### "Docker daemon is not running"
- Open Docker Desktop and wait for it to fully start
- You should see a green whale icon

### "Port 8888 is already in use"
**Method 1 (Dev Containers)**: Close any running Jupyter instances first

**Method 2 (Jupyter Server)**:
```bash
# Stop existing containers:
docker stop scicomp
# Or use a different port:
docker run ... -p 9999:8888 ...
# Then connect to http://127.0.0.1:9999
```

### "Permission denied" (Linux only)
Your user ID might not match the container's. Rebuild with your UID:
```bash
docker build --build-arg UID=$(id -u) -t ghcr.io/paulgribble/scicomp:2025 .
```

### "Cannot find requirements.txt" during build
Make sure you're running the build command from the repository root directory.

### Container is slow on Windows/Mac
Docker Desktop has resource limits. Increase them:
1. Open Docker Desktop
2. Settings → Resources
3. Increase CPUs to 4 and Memory to 4GB
4. Click "Apply & Restart"

### "Kernel died" or crashes
Try restarting:
- **Method 1**: Rebuild container: `Dev Containers: Rebuild Container`
- **Method 2**: Stop Jupyter (`Ctrl+C`) and restart it

### Extensions not loading in Dev Container
Close and reopen VS Code after the container builds completely.

---

## Daily Workflow

### Method 1: Dev Containers
1. Open VS Code
2. Open your course folder
3. If not already in container: Click bottom-left corner → "Reopen in Container"
4. Start working!

### Method 2: Jupyter Server
1. Open terminal in your work directory
2. Start Jupyter: `make lab-vscode` (or use helper scripts)
3. Open VS Code to your work folder
4. If needed, reconnect kernel using the URL from terminal
5. Work on your notebooks
6. When done, press `Ctrl+C` in terminal to stop Jupyter

---

## Getting Help

**Check Docker status:**
```bash
docker ps
```
Should show your running container.

**View container logs:**
```bash
docker logs scicomp
```

**Reset everything:**
```bash
# Stop all containers
docker stop $(docker ps -q)

# Remove images
docker rmi ghcr.io/paulgribble/scicomp:2025

# Rebuild from scratch
make build
```

**Still stuck?** Contact your instructor or TA with:
1. Your operating system (Windows/Mac/Linux)
2. Docker Desktop version (`docker --version`)
3. The exact error message you're seeing
4. Screenshot if helpful

---

## Tips for Success

- **Save often**: Your work autosaves in VS Code, but use `Ctrl+S` / `Cmd+S` anyway
- **Git your work**: This folder works great with Git for version control
- **Restart kernels**: If output looks strange, restart the kernel
- **Keep Docker running**: Don't quit Docker Desktop while working
- **Update regularly**: Run `docker pull ghcr.io/paulgribble/scicomp:2025` to get the latest image

Happy coding! 🐍📊
