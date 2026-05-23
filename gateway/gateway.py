from fastapi import FastAPI
from pydantic import BaseModel
import requests

app = FastAPI()

INFERENCE_URL = "http://localhost:8000/infer"

class ChatRequest(BaseModel):
    message: str

@app.post("/chat")
def chat(req: ChatRequest):

    response = requests.post(
        INFERENCE_URL,
        json={
            "message": req.message
        }
    )

    return response.json()

