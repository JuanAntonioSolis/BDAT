create database if not exists hospitales;
use hospitales;

create table clinica(
idClinica char(2),
Nombre varchar(30),
Ciudad varchar(20),
primary key (idClinica)
)engine = InnoDB;

create table investigacion(
IdInvestigacion char(3),
Nombre varchar(60),
IdClinica char(2),
primary key (IdInvestigacion),
foreign key (IdClinica) references clinica(IdClinica) on delete restrict on update cascade
)engine = InnoDB;

create table doctor(
IdDoctor char(3),
Nombre varchar(30),
FechaIngreso date,
Salario double,
IdSupervisor char(3),
IdClinica char(2),
primary key (IdDoctor),
foreign key (IdSupervisor) references doctor(IdDoctor) on delete set null on update cascade,
foreign key (IdClinica) references clinica(IdClinica) on delete restrict on update cascade
)engine = InnoDB;

create table participa(
IdDoctor char(3),
IdInvestigacion char(3),
Horas integer,
primary key (IdDoctor, IdInvestigacion),
foreign key (IdDoctor) references doctor(IdDoctor) on delete cascade on update cascade,
foreign key (IdInvestigacion) references investigacion(IdInvestigacion) on delete cascade on update cascade
)engine = InnoDB;

insert into clinica values
("01","Clinica Central","Madrid"),
("02","Clinica Universitaria","Salamanca"),
("03","Clinica del Sur","Valencia"),
("04","Clinica General","Bilbao"),
("05","Clinica del Mar","Barcelona"),
("06","Clinica Horizonte","Sevilla");

insert into investigacion values
("GEN", "Genetica y Cancer", "05"),
("NEU", "Neurogenerativas", "01"),
("SAL", "Salud Publica", "01"),
("ALM", "Alimentacion y Diabetes", "03"),
("TRS", "Transplantes", "06");

insert into doctor values
("D01","Ana Gomez","2000-05-10","2700",NULL,"03"),
("D02","Luis Torres","2003-07-12","1800","D01","03"),
("D03","Eva Sánchez","2008-09-15","2200","D01","03"),
("D04","Daniel Pérez","2010-01-01","1600","D01","03"),
("D05","Marta Ruiz","2012-02-20","1500","D01","03"),
("D08","Jorge Molina","1995-03-30","3000",NULL,"01"),
("D06","Iván Herrera","2005-11-11","2400","D08","01"),
("D07","Nuria Morales","2007-06-08","2300","D08","01"),
("D09","Teresa Lázaro","1999-12-25 ","2900",NULL,"06"),
("D10","Elena Cano","2004-10-10","1800","D09","06"),
("D11","Raúl Muñoz","2011-09-09","2100",NULL,"02"),
("D12","Clara Navas",NULL,"1700","D11","02"),
("D13","Hugo García","2001-08-08","2400","D09","06"),
("D14","Javier Romero","2016-04-04","1900","D08",NULL),
("D15","Patricia Díaz","2018-12-01","1700",NULL,"05"),
("D16","Adrián Gil","2019-03-15","2000","D15","05");

insert into participa values
("D01","ALM","110"),
("D01","NEU","25"),
("D02","ALM","40"),
("D04","ALM","70"),
("D08","SAL","50"),
("D07","SAL","10"),
("D06","SAL","140"),
("D08","NEU","20"),
("D09","TRS","160"),
("D13","TRS","190"),
("D14","GEN","20"),
("D15","GEN","15"),
("D16","GEN","45");

/*1. Nombres de doctores que han trabajado más de 200 horas en total.*/
select doctor.Nombre
from doctor, participa
where participa.IdDoctor = doctor.IdDoctor
group by participa.IdDoctor
having sum(horas)>200;

/*2. Nombre de las clínicas que tienen doctores cuyo apellido sea “García”.*/
select clinica.Nombre
from clinica, doctor
where doctor.IdClinica=clinica.IdClinica
and doctor.Nombre like '%García';

/*3. Nombre de las investigaciones en las que participan más de dos doctores.*/
select investigacion.Nombre
from investigacion, participa
where investigacion.IdInvestigacion = participa.IdInvestigacion
group by participa.IdInvestigacion
having count(IdDoctor) > 2;

/*4. Lista de todos los doctores junto al nombre de la clínica a la que pertenecen y el
total de dinero que reciben por participar en investigaciones (a razón de 50 €
por hora).Si no pertenecen a ninguna clínica, debe aparecer el texto “Sin Clínica
Asignada”. Ordenar alfabéticamente por el nombre del doctor*/
select doctor.Nombre, ifnull(clinica.Nombre,"Sin Clínica Asignada"), sum(horas)*50 as "Dinero recibido"
from doctor
left join clinica 
on doctor.IdClinica = clinica.IdClinica
left join participa
on participa.IdDoctor = doctor.IdDoctor
group by doctor.IdDoctor
order by 1;

/*5. Lista con el nombre de todos los doctores y el número de investigaciones en las
que participan. Si no participa en ninguna, debe aparecer la frase “Sin
investigación asignada”.*/
select doctor.Nombre, ifnull(count(IdInvestigacion),"Sin investigación asignada")
from doctor
left join participa
on participa.IdDoctor = doctor.IdDoctor
group by doctor.IdDoctor;

/*6. Lista de los doctores que trabajan en clínicas ubicadas en Madrid o Valencia.*/
select doctor.Nombre
from doctor, clinica
where doctor.IdClinica = clinica.IdClinica
and clinica.Ciudad in ("Madrid", "Valencia");

