create database if not exists relacion0;
use relacion0;

create table cliente(
nif char(9) not null,
nombre varchar(25) not null,
domicilio varchar(100),
tlf varchar(25),
ciudad varchar(50),
primary key(nif)
)engine = InnoDB;

create table producto(
codigo char(4) not null,
descripcion varchar(100) not null,
precio float,
stock float,
minimo float,
check (precio>0),
primary key(codigo)
)engine=InnoDB;

create table factura(
numero int,
fecha date,
pagado bool,
totalPrecio float,
nifCliente char(9) not null,
primary key(numero),
foreign key(nifCliente) references cliente(nif) on delete cascade on update cascade
)engine = InnoDB;

create table detalle(
numero int,
codigo char(4),
unidades int,
primary key (numero, codigo),
foreign key (numero) references factura(numero) on delete cascade on update cascade,
foreign key (codigo) references producto(codigo) on delete cascade on update cascade
)engine = InnoDB;

insert into cliente values
('43434343A','Delgado Perez Marisa', 'C/Miramar, 84 3ºA', '925-200-967', 'Toledo'),
('51592939K','Lopez Val Soledad', 'C/Pez, 54 4ºC', '915-829-394', 'Madrid'),
('51639989K','Delgado Robles Ruiz', 'C/Oca, 54 5ºC', '913-859-293', 'Madrid'),
('51664372R','Gutierrez Perez Sosa', 'C/Castilla, 4 4ºA', '919-592-932', 'Madrid');

describe cliente;
SELECT * FROM cliente;

insert into producto values
('CAJ1','Caja de herramientas de plastico', '8.50', '4.00', '3'),
('CAJ2','Caja de herramientoas de metal', '12.30', '3.00', '2'),
('MAR1','Martillo Pequeño', '3.50', '5', '10'),
('MAR2','Martillo Grande', '6.50', '12', '10'),
('TOR7','Caja 100 tornillos del 7', '0.80', '20', '100'),
('TOR8','Caja 100 tornillos del 9', '0.80', '25', '100'),
('TUE1','Caja 100 tuercas del 7', '0.50', '50', '100'),
('TUE2','Caja 100 tuercas del 9', '0.50', '54', '100'),
('TUE3','Caja 100 tuercas del 12', '0.50', '60', '100');

insert into factura values
('5440','2017-09-05', TRUE, '345','51664372R'),
('5441','2017-09-06', FALSE, '1000','51592939K'),
('5442','2017-09-07', FALSE,  '789','43434343A'),
('5443','2017-09-08', TRUE,  '139.78', '51639989K'),
('5444','2017-09-09', TRUE,'567', '51639989K' ),
('5445','2017-09-10', TRUE,'100', '51592939K' );

insert into detalle values
('5440','CAJ2','2'),
('5440','MAR1','1'),
('5440','TOR7','2'),
('5440','TOR8','2'),
('5441','CAJ1','1'),
('5442','CAJ1','1'),
('5442','MAR1','2'),
('5443','TOR7','1'),
('5443','TUE1','1'),
('5444','MAR2','1'),
('5445','TOR7','5'),
('5445','TOR8','5'),
('5445','TUE2','5'),
('5445','TUE3','5');

select * from cliente;
select * from producto;
select * from factura order by totalPrecio;
select * from producto where precio > 5;
select * from producto where precio >= 5 and precio <= 10;
select * from producto where precio between 5 and 15;

replace into cliente values
('51664372R','Gutierrez Perez Sosa', 'C/Castilla, 4 4ºA', '919-592-932', 'Granada');

update producto set precio=precio*1.10;

select * from producto;

update producto set stock=20;

select * from producto;

update producto set precio=precio - precio * 0.30;

select * from producto;

update producto set precio=precio - precio *0.50 where minimo >= 100;

select * from producto;

delete from cliente where nif= "51664372R";

select*from cliente;

/*Listado de facturas que corresponden al cliente con NIF 51592939K*/
select * from factura where nifCliente='51592939K';

/**/







