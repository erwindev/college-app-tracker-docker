drop database if exists "college";
create database "college" with encoding = 'UTF8';
drop user if exists tracker_user;
create user tracker_user with password 'tr@ck3r_u53r';
grant all privileges on schema public to tracker_user
