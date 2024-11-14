FROM php:8.1-apache

# Install necessary PHP extensions and other dependencies
RUN apt-get update && apt-get install -y \
    # cron \
    git \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    libxml2-dev \
    zip \
    unzip \
    curl \
    gnupg \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install mysqli pdo pdo_mysql zip intl soap exif \
    && apt-get clean

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Add opcache and max_input_vars settings
RUN { \
    echo 'opcache.enable=1'; \
    echo 'opcache.enable_cli=1'; \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=60'; \
    echo 'opcache.fast_shutdown=1'; \
    echo 'max_input_vars=5000'; \
    echo 'file_uploads = On'; \
    echo 'upload_max_filesize = 512M'; \
    echo 'post_max_size = 512M'; \
    echo 'max_execution_time = 300'; \
    echo 'max_input_time = 300'; \
    } > /usr/local/etc/php/conf.d/custom.ini

# Create moodledata directory and set permissions
RUN mkdir -p /var/www/moodledata && \
    mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/moodledata /var/www/html

# Copy the procedure script
COPY procedure.sh /usr/local/bin/procedure.sh
RUN chmod +x /usr/local/bin/procedure.sh

# COPY moodle-cron /etc/cron.d/moodle-cron
# RUN echo "* * * * * root /usr/local/bin/php /var/www/html/admin/cli/cron.php > /var/log/cron.log 2>&1" > /etc/cron.d/moodle-cron
# RUN chmod 0644 /etc/cron.d/moodle-cron
# RUN touch /var/log/cron.log

# Set the working directory
WORKDIR /var/www/html

# Expose port 80
EXPOSE 80

# Run the procedure script and start Apache
#ENTRYPOINT ["/usr/local/bin/procedure.sh"]
CMD ["apache2-foreground"]
