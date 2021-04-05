#!/bin/sh

for file in /usr/share/nginx/html/static/js/main.*.js; do
  if [ ! -f $file.tmpl.js ]; then
    cp $file $file.tmpl.js
  fi
  envsubst '$REACT_APP_NAME' < $file.tmpl.js > $file
done

exec "$@"
