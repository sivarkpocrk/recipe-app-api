FROM python:3.9-alpine3.13
LABEL maintainer="siav ke"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client jpeg-dev &&\
    apk add --update --no-cahce --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev zlib zlib-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    echo "DEV=${DEV}" && \
    if [ $DEV = "true" ]; then \
       echo "Installing development dependencies..."; \
       /py/bin/pip install -r /tmp/requirements.dev.txt; \
    else \
       echo "Skipping development dependencies installation."; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user  &&\
    mkdir -p /vol/web/media && \
    mkdir -p /vol/web/static && \
    chown -R django-user:django-user /vol/web && \
    chmod -R 777 /vol/web/media

ENV PATH="/py/bin:$PATH"

USER django-user

# Run Django tests
#CMD ["python", "manage.py", "test"]
