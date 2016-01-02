FROM nginx

MAINTAINER Harish Narayanan "mail@harishnarayanan.org"

ADD ./public/ /var/www/html
COPY ./kubernetes/nginx/harishnarayanan.org /etc/nginx/sites-enabled/harishnarayanan.org
COPY ./kubernetes/nginx/nginx.conf /etc/nginx/nginx.conf
RUN mkdir /etc/nginx/ssl
ADD ./kubernetes/ssl/ /etc/nginx/ssl
