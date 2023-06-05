1. What this application does
This application has 3 available API endpoints.

The /hello endpoint uses a GET request and returns a greeting to the user. It takes in a query parameter name and returns a greeting to the user. If no name is provided, it returns an error.
The /docs endpoint takes you to the Swagger UI documentation for the API.
The /openapi.json endpoint returns the OpenAPI specification for the API.

Some endpoints are not yet implemented. They include:

The / endpoint returns {"detail":"Not Implemented"}
2. How to build the application
Building the application is simple.

Docker
From the lab_1 directory, build the docker image from the Dockerfile

docker build -t w255:lab1 lab1/
Local Environment
Make sure you have Python 3.11 installed and linked to yout PATH. You will also need poetry installed. See Poetry installation instructions here: https://python-poetry.org/docs/

From the lab_1/lab1 directory, run the following command to build the application. All dependencies should be installed automatically by Poetry.

poetry install
3. How to run the application
Running the application is mostly the same for Docker and local environment. The only difference is setting up the environment.

Docker
Once you have built the docker image, simply spin up a docker container. This application uses port 8000, so make sure you map local port 8000 to the docker container.

docker run -p 8000:8000 -d w255:lab1
Local Environment
Use Poetry to run the application with the following command:

poetry run uvicorn src.main:app
Once Poetry runs the uvicorn command, a local server will start. The address should be http://127.0.0.1:8000; click on the address of the server from your terminal to be sure.

Once the application is running
Go to your browser and type in localhost:8000 and you should be in the application. The first page should look like {"detail":"Not Implemented"}, which is expected.

/hello endpoint
This API uses a GET request. You can simply pass in a variable to name, such as http://localhost:8000/hello?name=Jesse from the browser. You can also test this endpoint using curl from the terminal: curl -X GET http://localhost:8000/hello?name=Jesse
Other supported routes are: /docs and /openapi.json.

4. How to test the application
End-to-End Testing
It is recommended to test the API running on docker with the bash script located in lab_1/lab1/run.sh. This bash script will perform end-to-end testing, include:

Building the Docker image from Dockerfile
Spinning up a Docker container from the Docker image
Performing 5 unit tests
Stopping the container
Removing the container
Removing the image
Unit Testing
Pytest
Test cases have been written in lab_1/lab1/tests/test_lab1.py. We are using FastAPI's TestClient class for unit tests. If the application is started from local environment, you can test the application by running:

poetry run pytest -vv
Note that you cannot use Pytest if you started the application from Docker, because the Docker image was built without the dev dependencies.

Manual Testing
You may also perform additional tests once your docker container is running simply by sending curl requests to the API. This works for both the local environment setup and the Docker setup.

/hello endpoint
Open the terminal and run curl -X GET localhost:8000/hello?name=Jesse and you should see the response back in the terminal.
/docs endpoint
Open the terminal and run curl -X GET localhost:8000/docs and you should see the response back in the terminal.
/openapi.json endpoint
Open the terminal and run curl -X GET localhost:8000/openapi.json and you should see the response back in the terminal.
/health endpoint
Open the terminal and run curl -X GET localhost:8000/health and you should see the response back in the terminal.
5. Q&A
Q: What status code should be raised when a query parameter does not match our expectations?

A: Assuming the parameter is valid, status code 406 - Bad Request is typically raised if a quary parameter cannot be understood.


Q: What does Python Poetry handle for us?

A: Poetry creates a self-contained virtual environment and help us maintain all the dependencies and external packages easily for our application. Poetry can manage different groups of dependencies to help us control what packages we want for our work. As such, Poetry allows us directly run scripts directly in its environment.


Q: What advantages do multi-stage docker builds give us?

A: Multi-stage Docker build gives us the advantage of building an image that only contains the necessary binary built from the project. This saves space by building the binary from 1 stage, then passing the necessary already-built binaries to a second stage that we can use. The end result is that the Docker image is not bloated with packages only used for development but not relevant to deployment. There is also an added security component since the final image only contains the binaries and not the source packages themselves, such that the container can only run the already-built binaries and nothing more.
