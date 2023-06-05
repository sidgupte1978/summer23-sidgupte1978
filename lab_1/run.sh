# lab1 run.sh script 
# Author: Sid Gupte

# Start Script

# Build docker image
echo "Building Docker Image"

docker build -t w255:lab1 lab1/

echo "========================================="

# Run built docker image
echo "Running Built Docker Image"
CONTAINER_ID=$(docker run -p 8000:8000 -d w255:lab1)

# Retry for a max of 10 times (approx. 10 seconds)
for i in {1..10}; do
  # Send a request to your application and check if it's responding
  if curl -s "http://localhost:8000" > /dev/null; then
    echo "FastAPI is up and running!"
    break
  fi
  sleep 1
done
echo "========================================="

# Test Endpoints
echo "Testing Endpoints"
echo "testing '/hello' endpoint with ?name=Winegar, expecting (200)"
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/hello?name=Winegar"

echo "testing '/docs' endpoint, expecting (200)"
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/docs"

echo "testing '/openapi.json' endpoint, expecting (200)"
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/openapi.json"

echo "testing '/hello' endpoint with ?name=, expecting (400)"
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/hello?name="

echo "testing '/hello' endpoint with no parameters, expecting (400)"
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/hello"

echo "testing '/helloo' endpoint, expecting (404) "
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/helloo"

echo "testing '/hello' endpoint with ?name=Jesse and a POST request, expecting (405) "
curl -o /dev/null -s -w "%{http_code}\n" -X POST "http://localhost:8000/hello?name=Jesse"

echo "testing '/' endpoint, expecting (501) "
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/"

echo "========================================="
read -p "Take a moment to verify. Press enter to continue"
echo "========================================="

# Stop and Remove the running container
echo "Stopping the running container"
docker stop $CONTAINER_ID

echo "Remove the container"
docker rm $CONTAINER_ID

echo "========================================="

# Delete the built image 
echo "Deleting built image"
docker image rm w255:lab1
