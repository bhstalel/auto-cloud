server {
  listen 80;
  server_name {{collabora_domain}};

  root /usr/share/nginx/office;

  # static files
  location ^~ /loleaflet {
    proxy_pass https://localhost:9980;
    proxy_set_header Host $http_host;
  }

  # WOPI discovery URL
  location ^~ /hosting/discovery {
    proxy_pass https://localhost:9980;
    proxy_set_header Host $http_host;
  }

  # websockets, download, presentation and image upload
  location ^~ /lool {
    proxy_pass https://localhost:9980;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $http_host;
  }
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name {{collabora_domain}};

    # Use Mozilla's guidelines for SSL/TLS settings
    # https://mozilla.github.io/server-side-tls/ssl-config-generator/
    # NOTE: some settings below might be redundant
    ssl_certificate /etc/nginx/ssl/collabora.crt;
    ssl_certificate_key /etc/nginx/ssl/collabora.key;

}