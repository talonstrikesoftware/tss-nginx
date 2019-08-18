#!/bin/bash
set -e

echo $OSTYPE
# fix the nginx.conf file and put in a known path so it can be mounted into the container
cp ./nginx/nginx.conf.template ./nginx/nginx.conf

if [[ "$OSTYPE" == "linux-gnu" ]]; then
   sed -i -e "s/DOMAIN_NAME/$1/g"  $PWD/nginx/nginx.conf
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # have to do it this way because of mac OSX, will need to adjust for different OS's
    sed -i '' -e "s/DOMAIN_NAME/$1/g"  $PWD/nginx/nginx.conf
else
    sed -i '' -e "s/DOMAIN_NAME/$1/g"  $PWD/nginx/nginx.conf
fi

cp ./nginx/nginx.conf ./data/nginx
