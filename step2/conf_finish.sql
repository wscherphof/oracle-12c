-- Setting Enterprise Manager Express HTTP ports.
exec dbms_xdb_config.sethttpsport(5500);
exec dbms_xdb_config.sethttpport(8080);

-- Shutdown.
shutdown immediate;

exit;
