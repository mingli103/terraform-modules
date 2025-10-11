#!/bin/bash

# Test script with LocalStack integration
set -e

echo "🚀 Starting LocalStack testing..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if LocalStack is ready
wait_for_localstack() {
    echo "⏳ Waiting for LocalStack to be ready..."
    local max_attempts=30
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if curl -s http://localhost:4566/_localstack/health > /dev/null 2>&1; then
            echo "✅ LocalStack is ready!"
            return 0
        fi
        
        echo "Attempt $attempt/$max_attempts - LocalStack not ready yet..."
        sleep 2
        ((attempt++))
    done
    
    echo "❌ LocalStack failed to start within expected time"
    return 1
}

# Function to run tests
run_tests() {
    echo "🧪 Running tests..."
    cd common_tags/test
    
    # Run the tests
    if go test -v -timeout 30m; then
        echo "✅ Tests passed!"
        return 0
    else
        echo "❌ Tests failed!"
        return 1
    fi
}

# Main execution
main() {
    echo "🔧 Starting LocalStack container..."
    docker-compose up -d localstack
    
    # Wait for LocalStack to be ready
    if ! wait_for_localstack; then
        echo "❌ Failed to start LocalStack"
        exit 1
    fi
    
    # Run tests
    if run_tests; then
        echo "🎉 All tests passed!"
        exit 0
    else
        echo "💥 Tests failed!"
        exit 1
    fi
}

# Cleanup function
cleanup() {
    echo "🧹 Cleaning up..."
    docker-compose down
}

# Set trap to cleanup on exit
trap cleanup EXIT

# Run main function
main "$@"
