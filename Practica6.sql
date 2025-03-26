create database if not exists Practica5;
use Practica5;

create table departamento(
cddep char(2),
nombre varchar(30),
ciudad varchar(20),
primary key(cddep)
)engine = InnoDB;

create table empleado(
cdemp char(3),
nombre varchar(30),
fecha_ingreso date,
cdjefe char(3),
cddep char(2),
primary key(cdemp),
foreign key(cddep) references departamento(cddep) on update cascade on delete restrict,
foreign key(cdjefe) references empleado(cdemp) on update cascade on delete set null
)engine = InnoDB;

create table proyecto(
cdpro char(3),
nombre varchar(30),
cddep char(2),
primary key (cdpro),
foreign key (cddep) references departamento(cddep) on update cascade on delete restrict
)engine = InnoDB;

create table trabaja(
cdemp char(3),
cdpro char(3),
nhoras integer,
primary key (cdemp, cdpro),
foreign key(cdemp) references empleado(cdemp) on update cascade on delete cascade,
foreign key(cdpro) references proyecto(cdpro) on update cascade on delete cascade
)engine = InnoDB;

insert into departamento values
("01", "Contabilidad-1", "Almería"),
("02", "Ventas", "Almería"),
("03", "I+D", "Málaga"),
("04", "Gerencia", "Córdoba"),
("05", "Administración", "Córdoba"),
("06", "Contabilidad-2", "Córdoba");

insert into empleado values
("A11", "Esperanza Amarillo", "1993-09-23",NULL,"04"),
("B09", "Pablo Verde", "1998-10-12","A11","03"),
("A07", "Elena Blanco", "1994-04-09","A11","02"),
("B06","Carmen Violeta","1997-02-03","A07","02"),
("A03", "Pedro Rojo", "1995-03-07","A11", "01"),
("C01", "Juan Rojo", "1997-02-03", "A03", "01"),
("B02", "Maria Azul", "1996-01-09", "A03", "01"),
("C04", "Ana Verde", NULL, "A07	", "02"),
("C05", "Alfonso Amarillo", "1998-12-03", "B06", "02"),
("C08", "Javier Naranja", NULL, "B09", "03"),
("A10", "Dolores Blanco	", "1998-11-15", "A11", "04"),
("B12", "Juan Negro", "1997-02-03", "A11", "05"),
("A13", "Jesús Marrón", "1999-02-21", "A11", "05"),
("A14", "Manuel Amarillo", "2000-09-01", "A11", NULL);

insert into proyecto values
("GRE","Gestión residuos","03"),
("DAG","Depuración de aguas","03"),
("AEE","Análisis económico energías","04"),
("MES","Marketing de energía solar","02");

insert into trabaja values
("C01", "GRE", "10"),
("C08", "GRE", "54"),
("C01", "DAG", "5"),
("C08", "DAG", "150"),
("B09", "DAG", "100"),
("A14", "DAG", "10"),
("A11", "AEE", "15"),
("C04", "AEE", "20"),
("A11", "MES", "0"),
("A03", "MES", "0");

/*1. Nombre de los empleados que han trabajado más de 50 horas en proyectos*/
select distinct empleado.nombre
from trabaja, empleado
where trabaja.cdemp=empleado.cdemp
and trabaja.nhoras > 50;

/*2. Nombre de los departamentos que tienen empleados con apellido "Verde"*/
select departamento.nombre
from departamento, empleado
where departamento.cddep = empleado.cddep
and empleado.nombre like '% Verde';

/*3. Nombre de los proyectos en los que trabajan más de dos empleados*/
select count(cdemp) 
from trabaja
group by cdemp
order by 1 desc;

select proyecto.nombre, count(cdemp) as "Cuantos empleados"
from trabaja, proyecto
where trabaja.cdpro = proyecto.cdpro
group by trabaja.cdpro
having count(cdemp) > 2;

