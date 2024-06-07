FROM php:8-apache

ENV GLPI_VERSION=10.0.15
ENV GLPI_CONFIG_DIR=/etc/glpi
ENV GLPI_VAR_DIR=/var/lib/glpi
ENV GLPI_LOG_DIR=/var/log/glpi

RUN apt-get update && apt-get install -y -q wget
RUN wget -q https://github.com/glpi-project/glpi/releases/download/${GLPI_VERSION}/glpi-${GLPI_VERSION}.tgz \
&& tar -xzf glpi-${GLPI_VERSION}.tgz \
&& rm glpi-${GLPI_VERSION}.tgz;

RUN apt-get remove -y -q wget && apt-get -q -y autoremove && apt-get -y -q autoclean



RUN apt-get update && apt-get install -y -q zlib1g-dev libpng-dev libicu-dev libzip-dev libbz2-dev
RUN mv /var/www/html/glpi/config ${GLPI_CONFIG_DIR}
RUN mv /var/www/html/glpi/files ${GLPI_VAR_DIR}

RUN mkdir ${GLPI_LOG_DIR}

RUN chmod -R 777 ${GLPI_CONFIG_DIR}
RUN chmod -R 777 ${GLPI_VAR_DIR}
RUN chmod -R 777 ${GLPI_LOG_DIR}

RUN docker-php-ext-install mysqli
RUN docker-php-ext-install gd
RUN docker-php-ext-install intl
RUN docker-php-ext-install exif
RUN docker-php-ext-install zip
RUN docker-php-ext-install bz2
RUN docker-php-ext-install opcache

RUN chmod -R 777 /var/www/html/glpi/marketplace