from fastapi import FastAPI
from pydantic import BaseModel
from transformers import AutoTokenizer, AutoModelForCausalLM

app = FastAPI()

model_id = "ggml-org/gemma-3-270m-GGUF"
gguf_file = "gemma-3-270m-Q8_0.gguf"

tokenizer = AutoTokenizer.from_pretrained(
    model_id,
    gguf_file=gguf_file
)

model = AutoModelForCausalLM.from_pretrained(
    model_id,
    gguf_file=gguf_file
)

class ChatRequest(BaseModel):
    message: str
@app.post("/infer")
def infer(req: ChatRequest):

    inputs = tokenizer(req.message, return_tensors="pt")

    outputs = model.generate(
        **inputs,
        max_new_tokens=100,
        temperature=0.7,
        do_sample=True,
        top_p=0.9
    )

    response = tokenizer.decode(
        outputs[0],
        skip_special_tokens=True
    )

    response = response.replace(req.message, "").strip()

    return {
        "response": response
    }
