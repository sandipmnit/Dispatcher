FROM centos:7

# Download and extract dispatcher
RUN yum update -y && yum install -y httpd openssl vim unzip curl wget mod_ssl
RUN curl https://download.macromedia.com/dispatcher/download/dispatcher-apache2.4-linux-x86_64-ssl1.0-4.3.3.tar.gz -o apache2.4-linux-x86_64-ssl1.0-4.3.3.tar.gz --progress
RUN mkdir -p dispatcher
RUN tar -C dispatcher -zxvf apache2.4-linux-x86_64-ssl1.0-4.3.3.tar.gz

# Install Dispatcher Module
RUN cp "./dispatcher/dispatcher-apache2.4-4.3.3.so" "/etc/httpd/modules/mod_dispatcher.so"
WORKDIR /etc/httpd

# Copy custom configurations
RUN mkdir -p /etc/httpd/conf/ssl
COPY ./files/apache/httpd.conf /etc/httpd/conf/httpd.conf
COPY ./files/apache/extra/httpd-vhosts.conf /etc/httpd/conf/extra/httpd-vhosts.conf
COPY ./files/apache/conf/* /etc/httpd/conf/extra/
COPY ./files/apache/extra/httpd-ssl.conf /etc/httpd/conf/extra/httpd-ssl.conf
COPY ./files/apache/ssl/* /etc/httpd/conf/ssl/
COPY ./httpd-foreground /usr/local/bin/
RUN chmod +x /usr/local/bin/httpd-foreground

# Fix line endings, if files came in through git on windows configured to checkout CRLF
RUN sed -i 's/\r$//' /etc/httpd/conf/extra/* && sed -i 's/\r$//' /etc/httpd/conf/httpd.conf

# Create docroot directories and make sure the web server can right to them

RUN mkdir /var/www/html/publish
RUN chown apache:apache /var/www/html/publish
RUN echo $PATH
RUN ls -la /usr/local/bin

STOPSIGNAL WINCH

EXPOSE 80 443
CMD ["httpd-foreground"]
