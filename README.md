# flask-web-service
This guide will walk you through the simple steps needed to build and run a Flask app on Rising Cloud.

If you'd prefer to watch a video, check out our YouTube of the tutorial.

[![Video Player](https://cms.risingcloud.com/uploads/Video_Player_b69c4aa4ff.png)](https://youtu.be/UD--sJvqcYA)

# 1. Install the Rising Cloud Command Line Interface (CLI)
In order to run the Rising Cloud commands in this guide, you will need to [install](https://risingcloud.com/docs/install) the Rising Cloud Command Line Interface. This program provides you with the utilities to setup your Rising Cloud Task or Web Service, upload your application to Rising Cloud, setup authentication, and more.

# 2. Login to Rising Cloud using the CLI
Using a command line console (called terminal on Mac OS X and command prompt on Windows) run the Rising Cloud login command. The interface will request your Rising Cloud email address and password.

```risingcloud login```

# 3. Initialize Your Web Service

Whether this is an existing project or a new project, you must initialize it as a Rising Cloud Web Service.

Create or navigate to your project directory, and be sure to remove any files which will not be a part of your Rising Cloud App.
Your Web Service will require a unique task name.

Your unique task name must be at least 12 characters long and consist of only alphanumeric characters and hyphens (-). This task name is unique to all tasks on Rising Cloud. A unique dispatch URL will be provided to you with this name, and this URL must be used to send requests to your web service.  If a task name is not available, the CLI will return with an error so you can try again.

In your project directory, run the following command replacing $TASK with your unique task name.

```risingcloud init -w $TASK```

The -w flag lets the Rising Cloud CLI know that you would like to initialize a Rising Cloud Web Service and not a Rising Cloud Task.
This creates a risingcloud.yaml file in your project directory. This file can be used to configure the build script.

# 4. Setup Your Project

**Configure your risingcloud.yaml**

Open the previously created risingcloud.yaml file and change the Port line to the following:

```port: 8686```

**Create your Program**
This server will create a /hello endpoint which will respond to http GET requests with Hello World!  

To get started, make a new file called app.py, and in it paste the following:

```
from flask import Flask
app = Flask(__name__)

@app.route('/hello')
def hello_world():
    return "Hello World!"

if __name__ == "__main__":
    app.run(debug=True, host='::', port=8686)
```

**Setup the Dockerfile**

Your container will use the python:alpine base image and load in everything the server needs to use python3 and pip, it will then use pip to install the packages listed in requirements.txt.

Create a new file called Dockerfile and in it, paste the following:

```
FROM python:alpine
COPY ./requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip3 install -r requirements.txt
COPY . /app
EXPOSE 8686
CMD ["python", "app.py"]
```

**Set Up Requirements**

As written above, the server has one external dependency: Flask. 

To install Flask create a new file called requirements.txt and paste the following into it.

```
Flask==2.0.3
jinja2<3.1.0
```

# 5. Build and Deploy Your Rising Cloud Web Service

Use the push command to push your updated risingcloud.yaml to your Task on Rising Cloud.

```risingcloud push```

Use the build command to zip, upload, and build your app on Rising Cloud.

```risingcloud build```

Use the deploy command to deploy your app as soon as the build is complete.  Change $TASK to your unique task name.

```risingcloud deploy $TASK```

Alternatively, you could also use a combination to push, build and deploy all at once.

```risingcloud build -r -d```

Rising Cloud will now build out the infrastructure necessary to run and scale your application including networking, load balancing and DNS.  Allow DNS a few minutes to propogate and then your app will be ready and available to use!

**Send a request to your new Flask App!**

Once your app is built and DNS is live, open up your Web Browser and type:
```
https://<your_task_url>.risingcloud.app/hello
```
Congratulations, you’ve successfully used Flask on Rising Cloud!
