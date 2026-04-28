#!/bin/bash

echo "Starting deployment..."

docker stop sync-service 2>/dev/null || true
docker rm sync-service 2>/dev/null || true

docker run -d \
  --name sync-service \
  -p 8080:8080 \
  sync-service:local

sleep 5

curl -f http://localhost:8080/actuator/health

if [ $? -eq 0 ]; then
  echo "Deployment success"
else
  echo "Deployment failed"
  exit 1
fi