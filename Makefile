# ---- Config ----
REGISTRY      ?= ghcr.io
ORG           ?= paulgribble
IMAGE         ?= scicomp
VERSION       ?= 2025
TAG           ?= $(REGISTRY)/$(ORG)/$(IMAGE):$(VERSION)
PLATFORMS     ?= linux/amd64,linux/arm64
BUILDER       ?= coursebuilder
CONTEXT       ?= .

# ---- Helpers ----
print-%:
	@echo $*=$($*)

# ---- Local auth to GHCR (requires PAT with write:packages) ----
# Usage: make login PAT=ghp_XXXXXXXX
login:
	@[ -n "$(PAT)" ] || (echo "Error: Set PAT=your_personal_access_token" && exit 1)
	echo "$(PAT)" | docker login $(REGISTRY) -u $(ORG) --password-stdin

logout:
	docker logout $(REGISTRY)

# ---- Build (single-arch, host platform) ----
build:
	docker build -t $(TAG) $(CONTEXT)

# ---- Push (single-arch) ----
push:
	docker push $(TAG)

# ---- Buildx multi-arch setup ----
create-builder:
	- docker buildx create --name $(BUILDER) --use
	docker buildx inspect --bootstrap

inspect-builder:
	docker buildx inspect

# ---- Build+Push multi-arch (recommended for class) ----
publish: create-builder
	docker buildx build \
	  --platform $(PLATFORMS) \
	  -t $(TAG) \
	  --push \
	  $(CONTEXT)

# ---- Run helpers ----
run:
	docker run --rm -it $(TAG) /bin/bash

lab:
	docker run --rm -it -p 8888:8888 \
	  -v "$$PWD:/home/student/work" \
	  $(TAG) \
	  jupyter lab --ip=0.0.0.0 --no-browser --NotebookApp.token=''

# ---- Clean local artifacts ----
clean:
	- docker rmi $(TAG) || true
	- docker buildx rm $(BUILDER) || true

# Convenience: tag current HEAD with VERSION (if you use git tags)
tag:
	git tag -f $(VERSION) && git push -f origin $(VERSION)