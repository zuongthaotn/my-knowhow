


1. Speed Up Your Web Site With MySQL Query Caching<br/>
query_cache_size – This is the size of the cache in bytes. Setting this value to 0 will effectively disable caching.<br/>
query_cache_type – This value must be ON or 1 for query caching to be enabled by default.<br/>
query_cache_limit – This is the maximum size query (in bytes) that will be cached.<br/>
<br/>
Edit file /etc/mysql/mysql.conf.d/mysqld.cnf then find and change as below:<br/>
``` 
    query_cache_limit	= 1M
    query_cache_size        = 168M
    query_cache_type    = 1
```

2. Enable compression on NGINX webservers<br/>
Default nginx.conf.sample has it in magento installation folder.<br/>
If you got error<br/>
"Specifying the Vary: Accept-Encoding header instructs the proxy to store both a compressed and uncompressed version of the resource."
you should modify nginx.config.sample <br/>
```add_header Vary "Accept-Encoding";```
<br/>in pub/static location to similar below<br/>
```location /static/ {
       ...
       location ~* \.(ico|jpg|jpeg|png|gif|svg|js|css|swf|eot|ttf|otf|woff|woff2|json)$ {
           add_header Cache-Control "public";
           add_header X-Frame-Options "SAMEORIGIN";
           add_header Vary "Accept-Encoding";
            ...
       }
```
<br/>
3. Leverage Browser Caching for NGINX<br/>
Default nginx.conf.sample has it in magento installation folder.<br/>

4. Enable HTTP/2 in Nginx<br/>
To enable HTTP/2 in Nginx, we have to add the http2 parameter to the listen directive in our virtual host:<br/>
```
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
   
    ssl_protocols TLSv1.2;
```   
<br/>
5. Serve scaled images<br/>
TODO 
<br/>
6. Run Store in Production Mode (Magento 2 specific)<br/>
php bin/magento deploy:mode:set production<br/>
<br/>
7. Lazyload homepage images <br/>

8. Reduce server response times (TTFB)