/*7. Lista alfabética de nombres de doctores y nombres de sus supervisores.
	● Si el doctor no tiene supervisor, debe aparecer el texto “Sin Supervisor”.*/
select doctor.Nombre, ifnull(jefe.Nombre, "Sin Supervisor")
from doctor
left join doctor as jefe
on doctor.IdSupervisor = jefe.IdDoctor
order by 1;

/*8. Calcular el promedio del año de ingreso de los doctores que participan en al
menos una investigación.*/
select avg(year(FechaIngreso))
from doctor, participa
where doctor.IdDoctor = participa.IdDoctor;

/*9. Nombres de los doctores cuyo apellido sea “Díaz” o “Morales” y
simultáneamente su supervisor sea Jorge Molina.*/
select doctor.Nombre
from doctor, doctor as jefe
where doctor.IdSupervisor = jefe.IdDoctor
and jefe.Nombre = "Jorge Molina"
and doctor.Nombre like '%Morales' or '%Díaz';

/*10. Listado de todas las clínicas, mostrando:
	● nombre de la clínica,
	● ciudad,
	● número de doctores que trabajan allí.
Ordenar por nombre de clínica y en caso de coincidencia por ciudad.*/
select clinica.Nombre, clinica.Ciudad, count(doctor.IdClinica) as "Numero de doctores trabajando"
from clinica, doctor
where clinica.IdClinica = doctor.IdClinica
group by doctor.IdClinica
order by 1,2;

/*11. Nombres de los doctores que han trabajado entre 10 y 100 horas en total
sumando todas sus investigaciones.*/
select doctor.Nombre
from doctor, participa
where doctor.IdDoctor = participa.IdDoctor
group by doctor.IdDoctor
having sum(horas) between 10 and 100;

/*12.Nombres de los doctores que no son supervisores de ningún otro doctor.*/
select distinct jefe.IdDoctor
from doctor, doctor as jefe
where doctor.IdSupervisor = jefe.IdDoctor;

select Nombre
from doctor
where IdDoctor not in (select distinct jefe.IdDoctor
						from doctor, doctor as jefe
						where doctor.IdSupervisor = jefe.IdDoctor);

/*13.Determinar qué clínica es la más productiva, entendiendo productividad como
el número total de horas trabajadas por los doctores en investigaciones dividido
entre el número de doctores de la clínica.*/
select clinica.Nombre
from clinica, participa, investigacion, doctor
where clinica.IdClinica = investigacion.IdClinica
and doctor.IdClinica = clinica.IdClinica
and investigacion.IdInvestigacion = participa.IdInvestigacion
group by doctor.IdClinica
having sum(horas) / count(doctor.IdClinica) = (select (sum(horas) / count(doctor.IdClinica)) 
						from participa, clinica, doctor
                        where clinica.IdClinica = doctor.idClinica
                        and participa.IdDoctor = doctor.IdDoctor
                        group by doctor.IdClinica
                        order by 1 desc limit 1);


/*14. Listado de todos los doctores. En el listado debe aparecer el nombre de los doctores,
nombres de sus clínicas y nombres de las investigaciones en las que participan. Los
doctores sin clínica aparecerán “Sin centro Hospitalario”, y los que no participen en
investigaciones aparecerán “Sin Investigación”.*/
select doctor.Nombre, ifnull(clinica.Nombre,"Sin centro Hospitalario"),ifnull(investigacion.Nombre,"Sin Investigación")
from doctor
left join clinica
on doctor.IdClinica = clinica.IdClinica
left join participa
on participa.IdDoctor = doctor.IdDoctor
left join investigacion
on participa.IdInvestigacion = investigacion.IdInvestigacion; 

/*15. Lista de los doctores con el número de días que llevan trabajando. Si no tienen
fecha, mostrar “Sin fecha de ingreso”. Ordenar por días trabajados y nombre*/
select Nombre, ifnull(datediff(current_timestamp, FechaIngreso),"Sin fecha de ingreso")
from doctor 
order by 2,1;

/*16. Lista de doctores que son supervisores de más de dos doctores, junto con el
número de doctores que supervisan.*/
select jefe.Nombre, count(doctor.IdSupervisor)
from doctor, doctor as jefe
where doctor.IdSupervisor = jefe.IdDoctor
group by jefe.IdDoctor;

/*17.Nombre de las investigaciones que contienen “Neuro”, junto con el nombre de
la clínica organizadora.*/
select investigacion.Nombre, clinica.Nombre
from investigacion, clinica
where investigacion.IdClinica = clinica.IdClinica
and investigacion.Nombre like '%Neuro%';

/*18.Asignar al doctor Javier Romero a la clínica que más gasta en sueldos.*/

create view clinicaSueldo as
select clinica.Nombre
from clinica, doctor
where clinica.IdClinica = doctor.IdClinica
group by clinica.IdClinica
having sum(salario)
order by sum(salario) desc limit 1;

select * from clinicaSueldo;

update doctor set IdClinica = (select IdClinica
								from clinica 
                                where clinica.Nombre = (select * from clinicaSueldo))
where Nombre = "Javier Romero";

select * from doctor;

/*19.Eliminar todas las clínicas sin ningún doctor asignado.*/

delete from clinica where idClinica not in (select distinct idClinica
										from doctor
                                        where idClinica is not null);                                        
select * from clinica;













                      







