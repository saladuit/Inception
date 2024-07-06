# Base image
FROM debian:buster

# Install programs
RUN apt-get update
RUN apt-get install -y nginx openssl

# nginx SSL
RUN mkdir /etc/nginx/SSL
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
        -out /etc/nginx/ssl/safoh.crt \
        -keyout /etc/nginx/ssl/safoh.key \
        -subj "/C=NL/ST=Noord-Holland/L=Amsterdam/O=42/OU=safoh/CN=safoh"

COPY ./conf/nginx.conf /etc/nginx/conf.d

# nginx config
RUN mkdir -p /run/nginx

EXPOSE 443

# Start
CMD ["nginx", "-g", "daemon off;"]