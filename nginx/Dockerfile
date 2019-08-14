FROM nginx
LABEL maintainer="redwolf89@gmail.com"

RUN apt-get update -yqq
#RUN apt-get install -yqq --no-install-recommends build-essential apt-transport-https libpq-dev vim
RUN apt-get install -yqq --no-install-recommends procps vim systemd openssl

# Left in for a future release (see note in readme)
#COPY ./nginx/nginx.service /lib/systemd/system/nginx.service

CMD ["nginx","-g","daemon off;"]
