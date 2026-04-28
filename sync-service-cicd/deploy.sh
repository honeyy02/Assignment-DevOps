#!/bin/bash

echo "Starting deployment..."

ENV=$1

echo "🚀 Deploying to $ENV..."

docker stop sync-service 2>/dev/null || true
docker rm sync-service 2>/dev/null || true

docker run -d \
  --name sync-service \
  -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=$ENV \
  sync-service:local

sleep 5

curl -f http://localhost:8080/health

if [ $? -eq 0 ]; then
  echo "Deployment success"
else
  echo "Deployment failed"
  exit 1
fi