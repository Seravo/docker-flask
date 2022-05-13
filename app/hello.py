#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World!"


@app.route("/db")
def db():
    return "FIXME: Return database status if some variable has been set..."


if __name__ == '__main__':
    app.run()
