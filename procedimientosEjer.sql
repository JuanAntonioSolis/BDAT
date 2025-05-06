drop database if exists procedimientos;
create database if not exists procedimientos;
use procedimientos;

create table cuadrados(
numero int unsigned,
cuadrado int unsigned
)engine = InnoDB;

create table ejercicio(
numero int unsigned
)engine = InnoDB;