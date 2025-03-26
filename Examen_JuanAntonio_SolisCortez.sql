create database if not exists pruebaPractica;
use pruebaPractica;

create table provincia(
id_prov char(3) not null,
nom_prov varchar(15) not null,
primary key(id_prov)
)engine = InnoDB;

create table if not exists ciudad(
id_ciud char(3) not null,
nom_ciud varchar(20) not null,
num_hab int not null,
id_prov char(3)not null,
primary key(id_ciud),
foreign key(id_prov) references provincia(id_prov) on delete cascade on update cascade
)engine = InnoDB;

create table zona(
id_zona char(3) not null,
nom_zona varchar(10) not null,
id_ciud char(3) not null,
primary key(id_zona, id_ciud),
foreign key(id_ciud) references ciudad(id_ciud) on delete cascade on update cascade
)engine = InnoDB;

create table cartero(
id_cart char(3) not null,
nom_cart varchar(25) not null,
sueldo int not null,
primary key	(id_cart)
)engine = InnoDB;

create table periodos(
id_per char(3) not null,
fecha_ini date not null,
fecha_fin date not null,
primary key (id_per)
)engine = InnoDB;

create table relacion(
id_zona char(3) not null,
id_ciud char(3) not null,
id_cart char(3) not null,
id_per char(3) not null,
primary key(id_zona, id_ciud, id_cart, id_per),
foreign key (id_zona, id_ciud) references zona(id_zona,id_ciud) on delete cascade on update cascade,
foreign key (id_cart) references cartero(id_cart) on delete cascade on update cascade,
foreign key (id_per) references periodos(id_per) on delete cascade on update cascade
)engine = InnoDB;

insert into provincia values
('P01','SEVILLA'),
('P02','GRANADA'),
('P03','ALMERIA');

insert into ciudad values
('C01','CIUDAD1','890000','P01'),
('C02','CIUDAD2','110000','P02'),
('C03','CIUDAD3','98000','P03'),
('C04','CIUDAD4','65000','P01');
 
insert into zona values
('Z01', 'CENTRO', 'C01'),
('Z02', 'ESTE', 'C01'),
('Z03', 'OESTE', 'C01'),
('Z04', 'NORTE', 'C01'),
('Z05', 'SUR', 'C01'),
('Z01', 'CENTRO', 'C02'),
('Z02', 'POLIGONO', 'C02'),
('Z03', 'OESTE', 'C02'),
('Z04', 'NORTE', 'C02'),
('Z05', 'SUR', 'C02'),
('Z01', 'CENTRO', 'C03'),
('Z02', 'ESTE', 'C03'),
('Z03', 'BARRIADAS', 'C03'),
('Z04', 'NORTE', 'C03'),
('Z05', 'SUR', 'C03'),
('Z01', 'CENTRO', 'C04'),
('Z02', 'BULEVARD', 'C04'),
('Z03', 'OESTE', 'C04'),
('Z04', 'NORTE', 'C04'),
('Z05', 'RIVERA', 'C04');

insert into cartero values
('CT1', 'JUAN PEREZ','1100'),
('CT2', 'ANA TORRES','1080'),
('CT3', 'PEPA FERNANDEZ','1100'),
('CT4', 'VICENTE VALLES','1790'),
('CT5', 'FERNANDO GINES','1013'),
('CT6', 'LISA TORMES','897'),
('CT7', 'WALDO PEREZ','899'),
('CT8', 'KIKA GARCIA','987'),
('CT9', 'LOLA JIMENEZ','1123');

insert into periodos values
('PE1', '2000-05-01', '2000-03-30'),
('PE2', '2000-03-30', '2000-08-15'),
('PE3', '2000-08-15', '2000-11-20'),
('PE4', '2000-11-20', '2000-12-25'),
('PE5', '2000-12-25', '2001-03-03');

