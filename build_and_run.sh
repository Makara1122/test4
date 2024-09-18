#!/bin/bash

# Set variables
IMAGE_NAME="my_nextjs_app"
CONTAINER_NAME="nextjs_container"
PORT="3000"  # Modify if your app uses a different port

# Stop and remove any existing container with the same name
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "Removing existing container: $CONTAINER_NAME..."
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
fi

# Build the Docker image
echo "Building Docker image: $IMAGE_NAME..."
docker build -t $IMAGE_NAME .

# Run the container
echo "Running Docker container: $CONTAINER_NAME..."
docker run -d -p $PORT:3000 --name $CONTAINER_NAME $IMAGE_NAME

echo "Container is running at http://localhost:$PORT"

