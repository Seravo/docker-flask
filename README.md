# docker-flask

Flask in Docker

## Usage

To run hello world app, :8080 provides HTTP endpoint (to uWSGI), and :9000 provides uWSGI endpoint. So, let's try accessing via HTTP:

    docker run --rm -it -p 127.0.0.1:8080:8080 ghcr.io/seravo/flask:latest

now try to open http://127.0.0.1:8080/ , you should see familiar greeting.

To publish your own app, mount your app to `/app`, and provide FLASK_APP environment variable with correct value.

Eg.

    docker run --rm -it -v $(pwd)/myapp:/app -e FLASK_APP=myapp:app -p 127.0.0.1:8080:8080 ghcr.io/seravo/flask:latest

if you had app code like

    myapp/myapp.py:

    from flask import Flask
    app = Flask(__name__)

    @app.route("/")
    def some_view():
        return "Hello myapp!"

Usually you shouldn't expose this HTTP endpoint directly to internet, but use eg. `ypcs/nginx:latest` as a reverse proxy.

## Live reload

By default, you can manually reload the application by touching `/tmp/reload-app`. If you want your application to reload automatically after every save, set `FLASK_RELOAD` as `true`.

    docker run --rm -it -v $(pwd)/myapp:/app -e FLASK_APP=myapp:app -e FLASK_RELOAD=true -p 127.0.0.1:8080:8080 ghcr.io/seravo/flask:latest

Now, if you modify the code in `myapp.py` and save, the app will reload and your changes will be in effect.

## Tests

Tests can be ran by executing `pytest-3` inside the container. For example, to run the tests for `hello.py` you would do it like this:

    docker exec -t {CONTAINER_NAME} pytest-3 hello.py -vv

Test output should look something like this:

    platform linux -- Python 3.9.2, pytest-6.0.2, py-1.10.0, pluggy-0.13.0 -- /usr/bin/python3
    cachedir: .pytest_cache
    rootdir: /app
    collected 1 item

    hello.py::test_hello PASSED
