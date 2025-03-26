create database if not exists TIENDA;
use TIENDA;

create table Fabricantes(
clave_fabricante int,
nombre varchar(30),
primary key(clave_fabricante)
)engine = InnoDB;

create table Articulos(
clave_articulo int,
nombre varchar(30),
precio int,
clave_fabricante int,
primary key(clave_articulo),
foreign key(clave_fabricante) references Fabricantes(clave_fabricante) on delete cascade on update cascade
)engine = InnoDB;

show tables;

describe Articulos;

insert into Fabricantes values
('1', 'Kingston'),
('2', 'Adata'),
('3', 'Logitech'),
('4', 'Lexar'),
('5', 'Seagate');

insert into Articulos values
('1', 'Teclado', '100','3'),
('2', 'Disco duro 300Gb', '500','5'),
('3', 'Mouse', '80','3'),
('4', 'Memoria USB', '140','4'),
('5', 'Memoria RAM', '290','1'),
('6', 'Disco duro extraíble 250Gb', '650','5'),
('7', 'Memoria USB', '279','1'),
('8', 'DVD Rom', '450','2'),
('9', 'CD Rom', '200','2'),
('10', 'Tarjeta de red', '180','3');

/*a) Obtener todos los datos de los productos de la tienda*/
select * 
from Articulos;

/*b) Obtener los nombre de los productos de la tienda*/
select Articulos.nombre
from Articulos;

/*c) Obtener los nombres y precio s de los productos de la tienda*/
select Articulos.nombre, precio
from Articulos;

/*d) Obtener los nombre de los artículos sin repeticiones*/
select distinct Articulos.nombre
from Articulos;

/*e) Obtener todos los datos del artículo cuya clave de producto es '5'*/
select * 
from Articulos
where Articulos.clave_articulo = '5';

/*f) Obtener todos los datos del artículo cuyo nombre del producto es 'Teclado'*/
select *
from Articulos
where Articulos.nombre like 'Teclado';

/*g) Obtener todos los datos de la Memoria RAM y Memorias USB*/
select *
from Articulos
where Articulos.nombre='Memoria RAM' 
or Articulos.nombre='Memoria USB';

/*h) Obtener todos los datos de los artículos que empiezan con 'M'*/
select *
from Articulos
where Articulos.nombre like 'M%';

/*i) Obtener el nombre de los productos donde el precio sea 100$*/
select Articulos.nombre
from Articulos
where precio=100;

/*j) Obtener el nombre de los productos donde el precio sea mayor a 200$*/
select Articulos.nombre
from Articulos
where precio > 200;

/*k) Obtener todos los datos de los artículos cuyo precio esté entre 100$ y 350$*/
select *
from Articulos
where precio between 100 and 350;

/*l) Obtener el precio medio de todos los productos*/
select avg(precio)
from Articulos;

/*m) Obtener el precio medio de los artículos cuyo código de fabricante sea 2*/
select avg(precio)
from Articulos
where Articulos.clave_fabricante=2;

/*n) Obtener el nombre y precio de los artículos ordenados por nombre*/
select Articulos.nombre, precio
from Articulos
order by Articulos.nombre;

/*o) Obtener todos los datos de los productos ordenados descendentemente por precio*/
select *
from Articulos
order by precio desc;

/*p) Obtener el nombre y precio de los artículos cuyo precio sea mayor a $250 y ordenarlos
descendentemente y luego ascendentemente por nombre*/
select Articulos.nombre, precio
from Articulos
where precio > 250
order by Articulos.nombre desc;

select Articulos.nombre, precio
from Articulos
where precio > 250
order by Articulos.nombre asc;

/*q) Obtener un listado completo de los productos, incluyendo por cada artículo los datos 
del artículo y del fabricante*/
select Articulos.*,Fabricantes.nombre
from Articulos, Fabricantes
where Articulos.clave_fabricante=Fabricantes.clave_fabricante;

/*r) Obtener la clave de producto, nombre del producto y nombre del fabricante de todos los
productos en venta*/
select Articulos.clave_articulo, Articulos.nombre, Fabricantes.nombre
from Articulos, Fabricantes
where Articulos.clave_fabricante=Fabricantes.clave_fabricante;

/*s) Obtener el nombre y precio de los articulos donde el fabricante sea Logitech ordenarlos
alfabéticamente por nombre del producto*/
select Articulos.nombre, precio
from Articulos, Fabricantes
where Articulos.clave_fabricante=Fabricantes.clave_fabricante
and Fabricantes.nombre like "Logitech"
order by Articulos.nombre;

/*t) Obtener el nombre, precio y nombre de fabricante de los productos que son marca Lexar
o Kingston ordenados descendentemente por precio*/
select Articulos.nombre, precio, Fabricantes.nombre
from Articulos, Fabricantes
where Articulos.clave_fabricante=Fabricantes.clave_fabricante
and (Fabricantes.nombre='Lexar'
or Fabricantes.nombre='Kingston')
order by precio desc;

/*u) Añade un nuevo producto: Clave del producto 11, Altavoces de 120$ del fabricante 2*/
insert into Articulos values
('11','Altavoces','120','2');

/*v) Cambia el nombre del producto 6 a 'Impresora Laser'*/
replace into Articulos values
('6','Impresora Laser', '650','5');

/*w) Aplicar un descuento del 10% a todos los productos*/
update Articulos 
set precio=precio - (precio *0.10);

select precio 
from Articulos;

/*x) Aplicar un descuento de 10$ a todos los productos cuyo precio sea mayor o igual a 300$*/
update Articulos
set precio=precio + 10
where precio >= 300;

select precio 
from Articulos;

/*z) Borra el producto numero 6*/
delete from Articulos
where Articulos.clave_articulo = 6;

select * 
from Articulos;

/*Cuántos articulos hay por cada fabricante*/
select count(clave_articulo), Articulos.clave_fabricante
from Articulos, Fabricantes
where Articulos.clave_fabricante=Fabricantes.clave_fabricante
group by Fabricantes.clave_fabricante;

/*Media del precio de los articulos de cada fabricante*/
select avg(precio) as 'Media', Fabricantes.nombre
from Articulos, Fabricantes
where Articulos.clave_fabricante=Fabricantes.clave_fabricante
group by Fabricantes.nombre;









