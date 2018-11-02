FROM python:3.6-slim-stretch

RUN apt update
RUN apt install -y python3-dev gcc

# Install pytorch and fastai
RUN pip install torch_nightly -f https://download.pytorch.org/whl/nightly/cpu/torch_nightly.html
RUN pip install fastai

# Install starlette and uvicorn
RUN pip install starlette uvicorn python-multipart aiohttp

ADD place-check.py place-check.py
ADD check-place.pth check-place.pth

# Run it once to trigger resnet download
RUN python place-check.py

EXPOSE 5042

# Start the server
CMD ["python", "place-check.py", "serve"]
