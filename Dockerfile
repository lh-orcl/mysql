FROM centos:latest
MAINTAINER Luke Hutton <luke.hutton.oracle@gmail.com>

ENV MYSQL_ADDRESS         0.0.0.0
ENV MYSQL_CONF            /etc/my.cnf
ENV MYSQL_VER             mysql57
ENV MYSQL_USER            mysql
ENV MYSQL_DIR             /var/lib/mysql

RUN cd /tmp && \
curl https://repo.mysql.com/mysql80-community-release-el7-1.noarch.rpm -O && \
ls -al && \
rpm -Uvh mysql80-community-release-el7-1.noarch.rpm && \
yum-config-manager --disable mysql80-community && \
yum-config-manager --enable $MYSQL_VER-community && \
yum install mysql-community-server -y

RUN yum install -y \
openssl && \
yum clean all && \
rm -rf /var/cache/yum

# Configure intial MySQL install
RUN mysqld --initialize-insecure
RUN echo "bind-address = $MYSQL_ADDRESS" >> $MYSQL_CONF
RUN chown -R $MYSQL_USER:$MYSQL_USER $MYSQL_DIR


RUN systemctl stop mysqld && \
systemctl start mysqld

EXPOSE 3306
