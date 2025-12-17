.PHONY: help dev build clean deploy

help: ## Show this help message
	@echo "Evgeniy Gantman - Security Portfolio Site"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

dev: ## Start development server
	@echo "Starting Hugo development server..."
	@hugo server -D

build: ## Build the site for production
	@echo "Building site for production..."
	@hugo --minify
	@echo "✅ Build complete. Output in public/"

clean: ## Clean build artifacts
	@echo "Cleaning build artifacts..."
	@rm -rf public resources/_gen
	@echo "✅ Clean complete."

deploy: ## Deploy to GitHub Pages (requires git setup)
	@echo "Deploying to GitHub Pages..."
	@./deploy-to-github.sh "$(MSG)"
	@echo "✅ Deployment initiated."