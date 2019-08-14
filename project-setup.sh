#!/bin/sh
set -e
cp -r * $1
mkdir $1/data
mv $1/env.template $1/.env
rm $1/README.md
rm $1/project-setup.sh