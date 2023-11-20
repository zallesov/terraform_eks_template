# Use an official Python runtime as a parent image
FROM python:3.8-slim-buster

# RUN yum clean all && \
#   yum update -y && \
#   yum install -y python3 python3-pip && \
#   yum clean all

# Set the working directory in the container to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY ./server /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir fastapi uvicorn

# Make port 80 available to the world outside this container
EXPOSE 8080

# Run app.py when the container launches
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]