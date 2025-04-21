FROM python:3.9-slim

RUN apt-get update && \
    apt-get install -y nginx supervisor && \
    pip install fastapi uvicorn

WORKDIR /app
COPY ./app /app
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./app/static/index.html /usr/share/nginx/html/index.html
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80
CMD ["supervisord"]
