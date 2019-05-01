connect / as sysdba
shutdown immediate
startup mount
alter system set db_recovery_file_dest_size=20G;
alter system set db_recovery_file_dest='/opt/oracle/fast_recovery_area';
alter database archivelog;
alter database flashback on;
alter database open;
exit;

