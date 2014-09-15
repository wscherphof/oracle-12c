# Instant Oracle datase server
A [Docker](https://www.docker.com/) [image](https://registry.hub.docker.com/u/wscherphof/oracle-12c/) with [Oracle Database 12c Enterprise Edition Release 12.1.0.2.0](http://www.oracle.com/technetwork/database/enterprise-edition/overview/index.html) running in [Oracle Linux 7](http://www.oracle.com/us/technologies/linux/overview/index.html)
- Default ORCL database on port 1521

## Install
1. [Install Docker](https://docs.docker.com/installation/#installation)
1. `$ docker pull wscherphof/oracle-12c`

## Run
Create and run a container named orcl:
```
$ docker run --privileged -dP --name orcl wscherphof/oracle-12c
989f1b41b1f00c53576ab85e773b60f2458a75c108c12d4ac3d70be4e801b563
```
Yes, alas, this has to run `privileged` in order to gain permission for the `mount` statement in `/tmp/start` that ups the amount of shared memory, which has a hard value of 64M in Docker; see this [GitHub issue](https://github.com/docker/docker/pull/4981)

## Connect
The default password for the `sys` user is `change_on_install`, and for `system` it's `manager`
The `ORCL` database port `1521` is bound to the Docker host through `run -P`. To find the host's port:
```
$ docker port orcl 1521
0.0.0.0:49189
```
So from the host, you can connect with `system/manager@localhost:49189/ORCL`
Though if using [Boot2Docker](https://github.com/boot2docker/boot2docker), you need the actual ip address instead of `localhost`:
```
$ boot2docker ip

The VM's Host only interface IP address is: 192.168.59.103

```
If you're looking for a databse client, consider [sqlplus](http://www.oracle.com/technetwork/database/features/instant-client/index-100365.html)
```
$ sqlplus system/manager@192.168.59.103:49189/ORCL

SQL*Plus: Release 11.2.0.4.0 Production on Mon Sep 15 14:40:52 2014

Copyright (c) 1982, 2013, Oracle.  All rights reserved.


Connected to:
Oracle Database 12c Enterprise Edition Release 12.1.0.2.0 - 64bit Production
With the Partitioning, OLAP, Advanced Analytics and Real Application Testing options

SQL> |
```

## Monitor
The container runs a process that starts up the database, and then continues to check each minute if the database is still running, and start it if it's not. To see the output of that process:
```
$ docker logs db
Fri Sep 12 20:04:48 UTC 2014

SQL*Plus: Release 12.1.0.2.0 Production on Fri Sep 12 20:04:49 2014

Copyright (c) 1982, 2014, Oracle.  All rights reserved.

Connected to an idle instance.
ORACLE instance started.

Total System Global Area 1073741824 bytes
Fixed Size		    2932632 bytes
Variable Size		  696254568 bytes
Database Buffers	  369098752 bytes
Redo Buffers		    5455872 bytes
Database mounted.
Database opened.
Disconnected from Oracle Database 12c Enterprise Edition Release 12.1.0.2.0 - 64bit Production
With the Partitioning, OLAP, Advanced Analytics and Real Application Testing options

LSNRCTL for Linux: Version 12.1.0.2.0 - Production on 12-SEP-2014 20:05:18

Copyright (c) 1991, 2014, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 12.1.0.2.0 - Production
Start Date                12-SEP-2014 20:04:48
Uptime                    0 days 0 hr. 0 min. 29 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Log File         /u01/app/oracle/diag/tnslsnr/6568827caac6/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=6568827caac6)(PORT=1521)))
Services Summary...
Service "ORCL" has 1 instance(s).
  Instance "ORCL", status READY, has 1 handler(s) for this service...
The command completed successfully
```

## Enter
There's no ssh deamon or similar configured in the image. If you need a command prompt inside the container, consider [nsenter](https://github.com/jpetazzo/nsenter) (and mind the Boot2Docker [note](https://github.com/jpetazzo/nsenter#docker-enter-with-boot2docker) there)

## Build
Should you want to modify & build your own image:

1. Download & unzip the Oracle install package (2 files) from [Oracle Tech Net](http://www.oracle.com/technetwork/database/enterprise-edition/downloads/database12c-linux-download-2240591.html); this will get you a `database` folder
1. Put the `database` folder under the `step1` folder
1. `cd` to the `step1` folder
1. `$ docker build -t oracle-12c:step1 .`
1. `$ docker run --privileged -ti --name step1 oracle-12c:step1 /bin/bash`
1. `-$ . /tmp/shm`
1. `-$ . /tmp/install` (takes about 5m)
1. `-$ exit`
1. `$ docker commit step1 oracle_12c:installed`
1. `$ cd ../step2`
1. `$ docker build -t oracle-12c:step2 .`
1. `$ docker run --privileged -ti --name step2 oracle-12c:step2 /bin/bash`
1. `-$ /tmp/create` (takes about 15m)
1. `-$ exit`
1. `$ docker commit step2 oracle_12c:created`
1. `$ cd ../step3`
1. `$ docker build -t oracle-12c .`

## License
[GNU Lesser General Public License (LGPL)](http://www.gnu.org/licenses/lgpl-3.0.txt)
