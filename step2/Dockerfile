FROM wscherphof/oracle-12c:installed
MAINTAINER Wouter Scherphof <wouter.scherphof@gmail.com>

USER root

RUN rm -rf /tmp/database

ENV ORACLE_SID ORCL
ENV ORACLE_HOME $ORACLE_BASE/product/12.1.0/dbhome_1
ENV PATH $ORACLE_HOME/bin:$PATH

RUN mkdir -p $ORACLE_BASE/oradata && chown -R oracle:oinstall $ORACLE_BASE/oradata && chmod -R 775 $ORACLE_BASE/oradata
RUN mkdir -p $ORACLE_BASE/fast_recovery_area && chown -R oracle:oinstall $ORACLE_BASE/fast_recovery_area && chmod -R 775 $ORACLE_BASE/fast_recovery_area

ADD initORCL.ora $ORACLE_HOME/dbs/initORCL.ora
ADD createdb.sql $ORACLE_HOME/config/scripts/createdb.sql
ADD create /tmp/create
