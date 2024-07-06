# Base image
FROM debian:buster

# Update package list
RUN apt-get update
# Install nginx and OpenSSl -y automatically confirms install
RUN apt-get install -y nginx openssl

# Create SSL directory
RUN mkdir /etc/nginx/ssl
# Generate SSL Certificate
RUN openssl req \
        # Creates a new 4096-bit RSA key pair
        -newkey rsa:4096 \
        # Outputs a self-signed certificate instead of a certificate signing request
        -x509 \
        # Uses SHA-256 hashing algorithm
        -sha256 \
        # Sets the certificate validity
        -days 365 \
        # Indicates no passphrase is used for the private key
        -nodes \
        # Specifies the output paths for the certificate keys
        -out /etc/nginx/ssl/safoh.crt \
        -keyout /etc/nginx/ssl/safoh.key \
        # Provides subject information for the certificate
        -subj "/C=NL/ST=Noord-Holland/L=Amsterdam/O=42/OU=safoh/CN=safoh"

# Copies a custom Nginx configuration file from the local dir
# To the container's Nginx configuration
COPY ./conf/nginx.conf /etc/nginx/conf.d

# Create a runtime directory for Nginx
# Needed to ensure it exists before starting the service
RUN mkdir -p /run/nginx

# Instructs docker to expose port 443, which is the default port for HTTPS
EXPOSE 443

# Start Nginx in foreground (daemon off) when the container runs
CMD ["nginx", "-g", "daemon off;"]