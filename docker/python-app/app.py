from flask import Flask
import os
import requests

app = Flask(__name__)
app_host = os.environ['APP_HOST']

@app.route('/')
def hello():
    try:
        my_env = os.environ['HOSTNAME']
    except KeyError:
        my_env = os.environ['USER']

    return my_env

if __name__ == '__main__':
    app.run(host=app_host)
