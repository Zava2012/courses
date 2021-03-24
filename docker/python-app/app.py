from flask import Flask
import os
import requests

app = Flask(__name__)


@app.route('/')
def hello():
    my_env = os.environ['USER']
    return my_env

if __name__ == '__main__':
    app.run()
