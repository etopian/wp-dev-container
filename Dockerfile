FROM alpine:edge
MAINTAINER Etopian Inc. <contact@etopian.com>

LABEL   devoply.type="site" \
        devoply.cms="wordpress" \
        devoply.framework="wordpress" \
        devoply.language="php" \
        devoply.require="mariadb etopian/nginx-proxy" \
        devoply.recommend="redis" \
        devoply.description="WordPress on Nginx and PHP-FPM with WP-CLI." \
        devoply.name="WordPress" \
        devoply.params="docker run -d --name {container_name} -e VIRTUAL_HOST={virtual_hosts} -v /data/sites/{domain_name}:/DATA etopian/alpine-php-wordpress"


# Add s6-overlay
ENV S6_OVERLAY_VERSION v1.14.0.0

ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz /tmp/s6-overlay.tar.gz
RUN tar xvfz /tmp/s6-overlay.tar.gz -C /



RUN apk update \
    && apk add bash less vim nginx ca-certificates \
    php-fpm php-json php-zlib php-xml php-pdo php-phar php-openssl \
    php-pdo_mysql php-mysqli \
    php-gd php-iconv php-mcrypt \
    php-mysql php-curl php-opcache php-ctype php-apcu \
    php-intl php-bcmath php-dom php-xmlreader mysql-client && \
    apk add -u musl mysql-client pwgen mysql openssh php-cli && \
    rm -rf /var/cache/apk/*

ENV TERM="xterm" \
    DB_HOST="127.0.0.1" \
    DB_NAME="luca" \
    DB_USER="luca1" \
    DB_PASS="13lkjp0p9u"\
    WP_CLI='["wp core download","wp core config --dbname={DB_NAME} --dbuser={DB_USER} --dbpass={DB_PASS} --dbhost={DB_HOST}","wp core install --url=http:\/\/test1.trework.com --title=WordPress --admin_user=myusername --admin_password=mypassword --admin_email=myemail@email.com","wp plugin install bbpress --activate","wp plugin install https:\/\/downloads.wordpress.org\/plugin\/black-studio-tinymce-widget.2.2.5.zip"]'\
    SSH_USER="luca9"\
    SSH_PASS="demouserL3"\
    VIRTUAL_HOST=""


RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/php.ini

#RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa && ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa && ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa -b 521
ADD root /

ADD files/nginx.conf /etc/nginx/
ADD files/php-fpm.conf /etc/php/

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/bin/wp



EXPOSE 80
VOLUME ["/DATA"]
VOLUME ["/var/lib/mysql"]
ENTRYPOINT ["/init"]
