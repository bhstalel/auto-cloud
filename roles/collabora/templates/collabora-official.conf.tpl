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
