import sys

from fastapi.testclient import TestClient
from src.main import app

client = TestClient(app)

def test_hello_name():
   response = client.get(f"/hello/?name=Sid")
   assert (response.status_code == 200)  # Check API success status code 200
   assert response.json() == {"message": "Hello Sid"}

def test_unimplemented():
   response = client.get(f"/")
   assert (response.status_code == 501)
   assert response.json() == {"detail": f"Not Implemented"} 

def test_docs_endpoint():
    response = client.get("/docs")
    assert (response.status_code == 200) 


def test_openapi_endpoint():
    response = client.get("/openapi.json")
    assert (response.status_code == 200)

    try:
        response_json = response.json()
        assert response_json.get("openapi").startswith(
            "3."
        ), "OpenAPI version is less than 3"

    except ValueError:
        assert False, "Response is not valid JSON"



