create database if not exists vendedores;
use vendedores;

create table ciudad(
id_ciudad char(3),
nom_ciudad varchar(25),
primary key (id_ciudad)
)engine = InnoDB;

create table tipoart(
id_tipo char(3),
nom_tipo varchar(25),
primary key (id_tipo)
)engine = InnoDB;

create table tienda(
id_tienda char(3),
nom_tienda varchar(25),
id_ciudad char(3),
primary key (id_tienda),
foreign key (id_ciudad) references ciudad(id_ciudad) on delete cascade on update cascade
) engine= InnoDB;

create table vendedores(
id_vend char(3),
nom_vend varchar(25),
salario int,
id_tienda char(3),
primary key (id_vend),
foreign key (id_tienda) references tienda(id_tienda) on delete cascade on update cascade
)engine=InnoDB;

create table articulos(
id_art char(3),
nom_art varchar(25),
precio int,
id_tipo char(3),
primary key (id_art),
foreign key (id_tipo) references tipoart(id_tipo) on delete cascade on update cascade
)engine=InnoDB;

create table vendart(
id_vend char(3),
id_art char(3),
fech_venta date,
primary key (id_vend, id_art, fech_venta),
foreign key (id_art) references articulos(id_art) on delete cascade on update cascade
)engine=InnoDB;

insert into ciudad values('CI1','SEVILLA');
insert into ciudad values('CI2','ALMERIA');
insert into ciudad values('CI3','GRANADA');

insert into tipoart values('TI1','BAZAR');
insert into tipoart values('TI2','COMESTIBLES');
insert into tipoart values('TI3','PAPELERIA');

insert into tienda values('TD1','BAZARES S.A.','CI1');
insert into tienda values('TD2','CADENAS S.A..','CI1');
insert into tienda values('TD3','MIRROS S.L.','CI2');
insert into tienda values('TD4','LUNA','CI2');
insert into tienda values('TD5','MAS S.A.','CI3');
insert into tienda values('TD6','JOYMON','CI2');

insert into vendedores values('VN1','JUAN',1090,'TD1');
insert into vendedores values('VN2','PEPE',1034,'TD1');
insert into vendedores values('VN3','LUCAS',1100,'TD2');
insert into vendedores values('VN4','ANA',890,'TD2');
insert into vendedores values('VN5','PEPA',678,'TD3');
insert into vendedores values('VN6','MANUEL',567,'TD2');
insert into vendedores values('VN7','LORENA',1100,'TD3');

insert into articulos values('AR1','RADIO',78,'TI1');
insert into articulos values('AR2','CARNE',15,'TI2');
insert into articulos values('AR3','BLOC',5,'TI3');
insert into articulos values('AR4','DVD',24,'TI1');
insert into articulos values('AR5','PESCADO',23,'TI2');
insert into articulos values('AR6','LECHE',2,'TI2');
insert into articulos values('AR7','CAMARA',157,'TI1');
insert into articulos values('AR8','LAPIZ',1,'TI3');
insert into articulos values('AR9','BOMBILLA',2,'TI1');

insert into vendart values('VN1','AR1','2005-02-01');
insert into vendart values('VN1','AR2','2005-02-01');
insert into vendart values('VN2','AR3','2005-03-01');
insert into vendart values('VN1','AR4','2005-04-01');
insert into vendart values('VN1','AR5','2005-06-01');
insert into vendart values('VN3','AR6','2005-07-01');
insert into vendart values('VN3','AR7','2005-08-01');
insert into vendart values('VN3','AR8','2001-09-12');
insert into vendart values('VN4','AR9','2005-10-10');
insert into vendart values('VN4','AR8','2005-11-01');
insert into vendart values('VN5','AR7','2005-10-01');
insert into vendart values('VN5','AR6','2005-11-02');
insert into vendart values('VN6','AR5','2005-11-03');
insert into vendart values('VN6','AR4','2005-11-04');
insert into vendart values('VN7','AR3','2005-11-05');
insert into vendart values('VN7','AR2','2005-11-07');
insert into vendart values('VN1','AR2','2005-11-06');
insert into vendart values('VN2','AR1','2004-10-08');
insert into vendart values('VN3','AR2','1999-01-01');
insert into vendart values('VN4','AR3','2005-10-25');
insert into vendart values('VN5','AR4','2005-10-26');
insert into vendart values('VN5','AR5','2005-10-27');
insert into vendart values('VN6','AR6','2005-10-28');
insert into vendart values('VN5','AR7','2005-10-28');
insert into vendart values('VN4','AR8','2005-10-30');
insert into vendart values('VN3','AR9','2005-08-24');
insert into vendart values('VN7','AR9','2005-08-25');

