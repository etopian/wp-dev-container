<?php

$item[] = 'wp core download';
$item[] = 'wp core config --dbhost=127.0.0.1 --dbname={DBNAME} --dbuser={DBUSER} --dbpass={DBPASS}';
$item[] = 'wp core install --url=http://test1.trework.com --title=WordPress --admin_user=myusername --admin_password=mypassword --admin_email=myemail@email.com';
$item[] = 'wp plugin install bbpress --activate';
$item[] = 'wp plugin install https://downloads.wordpress.org/plugin/black-studio-tinymce-widget.2.2.5.zip';

print json_encode($item);
