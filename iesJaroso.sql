create database iesJaroso;
use iesJaroso;/*Para usar una base de datos*/
create table alumno(/*Crear base de datos nueva*/
codalumno numeric(4),
nombre varchar(35),
apellido1 varchar(35),
apellido2 varchar(35),
fechaalta date,
primary key(codalumno)
);

create table ciudad(
nombre varchar(25) not null,
poblacion int null default 10000);

describe ciudad; /*Describe la base de datos*/

drop database primera; /*Borra bases de datos*/