insert into relacion values
('Z01','C01','CT1','PE1'),
('Z01','C02','CT2','PE1'),
('Z01','C03','CT3','PE1'),
('Z01','C04','CT4','PE1'),
('Z02','C01','CT5','PE1'),
('Z02','C02','CT6','PE1'),
('Z02','C03','CT7','PE1'),
('Z02','C04','CT8','PE1'),
('Z03','C01','CT9','PE1'),
('Z03','C02','CT1','PE2'),
('Z03','C03','CT2','PE2'),
('Z03','C04','CT3','PE2'),
('Z04','C01','CT4','PE2'),
('Z04','C02','CT5','PE2'),
('Z04','C03','CT6','PE2'),
('Z04','C04','CT7','PE2'),
('Z05','C01','CT8','PE2'),
('Z05','C02','CT9','PE2'),
('Z05','C03','CT1','PE3'),
('Z05','C04','CT2','PE3'),
('Z01','C01','CT3','PE3'),
('Z02','C02','CT4','PE3'),
('Z03','C01','CT5','PE3'),
('Z04','C01','CT6','PE3'),
('Z05','C01','CT7','PE3'),
('Z01','C01','CT8','PE4'),
('Z02','C03','CT9','PE3'),
('Z03','C04','CT1','PE4'),
('Z04','C01','CT2','PE4'),
('Z05','C01','CT3','PE4');

/*1.- NOMBRE DE LA CIUDAD CON MÁS HABITANTES*/
select nom_ciud, num_hab
from ciudad 
where num_hab=(select max(num_hab) from ciudad);

/*2.- NOMBRE DEL CARTERO CON MAYOR SUELDO*/
select nom_cart
from cartero 
where sueldo=(select max(sueldo) from cartero);

/*3.- NOMBRE CIUDADES, Nº HABITANTES DE LA PROVINCIA DE SEVILLA*/
select nom_ciud, num_hab
from ciudad, provincia
where ciudad.id_prov = provincia.id_prov
and nom_prov='SEVILLA';

/*4.- CARTEROS ORDENADOS POR SUELDO*/
select nom_cart
from cartero
order by sueldo;

/*5.- NOMBRE DE CIUDAD Y NOMBRE DE ZONA*/
select nom_zona, nom_ciud
from zona, ciudad
where zona.id_ciud=ciudad.id_ciud;

/*6.- ZONAS DE LA 'C02'*/
select nom_zona
from zona
where zona.id_ciud='C02';

/*7.- ZONAS DE LA CIUDAD 'CIUDAD3'*/
select nom_zona
from zona, ciudad
where zona.id_ciud=ciudad.id_ciud
and ciudad.nom_ciud='CIUDAD3';

/*8. NOMBRE DE LOS CARTEROS QUE HAN TRABAJADO EN LA ZONA 'Z01,C02'*/
select nom_cart
from relacion, cartero
where relacion.id_cart=cartero.id_cart
and relacion.id_zona = 'Z01'
and relacion.id_ciud = 'C02';

/*9. Nombre de los carteros que han trabajado en la zona centro de la 'CIUDAD1'*/
select nom_cart
from relacion, cartero, zona, ciudad
where relacion.id_cart=cartero.id_cart
and relacion.id_ciud=ciudad.id_ciud
and zona.id_ciud=ciudad.id_ciud
and relacion.id_zona=zona.id_zona
and ciudad.nom_ciud='CIUDAD1'
and zona.nom_zona='CENTRO';

/*10. NOMBRE DE LOS CARTEROS(Y FECHAS DE INICIO Y FIN) QUE HAN TRABAJADO EN LA RIVERA DE LA 
CIUDAD 4*/
select nom_cart, fecha_ini, fecha_fin
from relacion, cartero, zona, ciudad, periodos
where relacion.id_cart=cartero.id_cart
and relacion.id_ciud=ciudad.id_ciud
and zona.id_ciud=ciudad.id_ciud
and relacion.id_zona=zona.id_zona
and relacion.id_per=periodos.id_per
and ciudad.nom_ciud='CIUDAD4'
and zona.nom_zona='RIVERA';

/*11. NOMBRE DE LOS CARTEROS QUE HAN TRABAJADO EN LA PROVINCIA DE SEVILLA*/
select distinct nom_cart
from relacion, cartero, ciudad, provincia
where relacion.id_cart=cartero.id_cart
and relacion.id_ciud=ciudad.id_ciud
and ciudad.id_prov=provincia.id_prov
and provincia.nom_prov='SEVILLA';

