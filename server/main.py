from fastapi import FastAPI, Request

app = FastAPI()

@app.post("/echo")
async def echo(request: Request):
    # Retrieve the request body as JSON
    request_data = await request.json()
    
    # Echo the request data back in the response
    return {"echo": request_data}