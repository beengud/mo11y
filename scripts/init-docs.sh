#!/bin/bash
# This script initializes a Docusaurus site in the docs directory
# of the mo11y repository using the classic template.

set -e

# Check if npx is installed
if ! command -v npx &> /dev/null; then
    echo "Error: npx is not installed. Please install Node.js (which includes npm) to proceed."
    exit 1
fi

# Ensure we're in the mo11y repository root (checks for .git directory)
if [ ! -d ".git" ]; then
    echo "Warning: .git directory not found. Make sure you're in the root of the mo11y repository."
fi

# # Create docs directory if it doesn't exist
# if [ ! -d "docs" ]; then
#     mkdir docs
#     echo "Created docs directory."
# fi

# Initialize Docusaurus in the docs directory using the classic template
echo "Initializing Docusaurus..."
npx create-docusaurus@latest docs classic

echo "Docusaurus has been successfully initialized in the docs directory."
