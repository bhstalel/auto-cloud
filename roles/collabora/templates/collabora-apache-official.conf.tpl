<VirtualHost *:80>
  ServerName {{collabora_domain}}
</VirtualHost>

<IfModule mod_ssl.c>
  <VirtualHost 10.20.30.40:443>
    ServerName {{collabora_domain}}:443

    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/{{collabora_domain}}/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/{{collabora_domain}}/privkey.pem

    SSLProtocol all -SSLv2 -SSLv3
    SSLCipherSuite ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES256-SHA:ECDHE-ECDSA-DES-CBC3-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA:!DSS
    SSLHonorCipherOrder on

    # Encoded slashes need to be allowed
    AllowEncodedSlashes NoDecode

    # Container uses a unique non-signed certificate
    SSLProxyEngine On
    SSLProxyVerify None
    SSLProxyCheckPeerCN Off
    SSLProxyCheckPeerName Off

    # https://wiki.ubuntuusers.de/Apache/mod_proxy_html/
    ProxyRequests Off

    # keep the host
    ProxyPreserveHost On

    # static html, js, images, etc. served from loolwsd
    # loleaflet is the client part of LibreOffice Online
    ProxyPass /loleaflet https://127.0.0.1:9980/loleaflet retry=0
    ProxyPassReverse /loleaflet https://127.0.0.1:9980/loleaflet

    # WOPI discovery URL
    ProxyPass /hosting/discovery https://127.0.0.1:9980/hosting/discovery retry=0
    ProxyPassReverse /hosting/discovery https://127.0.0.1:9980/hosting/discovery

    # Main websocket
    ProxyPassMatch "/lool/(.*)/ws$" wss://127.0.0.1:9980/lool/$1/ws nocanon

    # Admin Console websocket
    ProxyPass /lool/adminws wss://127.0.0.1:9980/lool/adminws

    # Download as, Fullscreen presentation and Image upload operations
    ProxyPass /lool https://127.0.0.1:9980/lool
    ProxyPassReverse /lool https://127.0.0.1:9980/lool
  </VirtualHost>
</IfModule>