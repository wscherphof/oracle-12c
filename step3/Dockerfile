FROM wscherphof/oracle-12c:created
MAINTAINER Wouter Scherphof <wouter.scherphof@gmail.com>

RUN rm /tmp/create

EXPOSE 1521

ADD startdb.sql $ORACLE_HOME/config/scripts/startdb.sql
ADD start /tmp/start
CMD /tmp/start
