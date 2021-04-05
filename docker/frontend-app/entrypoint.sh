#!/bin/sh

for file in /usr/share/nginx/html/static/js/main.*.js*; do
  if [ ! -f $file.js.tmpl ]; then
    cp $file $file.tmpl
  fi
  envsubst '${MYENV}' < $file.tmpl > $file
done
