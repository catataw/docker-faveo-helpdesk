FROM romeoz/docker-nginx-php:5.6

RUN apt-get update && apt-get install -y curl wget

ENV VERSION v1.9.1

RUN wget -O /tmp/ondrej-ppa-gpg.key http://ladybirdweb.com/support/uploads/ubuntu14.04/ppa_ondrej-php-gpg-key.txt && apt-key add /tmp/ondrej-ppa-gpg.key
RUN wget -O /etc/apt/sources.list.d/ondrej-php-trusty.list http://ladybirdweb.com/support/uploads/ubuntu14.04/ppa_ondrej-php-repo.txt 

RUN apt-get update && apt-get upgrade -y 

RUN apt-get install software-properties-common git sl mlocate dos2unix bash-completion openssl mariadb-server nginx php5.6-soap php5.6-json php5.6-fpm php5.6-cli php5.6-gd php5.6-mbstring php5.6-common php5.6-mcrypt php5.6-xml php5.6-curl php5.6-imap php5.6-mysql php5.6-xmlrpc -y && updatedb;


COPY ./asserts/faveo-helpdesk-conf.txt /etc/nginx/sites-enabled/app.conf

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# creating directories and cloning repository
RUN mkdir -p /opt/faveo/log && mkdir -p /opt/faveo/run;
RUN git clone https://github.com/ladybirdweb/faveo-helpdesk.git /opt/faveo/faveo-helpdesk && chown www-data:www-data /opt/faveo -R 
RUN rm -r -f conf.d/

WORKDIR /opt/faveo/

EXPOSE 80 443

CMD ["/usr/bin/supervisord"]