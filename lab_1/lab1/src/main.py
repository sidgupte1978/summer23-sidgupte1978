from fastapi import FastAPI,HTTPException

app = FastAPI()

@app.get("/hello/")
async def greet(name: str):
    if not name:
       raise HTTPException(status_code=406, detail="Bad Request: `name` parameter is required")
    return {"message": f"Hello {name}"}

@app.get("/")
async def unimplemented():
    raise HTTPException(status_code=501, detail="Not Implemented")
