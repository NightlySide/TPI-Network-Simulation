FROM debian:stretch-slim

# Update the repository sources list
RUN apt-get update -qq 

# Mysql
RUN apt-get install -y mysql-server
ADD my.cnf /etc/mysql/conf.d/my.cnf 
RUN chmod 664 /etc/mysql/conf.d/my.cnf 
ADD run /usr/local/bin/run 
RUN chmod +x /usr/local/bin/run  

# Other stuff
RUN apt-get -y install rabbitmq
RUN apt-get -y install nodejs

VOLUME ["/var/lib/mysql"] 