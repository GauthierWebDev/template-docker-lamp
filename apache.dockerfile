# On récupère notre image Apache2 (httpd)
FROM httpd:2.4-alpine

# On créé un utilisateur `docker` pour le container
RUN adduser -g docker -s /bin/sh -D docker

# On active les module proxy, proxy_http et proxy_fcgi.
# Enfin, on ajoute la lecture du fichier index.php avant le fichier index.html
RUN sed -i \
    -e "s/^#\(LoadModule .*mod_proxy.so\)/\1/" \
    -e "s/^#\(LoadModule .*mod_proxy_http.so\)/\1/" \
    -e "s/^#\(LoadModule .*mod_proxy_fcgi.so\)/\1/" \
    -e "s/\(DirectoryIndex\) \(.*\)/\1 index.php \2/g" \
    /usr/local/apache2/conf/httpd.conf

# On rajoute notre virtualhost
COPY ./.docker/apache/virtualhost.conf /usr/local/apache2/conf/extra/my_vhost.conf

# On inclu notre virtualhost dans les virtualhosts à charger avec Apache
RUN echo "Include conf/extra/my_vhost.conf" >> /usr/local/apache2/conf/httpd.conf
