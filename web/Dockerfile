FROM centos:6.9

ENV PHP_VERSION 5.3.20
ENV ORACLE_HOME /opt/oracle/instantclient_11_2
ENV PHP_INI /usr/local/lib/php.ini

WORKDIR /tmp
RUN yum install -y gcc wget libxml2-devel openssl-devel curl-devel openssl openssl-devel unzip vim git

# make apache
RUN wget http://archive.apache.org/dist/httpd/httpd-2.2.15.tar.gz \
    && tar zxf httpd-2.2.15.tar.gz

WORKDIR /tmp/httpd-2.2.15
RUN ./configure --enable-ssl=shared --with-ssl=/usr/bin/openssl --enable-so --enable-mods-shared=all --enable-proxy=shared --enable-rewrite=shared --prefix=/usr/local/apache\
    && make \
    && make install \
    && useradd -s /sbin/nologin www \
    && mkdir -p /usr/local/apache/conf/virtual/ \
    && mkdir -p /etc/httpd/conf/ \
    && cp /tmp/httpd-2.2.15/build/rpm/httpd.init /etc/rc.d/init.d/httpd \
    && ln -s /usr/local/apache/bin/httpd /usr/sbin/httpd \
    && ln -s /usr/local/apache/conf/httpd.conf /etc/httpd/conf/httpd.conf \
    && echo 'ServerName local_web' >> /etc/httpd/conf/httpd.conf \
    && echo 'Include /usr/local/apache/conf/virtual/*.conf' >> /etc/httpd/conf/httpd.conf \
    && echo 'AddType application/x-httpd-php .php' >> /etc/httpd/conf/httpd.conf \
    && chkconfig --add httpd \
    && chkconfig httpd on \
    && chkconfig --list | grep httpd

# mysql install
WORKDIR /tmp
RUN yum install -y http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm \
    && yum install -y mysql mysql-devel mysql-server mysql-utilities \
    && ln -s /usr/lib64/mysql/libmysqlclient.so /usr/lib64/libmysqlclient.so 

# Install Oracle Instantclient
COPY instantclient-basic-linux.x64-11.2.0.4.0.zip /tmp/
COPY instantclient-sdk-linux.x64-11.2.0.4.0.zip /tmp/
COPY instantclient-sqlplus-linux.x64-11.2.0.4.0.zip /tmp/

RUN mkdir /opt/oracle \
    && cd /opt/oracle \
    && unzip /tmp/instantclient-basic-linux.x64-11.2.0.4.0.zip -d /opt/oracle \
    && unzip /tmp/instantclient-sdk-linux.x64-11.2.0.4.0.zip -d /opt/oracle \
    && unzip /tmp/instantclient-sqlplus-linux.x64-11.2.0.4.0.zip -d /opt/oracle \
    && ln -s $ORACLE_HOME/libclntsh.so.11.1 $ORACLE_HOME/libclntsh.so \
    && ln -s $ORACLE_HOME/libclntshcore.so.11.1 $ORACLE_HOME/libclntshcore.so \
    && ln -s $ORACLE_HOME/libocci.so.11.1 $ORACLE_HOME/libocci.so \
    && rm -rf /tmp/*.zip

# make php5.3.20
RUN yum install -y php-mbstring
WORKDIR /tmp
RUN wget http://museum.php.net/php5/php-5.3.20.tar.gz \
    && tar zxf php-5.3.20.tar.gz \
    && wget http://elders.princeton.edu/data/puias/unsupported/6/x86_64/libmcrypt-2.5.8-9.puias6.x86_64.rpm \
    && wget http://elders.princeton.edu/data/puias/unsupported/6/x86_64/libmcrypt-devel-2.5.8-9.puias6.x86_64.rpm \
    && rpm -ivh libmcrypt-2.5.8-9.puias6.x86_64.rpm \
    && rpm -ivh libmcrypt-devel-2.5.8-9.puias6.x86_64.rpm

WORKDIR /tmp/php-5.3.20
RUN ./configure --enable-mbstring --with-pear --with-apxs2=/usr/local/apache/bin/apxs -with-mysql=/usr/bin/ --with-libdir=lib64 --with-iconv-dir=/usr/bin/iconv --with-pear --with-curl --with-zlib --with-openssl --enable-pdo --with-pdo-mysql --with-oci8=shared,instantclient,$ORACLE_HOME \
    && make \
    && make install

# oci8
WORKDIR /tmp/php-5.3.20/ext/oci8
RUN phpize \
    && ./configure --with-oci8=shared,instantclient,$ORACLE_HOME \
    && make \
    && make install

# pdo_oci
WORKDIR /tmp/php-5.3.20/ext/pdo_oci
RUN phpize \
    && ./configure --with-pdo_oci=instantclient,$ORACLE_HOME,11.2 \
    && make \
    && make install

# php.ini config
RUN cp /tmp/php-5.3.20/php.ini-production $PHP_INI \
    && echo 'date.timezone = Asia/Tokyo' >> $PHP_INI \
    && echo 'extension=oci8.so' >> $PHP_INI \
    && echo 'extension=pdo_oci.so' >> $PHP_INI

# set your project
RUN mkdir -p $ORACLE_HOME/network/admin \
    && chmod -R 777 /home/www/ \
    && mkdir -p /home/www/project \
    && mkdir -p /home/www/share \
    && mkdir -p /home/log \
    && chmod -R 777 /home/log/

RUN ln -s /home/www/share/tnsnames.ora $ORACLE_HOME/network/admin/tnsnames.ora

# exec.
CMD ["/sbin/init"]