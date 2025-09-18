from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
import uvicorn
from api.api_routes import api_router

app = FastAPI(
    title="Next5 API",
    description="Backend for the Futsal analysis and midia platform.",
    version="1.0.0"
)

"""
In a high-traffic production environment, the best practice is to use a web server in front of your application, 
such as Nginx, to serve static files directly. Nginx is highly optimized for this task and more performant 
than using the application's app.mount.

"""

app.mount(
    "/static",
    StaticFiles(directory="static"),
    name="static"
)

app.include_router(api_router)

@app.get("/")
def read_root():
    return {"message": "Welcome to the Next5 API!"}

if __name__ == "__main__":
    uvicorn.run('main:app', host="0.0.0.0", port=8000,reload=True)