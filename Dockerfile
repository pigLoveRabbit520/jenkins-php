FROM jenkins/jenkins:lts

# if we want to install via apt
USER root
ENV php_version 7.1.16
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

COPY php-${php_version}.tar.gz /tmp
RUN apt-get install -y gcc g++ make openssl pkg-config libssl-dev  libcurl4-openssl-dev \
        libxml2 libxml2-dev libjpeg-dev libpng-dev libfreetype6-dev

RUN tar -zxvf /tmp/php-${php_version}.tar.gz -C /tmp && cd /tmp/php-${php_version} && ./configure \
            --prefix=/usr/local/php-${php_version} \
            --with-config-file-path=/usr/local/php-${php_version}/etc \
            --with-mysqli \
            --with-iconv-dir \
            --with-freetype-dir \
            --with-jpeg-dir \
            --with-png-dir \
            --with-zlib \
            --with-libxml-dir=/usr \
            --enable-xml \
            --disable-rpath  \
            --enable-bcmath \
            --enable-shmop \
            --enable-sysvsem \
            --enable-inline-optimization \
            --with-curl \
            --with-openssl \
            --enable-mbregex \
            --enable-mbstring \
            --enable-ftp \
            --with-gettext \
            --disable-fileinfo \
            --enable-maintainer-zts \
            && make && make install
            
RUN ln -sf /usr/local/php-${php_version}/bin/php /usr/local/bin/



# Create a Jenkins "HOME" for composer files.
RUN mkdir -p /home/jenkins/composer
RUN chown -R jenkins:jenkins /home/jenkins
# Install composer.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/  --filename=composer

# Go back to jenkins user.
USER jenkins

