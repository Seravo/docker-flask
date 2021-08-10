# docker-flask

Flask in Docker

## Usage

To run hello world app, :8080 provides HTTP endpoint (to uWSGI), and :9000 provides uWSGI endpoint. So, let's try accessing via HTTP:

    docker run -p 127.0.0.1:8080:8080 ypcs/flask:latest

now try to open http://127.0.0.1:8080/ , you should see familiar greeting.

To publish your own app, mount your app to `/app`, and provide FLASK_APP environment variable with correct value.

Eg.

    docker run -v $(pwd)/myapp:/app -e FLASK_APP=myapp:app -p 127.0.0.1:8080:8080 ypcs/flask:latest

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