/*12. NOMBRE DE LOS CARTEROS QUE HAN TRABAJADO EN EL PERIODO PE4 Y NOMBRE DE LA CIUDAD EN QUE 
ESTABAN TRABAJANDO*/
select nom_cart, nom_ciud
from relacion, cartero, periodos, ciudad
where relacion.id_cart=cartero.id_cart
and relacion.id_ciud=ciudad.id_ciud
and relacion.id_per=periodos.id_per
and periodos.id_per='PE4';

/*13. CARTEROS QUE HAN TRABAJADO EN LA 'CIUDAD1' Y FECHA DE INICIO Y FIN EN QUE LO HAN HECHO*/
select nom_cart, fecha_ini, fecha_fin
from relacion, cartero, periodos, ciudad
where relacion.id_cart=cartero.id_cart
and relacion.id_ciud=ciudad.id_ciud
and relacion.id_per=periodos.id_per
and ciudad.nom_ciud='CIUDAD1';

/*14. CARTEROS QUE HAN TRABAJADO EN LA PROVINCIA DE ALMERIA NOMBRE DE ZONA Y CIUDAD Y FECHAS
EN QUE LO HAN HECHO*/
select nom_cart, nom_zona, nom_ciud, fecha_ini, fecha_fin
from relacion, cartero, periodos, ciudad, provincia, zona
where relacion.id_cart=cartero.id_cart
and relacion.id_ciud=ciudad.id_ciud
and relacion.id_per=periodos.id_per
and relacion.id_zona=zona.id_zona
and ciudad.id_prov=provincia.id_prov
and zona.id_ciud=ciudad.id_ciud
and provincia.nom_prov='ALMERIA';

/*15. NUMERO DE HABITANTES DE CADA PROVINCIA*/
select sum(num_hab), nom_prov
from ciudad, provincia
where ciudad.id_prov=provincia.id_prov
group by ciudad.id_prov;

/*16. NOMBRE Y SUELDO DEL CARTERO QUE MÁS PERIODOS HA TRABAJADO*/
select count(id_per), nom_cart, sueldo
from relacion, cartero
where relacion.id_cart=cartero.id_cart
group by relacion.id_cart
having count(id_per)=(select count(id_per)
					from relacion
					group by id_cart
					order by 1 desc limit 1);

/*17. NOMBRE DE LA CIUDAD QUE MAS CARTEROS HA TENIDO*/
select count(id_cart), id_ciud
from relacion
group by id_ciud;

select count(id_cart), nom_ciud
from relacion, ciudad
where relacion.id_ciud=ciudad.id_ciud
group by relacion.id_ciud
having count(id_cart)=(select count(id_cart)
						from relacion
						group by id_ciud
						order by 1 desc limit 1);
                        
/*18. NOMBRE DE LA ZONA QUE MAS CARTEROS HA TENIDO(Y Nº DE CARTEROS)*/
select count(id_cart), id_zona, id_ciud
from relacion
group by id_zona, id_ciud
order by 1 desc;

select count(id_cart), nom_zona
from relacion, zona
where relacion.id_zona = zona.id_zona
and relacion.id_ciud = zona.id_ciud
group by relacion.id_zona, relacion.id_ciud
having count(id_cart)=(select count(id_cart)
						from relacion
						group by id_zona, id_ciud
						order by 1 desc limit 1); 

/*19. NOMBRE/S Y SUELDO/S DEL CARTERO QUE HA REPARTIDO EN EL ESTE DE LA CIUDAD 3*/
select nom_cart, sueldo
from relacion, cartero, ciudad, zona
where relacion.id_zona = zona.id_zona
and relacion.id_ciud = zona.id_ciud
and relacion.id_cart = cartero.id_cart
and zona.id_ciud = ciudad.id_ciud
and zona.nom_zona='ESTE'
and ciudad.nom_ciud = 'CIUDAD3';

/*20. NOMBRE DE LOS CARTEROS QUE NO HAN TRABAJADO EN LA PROVINCIA DE SEVILLA*/
select distinct nom_cart
from cartero
where id_cart not in (select id_cart
					from relacion,provincia, ciudad
					where  relacion.id_ciud = ciudad.id_ciud
					and ciudad.id_prov = provincia.id_prov
					and provincia.nom_prov like 'SEVILLA');
                    

					
				




