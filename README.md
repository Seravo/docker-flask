# docker-flask

Flask in Docker

## Usage

To publish your own app, mount your app to `/app`, and provide FLASK_APP environment variable with the correct value.

Eg.

    docker run --rm -it -v $(pwd)/myapp:/app -e FLASK_APP=myapp:app -p 127.0.0.1:8080:8080 ghcr.io/seravo/flask:latest

if you had app code like

    myapp/myapp.py:

    from flask import Flask
    app = Flask(__name__)

    @app.route("/")
    def some_view():
        return "Hello myapp!"

now try to open http://127.0.0.1:8080/ , and you should see your app running.

Usually you shouldn't expose this HTTP endpoint directly to internet, but use eg. `ypcs/nginx:latest` as a reverse proxy.

## Live reload

By default, you can manually reload the application by touching `/tmp/reload-app`. If you want your application to reload automatically after every save, set `FLASK_RELOAD` as `true`.

    docker run --rm -it -v $(pwd)/myapp:/app -e FLASK_APP=myapp:app -e FLASK_RELOAD=true -p 127.0.0.1:8080:8080 ghcr.io/seravo/flask:latest

Now, if you modify the code in `myapp.py` and save, the app will reload and your changes will be in effect.
