#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from flask import Flask
import pytest

app = Flask(__name__)


@app.route("/")
def hello():
    return "Hello World!"


@app.route("/db")
def db():
    return "FIXME: Return database status if some variable has been set..."


@pytest.fixture
def client():
    with app.test_client() as client:
        yield client


def test_hello(client):
    response = client.get("/")
    assert response.data == b"Hello World!"


if __name__ == '__main__':
    app.run()
