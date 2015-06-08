FROM oracle-12c:created
MAINTAINER Wouter Scherphof <wouter.scherphof@gmail.com>

RUN rm /tmp/create

# Exposes the default TNS port, as well as the Enterprise Manager Express HTTP
# (8080) and HTTPS (5500) ports. 
EXPOSE 1521 5500 8080

ADD startdb.sql $ORACLE_HOME/config/scripts/startdb.sql
ADD start /tmp/start
CMD /tmp/start
