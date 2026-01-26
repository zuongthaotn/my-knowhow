server {

     listen 80;
     server_name 01ce1936.magnus.com;
     set $MAGE_ROOT /var/www/html/mage/ce_1936_01;
     include /var/www/html/mage/ce_1936_01/nginx.m1.conf.sample;
 }
