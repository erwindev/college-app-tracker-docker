SELECT pg_terminate_backend(procpid) FROM pg_stat_activity WHERE datname = 'mydb';
drop database if exists "college";
create database "college" with encoding = 'UTF8';
drop user if exists tracker_user;
create user tracker_user with password 'tr@ck3r_u53r';