#!/bin/bash

# Deploy Hugo site to GitHub Pages
# Usage: ./deploy-to-github.sh "commit message"

set -e

COMMIT_MSG="${1:-Update portfolio site}"

echo "🚀 Deploying Hugo site to GitHub Pages..."

# Check if we're in the right directory
if [ ! -f "config.toml" ]; then
    echo "❌ Error: config.toml not found. Are you in the Hugo site directory?"
    exit 1
fi

# Check if Hugo is installed
if ! command -v hugo &> /dev/null; then
    echo "❌ Hugo is not installed. Installing Hugo..."
    # Install Hugo on macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install hugo
    # Install Hugo on Ubuntu/Debian
    elif [[ -f /etc/debian_version ]]; then
        sudo apt-get update
        sudo apt-get install hugo
    else
        echo "❌ Please install Hugo manually: https://gohugo.io/installation/"
        exit 1
    fi
fi

# Clean previous build
echo "🧹 Cleaning previous build..."
rm -rf public

# Build site
echo "🔨 Building site..."
hugo --minify

# Initialize git if not already
if [ ! -d ".git" ]; then
    echo "📦 Initializing git repository..."
    git init
    git checkout -b main
fi

# Check if remote exists
if ! git remote | grep -q "origin"; then
    echo "📡 Please add a remote repository first:"
    echo "   git remote add origin https://github.com/gantmane/gantmane.github.io.git"
    exit 1
fi

# Commit and push
echo "💾 Committing changes..."
git add .
git commit -m "$COMMIT_MSG"

echo "🚀 Pushing to GitHub..."
git push origin main

echo ""
echo "✅ Deployment complete!"
echo "🌐 Your site will be available at: https://gantmane.github.io"
echo ""
echo "📊 To monitor deployment:"
echo "   1. Go to your repository on GitHub"
echo "   2. Click 'Actions' tab"
echo "   3. Monitor the Hugo deployment workflow"