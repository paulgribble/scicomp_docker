@echo off
REM Helper script to start Jupyter Lab for VS Code connection
REM For use with Scientific Computing 2025 course

setlocal enabledelayedexpansion

set IMAGE=ghcr.io/paulgribble/scicomp:2025
set CONTAINER_NAME=scicomp
set PORT=8888

echo ================================================
echo Scientific Computing 2025 - Jupyter Lab Starter
echo ================================================
echo.

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker is not running!
    echo Please start Docker Desktop and try again.
    pause
    exit /b 1
)

REM Check if container is already running
docker ps --format "{{.Names}}" | findstr /x "%CONTAINER_NAME%" >nul 2>&1
if not errorlevel 1 (
    echo [WARNING] Container '%CONTAINER_NAME%' is already running.
    echo Stop it first with: docker stop %CONTAINER_NAME%
    pause
    exit /b 1
)

REM Check if image exists locally
docker image inspect %IMAGE% >nul 2>&1
if errorlevel 1 (
    echo [INFO] Image not found locally. Pulling from registry...
    docker pull %IMAGE%
    echo.
)

echo [INFO] Starting Jupyter Lab server...
echo Your current directory will be mounted as /home/student/work
echo.
echo INSTRUCTIONS:
echo 1. Wait for Jupyter to start (watch for the URL below)
echo 2. Copy the ENTIRE URL that looks like:
echo    http://127.0.0.1:8888/lab?token=abc123...
echo 3. In VS Code:
echo    - Open a .ipynb file
echo    - Click 'Select Kernel' (top-right)
echo    - Choose 'Existing Jupyter Server'
echo    - Paste the URL
echo 4. Press Ctrl+C here to stop the server when done
echo.
echo ================================================
echo.

REM Start the container
docker run --rm -it ^
  --name %CONTAINER_NAME% ^
  -p %PORT%:8888 ^
  -v "%CD%:/home/student/work" ^
  %IMAGE% ^
  jupyter lab --ip=0.0.0.0 --no-browser
