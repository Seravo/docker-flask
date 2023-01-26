#!/bin/sh
set -e

#
# Launch uWSGI daemon
#

[ -z "${FLASK_APP}" ] && echo "Error: Missing \$FLASK_APP!" && exit 1
[ -z "${APPDIR}" ] && echo "Error: Missing \$APPDIR!" && exit 1
[ -z "${VEDIR}" ] && echo "Error: Missing \$VEDIR!" && exit 1

if [ -x "/app/flask-migrate" ]
then
    /app/flask-migrate
fi

# If FLASK_RELOAD was supplied, start a secondary process to gracefully reload uswgi
# if any of it's files get modified.
if [ "${FLASK_RELOAD}" = true ]
then
    (find /app | entr -n -p -s "echo 'Entr: reloading...' && pkill --signal SIGHUP uwsgi" &)
fi

cd "${APPDIR:-/app}"

uwsgi \
    --plugins "python3" \
    --master \
    --processes=10 \
    --workers=5 \
    --harakiri=30 \
    --chdir "${APPDIR}" \
    --vacuum \
    --die-on-term \
    --env LC_ALL=C.UTF-8 \
    --env LANG=C.UTF-8 \
    --procname "${FLASK_APP}" \
    --pythonpath "${APPDIR}" \
    --virtualenv "${VEDIR}" \
    --enable-threads \
    --stats 127.0.0.1:9191 \
    --socket=":9000" \
    --http-socket=":8080" \
    --touch-reload=/tmp/reload-app \
    --log-filter="${LOG_FILTER_REGEX}" \
    --module "${FLASK_APP}"

# --profiler
