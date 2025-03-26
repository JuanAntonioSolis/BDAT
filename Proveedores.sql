create database proveedores;
use proveedores;

create table categoria(
id int unsigned auto_increment,
nombre varchar(100) not null,
primary key(id)
)engine = InnoDB;

create table pieza(
id int unsigned auto_increment,
nombre varchar(100) not null,
color varchar(50) not null,
precio decimal(7,2) not null,
id_categoria int unsigned not null,
primary key (id),
foreign key(id_categoria) references categoria(id) on delete restrict on update restrict
)engine = InnoDB;

insert into categoria values (1,'Categoria A'),
(2, 'Categoria B'),
(3, 'Categoria C');