/*1.- CIUDAD DONDE MAS SE VENDIO*/
select ciudad.nom_ciudad, count(vendart.id_art) as "Numero ventas"
from vendart, vendedores, tienda, ciudad
where vendart.id_vend = vendedores.id_vend
and vendedores.id_tienda = tienda.id_tienda
and tienda.id_ciudad = ciudad.id_ciudad
group by ciudad.nom_ciudad
having count(vendart.id_art)
order by 1 desc limit 1;

/*2.- TIENDA DONDE MAS SE VENDIO*/
select tienda.nom_tienda, count(vendart.id_art) as "Numero ventas"
from vendart, vendedores, tienda
where vendart.id_vend = vendedores.id_vend
and vendedores.id_tienda = tienda.id_tienda
group by 1
having count(vendart.id_art)
order by 2 desc limit 1;

/*3.- VENDEDOR QUE MAS VENDIO*/
select vendedores.nom_vend, count(vendart.id_art) as "Numero ventas"
from vendart, vendedores, tienda
where vendart.id_vend = vendedores.id_vend
group by 1
having count(vendart.id_art)
order by 2 desc limit 3;

/*4.-NOMBRE DE CIUDAD, VENDEDOR, ARTICULO, TIENDA TIPO Y PRECIO DE TODO LO VENDIDO*/
select ciudad.nom_ciudad, vendedores.nom_vend, articulos.nom_art,tienda.nom_tienda, tipoart.nom_tipo, precio
from vendart, vendedores, articulos, ciudad, tienda,tipoart
where vendart.id_art=articulos.id_art
and vendart.id_vend=vendedores.id_vend
and vendedores.id_tienda=tienda.id_tienda
and tienda.id_ciudad=ciudad.id_ciudad
and articulos.id_tipo=tipoart.id_tipo;

/*5.- NOMBRE DEL TIPO DE ARTICULO MAS CARO*/
select nom_tipo, precio
from articulos, tipoart
where articulos.id_tipo=tipoart.id_tipo
order by 2 desc limit 1;

/*6.- DATOS DEL VENDEDOR QUE MAS GANA*/
select vendedores.*
from vendedores
order by salario desc limit 2;

/*7.- MONTANTE DE TODOS LOS ARTICULOS DE TIPO BAZAR*/
select sum(precio), tipoart.nom_tipo
from vendart, articulos, tipoart
where vendart.id_art=articulos.id_art
and articulos.id_tipo=tipoart.id_tipo
and tipoart.nom_tipo = "BAZAR";

/*8.- MONTANTE DE TODO LO QUE SE VENDIO EN ALMERIA*/
select sum(precio)
from vendart, articulos, ciudad, vendedores, tienda
where vendart.id_art=articulos.id_art
and vendart.id_vend=vendedores.id_vend
and vendedores.id_tienda=tienda.id_tienda
and tienda.id_ciudad = ciudad.id_ciudad
and ciudad.nom_ciudad = "ALMERIA";

/*9.- MONTANTE DE TODO LO QUE SE VENDIO EN LUNA*/
select sum(precio)
from vendart, articulos, tienda, vendedores
where vendart.id_art=articulos.id_art
and vendart.id_vend=vendedores.id_vend
and vendedores.id_tienda=tienda.id_tienda
and tienda.nom_tienda = "LUNA";

/*10.- NOMBRE DE ARTICULO, TIPO PRECIO, TIENDA, CIUDAD Y FECHA DE LO QUE VENDIO MANUEL*/
select articulos.nom_art, tipoart.nom_tipo, precio, tienda.nom_tienda, fech_venta
from vendart, articulos, tipoart, tienda, vendedores
where vendart.id_vend=vendedores.id_vend
and vendart.id_art=articulos.id_art
and articulos.id_tipo=tipoart.id_tipo
and vendedores.id_tienda=tienda.id_tienda
and vendedores.nom_vend = "MANUEL";

