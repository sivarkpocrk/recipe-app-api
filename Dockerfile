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
    /py/bin/pip install -r /tmp/requirements.txt && \
    echo "DEV=${DEV}" && \
    if [ $DEV = "true" ]; then \
       echo "Installing development dependencies..."; \
       /py/bin/pip install -r /tmp/requirements.dev.txt; \
    else \
       echo "Skipping development dependencies installation."; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user


ENV PATH="/py/bin:$PATH"

USER django-user

# Run Django tests
#CMD ["python", "manage.py", "test"]