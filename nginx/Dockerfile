FROM nginx
LABEL maintainer="support@talonstrikesoftware.com"

# install 'extra' packages
RUN apt-get update -yqq
RUN apt-get install -yqq --no-install-recommends procps vim systemd openssl

# establish where nginx should look for files
ENV APP_NAME {app_name}

# Copy nginx config template into a temp directory so it can be customized for the app
COPY ./nginx/nginx.conf /tmp/docker.nginx

# substitue variable references in the nginx config template with those from the environment
RUN envsubst '$APP_NAME' < /tmp/docker.nginx > /etc/nginx/conf.d/default.conf 

EXPOSE 80
EXPOSE 443

# Use the "exec" form of CMD so nginx shuts down gracefully on SIGTERM (i.e. `docker stop`)
#CMD ["nginx","-g","daemon off;"]