/*11.- TOTAL DEL SALARIO DE TODOS LOS TRABAJADORES DE ALMERIA*/
select sum(salario)
from vendedores, ciudad, tienda
where vendedores.id_tienda=tienda.id_tienda
and tienda.id_ciudad=ciudad.id_ciudad
and ciudad.nom_ciudad = "ALMERIA";

/*12.- NOMBRE DE LOS QUE VENDIERON LECHE*/
select vendedores.nom_vend
from vendart, vendedores, articulos
where vendart.id_vend=vendedores.id_vend
and vendart.id_art=articulos.id_art
and articulos.nom_art = "LECHE";

/*13.- NOMBRE DE LOS QUE VENDIERON ARTICULOS DE TIPO BAZAR.*/
select vendedores.nom_vend
from vendart, vendedores, articulos, tipoart
where vendart.id_vend=vendedores.id_vend
and vendart.id_art=articulos.id_art
and articulos.id_tipo=tipoart.id_tipo
and tipoart.nom_tipo = "BAZAR";

/*14.- ARTICULOS DE TIPO BAZAR MAS VENDIDOS*/
select nom_art, count(vendart.id_art) as "Nº ventas"
from vendart, tipoart, articulos
where vendart.id_art=articulos.id_art
and articulos.id_tipo=tipoart.id_tipo
and tipoart.nom_tipo = "BAZAR"
group by vendart.id_art
order by 1 desc limit 3;

/*15.- NOMBRE DEL TIPO CON QUE MAS SE GANA*/
select tipoart.nom_tipo, sum(precio)
from vendart, tipoart, articulos
where vendart.id_art=articulos.id_art
and articulos.id_tipo=tipoart.id_tipo
group by vendart.id_art
order by 2 desc limit 1;

/*16.- SALARIO Y NOMBRE DE TODOS LOS QUE VENDIERON BOMBILLAS.*/
select salario, nom_vend
from vendart, articulos, vendedores
where vendart.id_art=articulos.id_art
and vendart.id_vend=vendedores.id_vend
and articulos.nom_art = "BOMBILLA";

/*17.- TIENDAS Y CIUDAD DONDE SE VENDIO ALGUNA RADIO.*/
select nom_tienda, nom_ciudad
from vendart, tienda, ciudad, articulos, vendedores
where vendart.id_art=articulos.id_art
and vendart.id_vend=vendedores.id_vend
and vendedores.id_tienda = tienda.id_tienda
and tienda.id_ciudad=ciudad.id_ciudad
and articulos.nom_art = "RADIO";

/*18.- SUBIR EL SUELDO UN 2% A LOS EMPLEADOS DE SEVILLA*/
update vendedores set salario=salario+salario*0.02
where id_tienda in (select id_tienda 
from tienda, ciudad
where tienda.id_ciudad=ciudad.id_ciudad
and nom_ciudad = "SEVILLA"); 

create view tiendaSevilla (id_tienda) as 
select id_tienda 
from tienda, ciudad
where tienda.id_ciudad=ciudad.id_ciudad
and nom_ciudad = "SEVILLA"; 
select *
from tiendaSevilla;

/*19.- BAJA EL SUELDO UN 1% A LOS QUE NO HAYAN VENDIDO LECHE*/
select nom_vend
from vendart, vendedores, articulos
where vendart.id_vend = vendedores.id_vend
and vendart.id_art = articulos.id_art
and articulos.nom_art = "LECHE";

update vendedores set salario=salario-salario*0.01
where id_vend not in (select id_vend
						from vendart, articulos
						where vendart.id_art = articulos.id_art
						and articulos.nom_art = "LECHE");
					
/*20.- SUBIR EL PRECIO UN 3% AL ARTICULO MAS VENDIDO*/
select id_art
from vendart
group by id_art
order by count(id_art) desc limit 1;

update articulos set precio=precio+precio*0.03
where id_art in (select id_art
				from vendart
				group by id_art
				order by count(id_art) desc limit 1);
                

                





