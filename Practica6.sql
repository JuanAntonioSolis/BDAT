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
select min(fecha_ingreso), max(fecha_ingreso), departamento.nombre
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
						where empleado.nombre = "Carmen Violeta")
and nombre not like "Carmen Violeta";
                        
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
and empleado.cdemp like 'B%';

/*13. Listado de nombres de departamento, ciudad del departamento y número de empleados del
departamento. Ordenada por nombre de ciudad y a igualdad de esta por el nombre del
departamento.*/
select departamento.nombre, departamento.ciudad, count(empleado.cddep) as "Numero empleados"
from departamento
left join empleado
on departamento.cddep = empleado.cddep
group by departamento.cddep
order by departamento.ciudad,1;

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
select sum(nhoras), cdpro
from trabaja
group by cdpro;

select proyecto.nombre, sum(nhoras) as "Horas trabajadas"
from trabaja, proyecto
where trabaja.cdpro=proyecto.cdpro
group by trabaja.cdpro
having sum(nhoras) = (select sum(nhoras)
					from trabaja 
                    group by cdpro
                    order by 1 desc limit 1);
                    
/*16. Lista de nombres de empleado que hayan trabajado entre 15 y 100 horas, entre todos los
proyectos en los que trabajan.*/
select empleado.nombre
from empleado, trabaja
where empleado.cdemp = trabaja.cdemp
group by trabaja.cdemp
having sum(nhoras) between 15 and 100;

/*17. Lista de empleados que no son jefes de ningún otro empleado*/
select nombre
from empleado 
where cdemp not in (select distinct cdjefe 
					from empleado 
					where cdjefe is not null);
                    
/*18. Se quiere premiar a los empleados del departamento que mejor productividad tenga. Para ello se
decide que una medida de la productividad puede ser el número de horas trabajadas por
empleados del departamento en proyectos, dividida por los empleados de ese departamento.
¿Qué departamento es el más productivo?*/
select (sum(nhoras) / count(trabaja.cdemp) ) as productividad, departamento.nombre
from trabaja, empleado, departamento
where empleado.cddep = departamento.cddep
and empleado.cdemp = trabaja.cdemp
group by trabaja.cdemp
having sum(nhoras)/count(trabaja.cdemp) = (select sum(nhoras)/count(cdemp)
											from trabaja
                                            group by cdemp
                                            order by 1 desc limit 1);

/*19. Lista donde aparezcan los nombres de empleados, nombres de sus departamentos y nombres de
proyectos en los que trabajan. Los empleados sin departamento, o que no trabajen en proyectos
aparecerán en la lista y en lugar del departamento o el proyecto aparecerá “*****”.*/
select empleado.nombre, ifnull(departamento.nombre,"*****") as "Departamento", ifnull(proyecto.nombre,"*****") as "Proyecto"
from empleado
left join departamento
on empleado.cddep = departamento.cddep
left join trabaja
on trabaja.cdemp = empleado.cdemp
left join proyecto
on proyecto.cdpro = trabaja.cdpro;

/*20. Lista de los empleados indicando el número de días que llevan trabajando en la empresa.*/
select empleado.nombre, datediff(current_timestamp,fecha_ingreso) as "Dias trabajados"
from empleado;

/*21. Número de proyectos en los que trabajan empleados de la ciudad de Córdoba.*/
select count(trabaja.cdpro) as "Numero de proyectos en Córdoba"
from trabaja, empleado, departamento
where trabaja.cdemp = empleado.cdemp
and empleado.cddep = departamento.cddep
and departamento.ciudad = "Córdoba";

/*22. Lista de los empleados que son jefes de más de un empleado, junto con el número de empleados
que están a su cargo.*/
select jefe.nombre, count(jefe.cdemp) "Numero de empleados a cargo"
from empleado, empleado as jefe
where empleado.cdjefe = jefe.cdemp
group by jefe.cdemp
having count(jefe.cdemp) > 1;

/*23. Listado que indique años y número de empleados contratados cada año, todo ordenado por orden
ascendente de año.*/
select year(fecha_ingreso), count(cdemp)
from empleado
group by 1
order by 1;

/*24. Listar los nombres de proyectos en los que aparezca la palabra “energía”, indicando también el
nombre del departamento que lo gestiona.*/
select proyecto.nombre as "Nombre proyecto", departamento.nombre as "Nombre departamento"
from proyecto, departamento
where proyecto.cddep = departamento.cddep
and proyecto.nombre like '%energía%';

/*25. Lista de departamentos que están en la misma ciudad que el departamento “Gerencia”.*/
select nombre
from departamento 
where ciudad = (select ciudad
				from departamento
                where nombre = "Gerencia")
and nombre not like "Gerencia";

/*26. Lista de departamentos donde exista algún trabajador con apellido “Amarillo”.*/
select departamento.nombre
from empleado, departamento
where empleado.cddep = departamento.cddep
and empleado.nombre like '%Amarillo%';

/*27. Lista de los nombres de proyecto y departamento que los gestiona, de los proyectos que tienen 0
horas de trabajo realizadas.*/
select proyecto.nombre as "Nombre proyecto", departamento.nombre as "Nombre departamento"
from proyecto, departamento, trabaja
where proyecto.cddep = departamento.cddep
and trabaja.cdpro = proyecto.cdpro
group by trabaja.cdpro
having sum(trabaja.nhoras) = 0;

/*28. Asignar el empleado “Manuel Amarillo” al departamento “05”*/
update empleado set cddep="05"
where nombre="Manuel Amarillo";

select * from empleado;

/*29. Borrar los departamentos que no tienen empleados.*/
delete from departamento where cddep not in(select distinct cddep
											from empleado);

select * from departamento;

/*30. Añadir todos los empleados del departamento 02 al proyecto MES.*/
insert into trabaja (cdemp,cdpro)
select cdemp, 'MES'
from empleado
where cddep = "02";

select * from trabaja
order by cdpro;































