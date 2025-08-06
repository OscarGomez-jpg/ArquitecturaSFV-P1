#!/bin/sh

container_name="taller_docker"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is not installed. Please install Docker first."
  exit 1
fi

sudo docker build -t "$container_name" .

# This is a small trick to kill the container
trap 'echo "Stopping container..."; sudo docker stop "$container_name"; sudo docker rm "$container_name"; exit' INT
sudo docker run --name "$container_name" -p 8080:8080 -e PORT=8080 -e NODE_ENV=production -d "$container_name"

echo "Waiting for service to be available at http://localhost:8080/health..."
until curl -sf http://localhost:8080/health >/dev/null; do
  sleep 1
done

echo "Service is up! Making GET request:"
curl http://localhost:8080/health

# This waits for the container to stop
while sudo docker ps | grep -q "$container_name"; do
  sleep 1
done
