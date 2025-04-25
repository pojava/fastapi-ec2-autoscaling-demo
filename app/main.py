from fastapi import FastAPI

app = FastAPI()

@app.get("/api/")
def read_root():
    return {"message": "Hello world, CI/CD is live!."}

@app.get("/health")
def health_check():
    return {"status": "ok"}

