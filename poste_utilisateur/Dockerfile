FROM tleemcjr/metasploitable2

# Update the repository sources list
RUN apt-get update -qq 

# Mysql
RUN apt-get install -y mysql-server

# Other stuff
RUN apt-get -y install rabbitmq
RUN apt-get -y install nodejs

VOLUME ["/var/lib/mysql"] 