FROM centos:latest
MAINTAINER Luke Hutton <luke.hutton.oracle@gmail.com>

ENV MYSQL_ADDRESS         0.0.0.0
ENV MYSQL_CONF            /etc/my.cnf
ENV MYSQL_VER             mysql57
ENV MYSQL_USER            mysql
ENV MYSQL_DIR             /var/lib/mysql

RUN ( curl -s https://packagecloud.io/install/repositories/imeyer/runit/script.rpm.sh | bash )

RUN cd /tmp && \
curl https://repo.mysql.com/mysql80-community-release-el7-1.noarch.rpm -O && \
ls -al && \
rpm -Uvh mysql80-community-release-el7-1.noarch.rpm && \
yum-config-manager --disable mysql80-community && \
yum-config-manager --enable $MYSQL_VER-community && \
yum install mysql-community-server -y

RUN yum install -y \
openssl \
runit && \
yum clean all && \
rm -rf /var/cache/yum

# Clean /tmp to reduce image size
RUN rm -rf /tmp/*

# Configure intial MySQL install
RUN mysqld --initialize-insecure
RUN echo "bind-address = $MYSQL_ADDRESS" >> $MYSQL_CONF
RUN chown -R $MYSQL_USER:$MYSQL_USER $MYSQL_DIR

ADD resources/ /
ADD resources/start_mysql /usr/local/bin/start_mysql
RUN chown -R $MYSQL_USER:$MYSQL_USER /usr/local/bin/start_mysql
RUN chmod +x /usr/local/bin/start_mysql

EXPOSE 3306

# Go!
CMD [ "/usr/local/bin/start_mysql" ]
