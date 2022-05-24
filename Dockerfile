#This image is a popular base image for python projects
FROM python:alpine
#This copies your requirements.txt to a new app folder
COPY ./requirements.txt /app/requirements.txt
#This changes your working directory to /app
WORKDIR /app
#This installs your requirements with pip
RUN pip3 install -r requirements.txt
#This copies your project directory to /app
COPY . /app
#This exposes port 8686
EXPOSE 8686
#This runs app.py to start your app
CMD ["python", "app.py"]
