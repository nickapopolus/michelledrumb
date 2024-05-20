server {
    listen 80;
    listen [::]:80;

    root /opt/intranet_wordpress_stage/src/;

    index index.php;
    server_name michelledrumb.com www.michelledrumb.com;

    # include ssl/ssl_epicenterstage.epika.io;
    # include global/wordpress_security.conf;
    # include global/wordpress_headers.conf;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
        include global/fastcgi_optimize.conf;
    }

   # include /etc/nginx/global/rate_limit.conf;

    # logs
    # access_log /var/log/nginx/access_epicenterstage.log;
    # error_log /var/log/nginx/error_epicenterstage.log;

    # Rate Limiting
    #limit_req_zone $binary_remote_addr zone=one:10m rate=30r/m;
}