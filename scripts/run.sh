#!/bin/sh

set -e

# ✅ Fix permissions
chown -R django-user:django-user /vol/web/static /vol/web/media
chmod -R 755 /vol/web/static /vol/web/media


python manage.py wait_for_db
python manage.py collectstatic --noinput
python manage.py migrate

gunicorn --bind :9000 --workers 4 app.wsgi
