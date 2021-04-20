#!/usr/bin/env sh

set -eu

tmpfile=$(mktemp)

for file in /usr/share/nginx/html/main*.js; do
    envsubst '${PROD_STATE} ${BACKEND_HOST} ${BACKEND_PORT}' < "$file" > "$tmpfile"
    cp -f "$tmpfile" "$file"
    chmod 644 "$file"
done

rm -f "$tmpfile"

# envsubst < /usr/share/nginx/html/assets/env.js.tmpl > /usr/share/nginx/html/assets/env.js
