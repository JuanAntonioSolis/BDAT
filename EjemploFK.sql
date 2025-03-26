create database if not exists alumnos;
create table if not exists localidades(
codpostal varchar(5) not null,
localidad varchar(35),
primary key(codpostal)
);
create table if not exists pupil(
codalumno int auto_increment not null,
nombre varchar(35),
apellidos varchar(35),
localidad varchar(5),
primary key (codalumno),
foreign key (localidad) references localidades(codpostal) on update cascade on delete cascade);

describe pupil;