/*4. Lista de los empleados y el departamento al que pertenecen, con indicación del dinero total que deben percibir,
a razón de 35€ la hora. La lista se presentará ordenada por orden alfabético de nombre de empleado, y en caso de que
no pertenezcan a ningún departamento debe aparecer la palabra "DESCONOCIDO"*/
select distinct empleado.nombre, ifnull(departamento.nombre,"DESCONOCIDO") as "Nombre departamento", (nhoras*35) as "Dinero a percibir"
from departamento 
right join empleado
on departamento.cddep = empleado.cddep
left join trabaja
on trabaja.cdemp = empleado.cdemp
order by empleado.nombre asc;

/*5. Lista de los nombres de todos los empleados, y el número de proyectos en los que está
trabajando (ten en cuenta que algunos empleados no trabajan en ningúb proyecto). */
select empleado.nombre, count(trabaja.cdpro) as "Numero de proyectos"
from empleado
left join trabaja
on empleado.cdemp = trabaja.cdemp
group by empleado.cdemp;

/*6. Lista de empleados que trabajan en Málaga o en Almería.*/
select distinct empleado.nombre
from empleado, departamento
where empleado.cddep = departamento.cddep
and departamento.ciudad in ("Almeria","Malaga");

/*7. Lista alfabética de los nombres de empleado y los nombres de sus jefes. Si el empleado no tiene
jefe debe aparecer la cadena “Sin Jefe”.*/
select empleado.nombre, ifnull(jefe.nombre,"Sin Jefe")
from empleado
left join empleado as jefe
on empleado.cdjefe = jefe.cdemp
order by empleado.nombre;

/*8. Fechas de ingreso mínima. y máxima, por cada departamento.*/
select min(fecha_ingreso), max(fecha_ingreso), departamento.cddep
from empleado 
right join departamento
on empleado.cddep = departamento.cddep
group by departamento.cddep;

/*9. Nombres de empleados que trabajan en el mismo departamento que Carmen Violeta.*/
select cddep
from empleado
where empleado.nombre = "Carmen Violeta";

select empleado.nombre
from empleado
where empleado.cddep = (select cddep
						from empleado
						where empleado.nombre = "Carmen Violeta");
                        
/*10. Media del año de ingreso en la empresa de los empleados que trabjan en algún proyecto.*/
select avg(year(fecha_ingreso))
from empleado, trabaja
where empleado.cdemp = trabaja.cdemp
and trabaja.nhoras > 0;

/*11. Nombre de los empleados que tienen de apellido Verde o Rojo, y simultáneamente su jefa es
Esperanza Amarillo*/

select empleado.nombre
from empleado, empleado as jefe
where empleado.cdjefe = jefe.cdemp
and (empleado.nombre like '%Verde' or empleado.nombre like '%Rojo')
and jefe.nombre = "Esperanza Amarillo";

/*12. Suponiendo que la letra que forma parte del código de empleado es la categoría laboral, listar los
empleados de categoría B que trabajan en algún proyecto.*/
select empleado.nombre
from empleado, trabaja
where empleado.cdemp = trabaja.cdemp
and empleado.cdemp like 'B%'
and trabaja.nhoras > 0;

/*13. Listado de nombres de departamento, ciudad del departamento y número de empleados del
departamento. Ordenada por nombre de ciudad y a igualdad de esta por el nombre del
departamento.*/
select departamento.nombre, departamento.ciudad, count(empleado.cddep) as "Numero empleados"
from departamento
left join empleado
on departamento.cddep = empleado.cddep
group by departamento.cddep
order by departamento.ciudad;

/*14. Lista de nombres de proyecto y suma de horas trabajadas en él, de los proyectos en los que se ha
trabajado más horas de la media de horas trabajadas en todos los proyectos.*/
select proyecto.nombre, sum(nhoras)
from proyecto, trabaja
where trabaja.cdpro = proyecto.cdpro
group by trabaja.cdpro
having sum(nhoras) > (select avg(nhoras)
					from trabaja);

select avg(nhoras)
from trabaja;

/*15. Nombre de proyecto y horas trabajadas, del proyecto en el que más horas se ha trabajado*/
select sum(nhoras)
from trabaja
group by cdpro;

select proyecto.nombre, sum(nhoras) as "Horas trabajadas"

























