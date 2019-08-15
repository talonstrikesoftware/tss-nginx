#!/bin/sh
set -e
cp -r * $1
mkdir $1/data
mkdir $1/data/website
mkdir $1/data/nginx
mkdir $1/data/nginx/nginx_logs

# awk the nginx.conf file here? instead of the container
mv $1/nginx/nginx.conf $1/data/nginx
mv -R $1/nginx/conf.d $1/data/nginx
mv $1/env.template $1/.env
rm $1/README.md
rm $1/project-setup.sh