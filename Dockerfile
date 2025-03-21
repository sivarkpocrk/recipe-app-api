FROM python:3.9-alpine3.13
LABEL maintainer="siav ke"

ENV PYTHONUNBUFFERED 1

ARG UID=101

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./scripts /scripts
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client jpeg-dev &&\
    apk add --update --no-cahce --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev zlib zlib-dev linux-headers && \
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
        --uid $UID \
        --disabled-password \
        --no-create-home \
        django-user  &&\
    mkdir -p /vol/web/media && \
    mkdir -p /vol/web/static && \
    chown -R django-user:django-user /vol/web && \
    chmod -R 755 /vol/web && \
    chmod -R +x /scripts

ENV PATH="/scripts:/py/bin:$PATH"

USER django-user

VOLUME /vol/web/static
VOLUME /vol/web/media

# Run Django tests
#CMD ["python", "manage.py", "test"]

CMD ["run.sh"]
