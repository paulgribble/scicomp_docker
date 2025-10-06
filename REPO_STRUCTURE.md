# Repository Structure Guide

This document explains how to organize your instructor and student repositories.

## Two-Repo Setup

### Repo 1: `scicomp_docker` (This repo - Instructor Only)

**Purpose**: Build and publish the Docker image

**Keep in this repo:**
- `Dockerfile`
- `Makefile`
- `requirements.txt`
- `.dockerignore`
- `README.md` (current instructor README)
- `REPO_STRUCTURE.md` (this file)

**Workflow:**
1. Update `requirements.txt` or `Dockerfile` as needed
2. Build and test: `make build && make run`
3. Publish to GHCR: `make publish`
4. Students pull the updated image

---

### Repo 2: `scicomp-course` (New - Student Facing)

**Purpose**: Student coursework and materials

**Files to copy from THIS repo to student repo:**
```
scicomp-course/
├── README.md                  <- Copy from README_STUDENT.md (rename it)
├── STUDENT_SETUP.md          <- Copy as-is
├── .gitignore                <- Copy as-is
├── .devcontainer/
│   └── devcontainer.json     <- Copy as-is (uses pre-built image)
├── start-jupyter.sh          <- Copy as-is
├── start-jupyter.bat         <- Copy as-is
├── 00_getting_started.ipynb  <- Copy as-is
└── [assignments/]            <- Your course materials
    ├── week1/
    ├── week2/
    └── ...
```

**DO NOT copy to student repo:**
- `Dockerfile`
- `Makefile`
- `requirements.txt`
- `.dockerignore`
- `README.md` (instructor version)
- `REPO_STRUCTURE.md`

---

## Setup Instructions

### 1. Create the Student Repository

```bash
# Create a new repo on GitHub (via web UI)
# Name it something like: scicomp-course or psych9040-2025

# Clone it locally
git clone https://github.com/paulgribble/scicomp-course.git
cd scicomp-course

# Copy files from the instructor repo
cp ../scicomp_docker/STUDENT_SETUP.md .
cp ../scicomp_docker/.gitignore .
cp -r ../scicomp_docker/.devcontainer .
cp ../scicomp_docker/start-jupyter.sh .
cp ../scicomp_docker/start-jupyter.bat .
cp ../scicomp_docker/00_getting_started.ipynb .

# Rename the student README
cp ../scicomp_docker/README_STUDENT.md README.md

# Create directories for course content
mkdir -p assignments examples data

# Commit and push
git add .
git commit -m "Initial course setup with Docker environment"
git push
```

### 2. Update the Student README

Edit `README.md` in the student repo to:
- Replace placeholder repo URLs with actual repo URL
- Add course-specific information
- Add assignment submission instructions
- Add grading policies
- Add course schedule/syllabus link

### 3. Verify the Setup

Test that students can clone and use it:

```bash
# In a fresh directory, simulate student experience
cd ~/temp
git clone https://github.com/paulgribble/scicomp-course.git
cd scicomp-course

# Test Dev Container method
code .  # Open in VS Code, click "Reopen in Container"

# Or test Jupyter Server method
./start-jupyter.sh
# Copy URL and connect from VS Code
```

---

## Maintenance Workflow

### When You Update the Docker Image

**Instructor repo** (`scicomp_docker`):
1. Update `requirements.txt` or `Dockerfile`
2. `make publish`
3. Update version tag if needed

**Student repo** (`scicomp-course`):
1. Tell students to pull new image: `docker pull ghcr.io/paulgribble/scicomp:2025`
2. If `.devcontainer/devcontainer.json` needs updates, commit those changes
3. Students rebuild container: "Dev Containers: Rebuild Container"

### When You Add Course Materials

**Student repo only:**
1. Add notebooks, assignments, datasets to appropriate folders
2. Commit and push
3. Students pull updates: `git pull`

---

## Student Instructions Summary

When students clone `scicomp-course`, they:

1. **Install prerequisites** (Docker Desktop, VS Code)
2. **Clone the repo**
   ```bash
   git clone https://github.com/paulgribble/scicomp-course.git
   cd scicomp-course
   ```
3. **Choose setup method:**
   - Dev Containers: Open in VS Code → "Reopen in Container"
   - Jupyter Server: Run `./start-jupyter.sh` or `.\start-jupyter.bat`
4. **Verify setup**: Open and run `00_getting_started.ipynb`
5. **Start coursework!**

They **never** need to:
- Build the Docker image
- Install Python packages
- Worry about `Dockerfile` or `Makefile`

---

## GitHub Packages Visibility

Make sure your GHCR package is public:

1. Go to https://github.com/users/paulgribble/packages
2. Find `scicomp`
3. Package settings → Change visibility → Public
4. This allows students to `docker pull` without authentication

---

## Example Directory Structures

### Instructor Repo (`scicomp_docker`)
```
scicomp_docker/
├── Dockerfile
├── Makefile
├── requirements.txt
├── .dockerignore
├── README.md
├── REPO_STRUCTURE.md
├── .devcontainer/           (for testing)
├── STUDENT_SETUP.md         (source for student repo)
├── README_STUDENT.md        (source for student repo)
├── start-jupyter.sh         (source for student repo)
├── start-jupyter.bat        (source for student repo)
├── 00_getting_started.ipynb (source for student repo)
└── .gitignore               (source for student repo)
```

### Student Repo (`scicomp-course`)
```
scicomp-course/
├── README.md
├── STUDENT_SETUP.md
├── .gitignore
├── .devcontainer/
│   └── devcontainer.json
├── start-jupyter.sh
├── start-jupyter.bat
├── 00_getting_started.ipynb
├── assignments/
│   ├── week1_arrays.ipynb
│   ├── week2_pandas.ipynb
│   └── ...
├── examples/
│   ├── linear_regression.ipynb
│   └── ...
└── data/
    ├── sample_data.csv
    └── ...
```

---

## Quick Reference

| Task | Repo | Command |
|------|------|---------|
| Build image | Instructor | `make build` |
| Publish image | Instructor | `make publish` |
| Test image | Instructor | `make run` or `make lab` |
| Update environment | Instructor | Edit `requirements.txt`, then `make publish` |
| Add course material | Student | Add files, commit, push |
| Update student image | Student | Tell students: `docker pull ghcr.io/paulgribble/scicomp:2025` |

---

**You're all set!** Your instructor repo builds the environment, and your student repo provides a clean, simple experience for students.
