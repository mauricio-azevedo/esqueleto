.PHONY: help dev dev-obs down check fmt fmt-check lint typecheck test test-unit build

help: ## list targets
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk -F ':.*## ' '{ printf "  %-10s %s\n", $$1, $$2 }'

dev: ## bring everything up locally
	docker compose up

dev-obs: ## dev plus local logs, metrics and traces at http://localhost:3000
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
