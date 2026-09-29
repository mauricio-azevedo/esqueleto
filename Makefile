-include .env
APP ?= $(notdir $(CURDIR))
TAG ?= $(shell git rev-parse --short HEAD)
IMAGE = $(REGISTRY)/$(APP)

.PHONY: help dev dev-obs down check fmt fmt-check lint typecheck test test-unit build image push deploy

help: ## list targets
	@grep -hE '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk -F ':.*## ' '{ printf "  %-10s %s\n", $$1, $$2 }'

dev: ## bring everything up locally
	@test -f .env || cp .env.example .env
	docker compose up

dev-obs: ## dev plus local logs, metrics and traces at http://localhost:3000
	@test -f .env || cp .env.example .env
	docker compose --profile observability up

down: ## stop and remove what dev brought up
	docker compose down

check: fmt-check lint typecheck test build ## run the whole gate

fmt: ## rewrite files with the formatter
	@echo "fmt: nothing configured"

fmt-check: ## fail if fmt would change anything
	@echo "fmt-check: nothing configured"

lint: ## static checks
	@echo "lint: nothing configured"

typecheck: ## type checks
	@echo "typecheck: nothing configured"

test: ## run all tests
	@echo "test: nothing configured"

test-unit: ## run unit tests only, in seconds
	@echo "test-unit: nothing configured"

build: ## build artifacts
	@echo "build: nothing configured"

image: ## build the container image
	docker build -t $(IMAGE):$(TAG) .

push: image ## push the image to REGISTRY
	@test -n "$(REGISTRY)" || { echo "REGISTRY is not set; see .env.example"; exit 1; }
	docker push $(IMAGE):$(TAG)

deploy: push ## deploy this commit to the cluster (ADR 0003)
	helm upgrade --install $(APP) deploy/ --namespace $(APP) --create-namespace --set image.repository=$(IMAGE) --set image.tag=$(TAG) --wait
