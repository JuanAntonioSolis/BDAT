create database ejemplo2;
use ejemplo2;

create table libro(
claveLibro int not null,
titulo varchar(60),
idioma varchar(15),
formato varchar(15),
categoria char,
claveEditorial smallint,
primary key(claveLibro),
foreign key(claveEditorial) references editorial(claveEditorial) on delete cascade on update cascade
);

create table editorial(
claveEditorial smallint,
nombre varchar(60),
direccion varchar(60),
telefono varchar (15),
primary key(claveEditorial)
);

create table tema(
claveTema smallint not null,
nombre varchar(40),
primary key (claveTema)
);

create table autor(
claveAutor int not null,
nombre varchar(60),
primary key (claveAutor)
);

create table ejemplar(
claveLibro int not null,
numeroOrden smallint not null,
edicion smallint,
ubicacion varchar(15),
primary key (claveLibro, numeroOrden),
foreign key (claveLibro) references libro(claveLibro) on update cascade on delete cascade
);

create table socio(
claveSocio int not null,
nombre varchar(60),
direccion varchar(60),
telefono varchar (15),
categoria char,
primary key(claveSocio)
);

create table prestamo(
claveSocio int not null,
claveLibro int not null,
numeroOrden smallint not null,
fechaPrestamo date not null,
fechaDev date,
notas blob,
primary key (claveSocio, claveLibro, numeroOrden, fechaPrestamo),
foreign key (claveSocio) references socio(claveSocio),
foreign key (claveLibro) references ejemplar(claveLibro),
foreign key (numeroOrden) references ejemplar(numeroOrden)
);
 





