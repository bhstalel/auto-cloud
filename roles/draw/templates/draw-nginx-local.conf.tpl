
server {
    server_name {{draw_domain}};
    # enforce https
    # return 301 https://$server_name$request_uri;
    root /var/www/webapp/;

    listen [::]:443 ssl ipv6only=on; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /var/www/webapp/ssl/draw.crt; # managed by Certbot
    ssl_certificate_key /var/www/webapp/ssl/draw.key; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}

server {
    if ($host = {{draw_domain}}) {
        return 301 https://$host$request_uri;
    } # managed by Certbot

    listen 80;
    listen [::]:80;
    server_name {{draw_domain}};
    return 404; # managed by Certbot
}
