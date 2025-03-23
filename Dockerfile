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
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev zlib zlib-dev linux-headers && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    echo "DEV=${DEV}" && \
    if [ "$DEV" = "true" ]; then \
       echo "Installing development dependencies..."; \
       /py/bin/pip install -r /tmp/requirements.dev.txt; \
    else \
       echo "Skipping development dependencies installation."; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    # Create django user with correct UID
    adduser \
        --uid $UID \
        --disabled-password \
        --no-create-home \
        django-user &&\
    # Ensure media and static directories are writable
    mkdir -p /vol/web/media /vol/web/static && \
    chown -R django-user:django-user /vol/web && \
    # Give full write permissions to media
    chmod -R 777 /vol/web/media && \
    # Read-only permissions for static files
    chmod -R 755 /vol/web/static && \
    chmod -R +x /scripts

# Add the scripts path to environment PATH
ENV PATH="/scripts:/py/bin:$PATH"

# Set the user after setting up permissions
USER django-user

# Declare volumes after user switch to match container permissions
VOLUME /vol/web/static
VOLUME /vol/web/media

# Run the container with the run script
CMD ["run.sh"]
