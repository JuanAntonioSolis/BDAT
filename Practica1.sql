create database if not exists relacion1;
use relacion1;

create table  alumno(
id_al char(3),
nom_al varchar(40),
fech_al date,
telf_al varchar(9),
primary key (id_al)
)engine = InnoDB;

create table profesor(
id_prof char(3),
nom_prof varchar(40),
fech_prof date,
telf_prof varchar(9),
primary key (id_prof)
)engine = InnoDB;

create table relacion(
id_al char(3),
id_prof char(3),
nota double,
primary key (id_al,id_prof),
foreign key(id_al) references alumno(id_al) on delete cascade on update cascade,
foreign key(id_prof) references profesor(id_prof) on delete cascade on update cascade
)engine = InnoDB;

insert into alumno values
('A01', 'JUAN MUÑOZ', '1978-09-04', '676543456'),
('A02', 'ANA TORRES', '1980-12-05', '654786756'),
('A03', 'PEPE GARCIA', '1982-08-09', '950441234'),
('A04', 'JULIO GOMES', '1983-12-23', '678909876'),
('A05', 'KIKO ANDRADES', '1979-01-30', '666123456');

insert into profesor values
('P01', 'CARMEN TORRES', '1966-09-08', '564789654'),
('P02', 'FERNANDO GARCIA', '1961-07-09', '656894123');

insert into relacion values
('A01','P01','3.56'),
('A01','P02','4.57'),
('A02','P01','5.78'),
('A02','P02','7.80'),
('A03','P01','4.55'),
('A03','P02','5'),
('A04','P02','10'),
('A05','P01','2.75'),
('A05','P02','8.45');

/*3. Mostrar todos los nombres de los alumnos con sus teléfonos*/
select nom_al, telf_al 
from alumno;

/*4. Mostrar los nombres de los alumnos ordenados en orden creciente y decreciente*/
select nom_al 
from alumno 
order by nom_al asc;

select nom_al 
from alumno 
order by nom_al desc;

/*5. Mostrar los alumnos ordenados por edad*/
select * 
from alumno 
order by fech_al asc;

/*6. Mostrar nombre de alumnos que contengan alguna 'A' en el nombre */
select nom_al 
from alumno 
where nom_al like '%a%';

/*7. Mostrar id_al ordenado por nota*/
select id_al 
from relacion 
order by nota desc;

/*8. Mostrar nombre alumno y nombre de sus respectivos profesores*/
select nom_prof, nom_al
from relacion, alumno, profesor 
where relacion.id_al=alumno.id_al 
and relacion.id_prof=profesor.id_prof;

/*9. Mostrar el nombre de los alumnos que les de clase el profesor P01*/
select nom_al 
from relacion, alumno 
where relacion.id_al=alumno.id_al 
and relacion.id_prof='P01';

/*10. Mostrar el nombre y la nota de los alumnos que les de clase el profesor 'Fernando Garcia'*/
select nom_al, nota 
from relacion, alumno, profesor 
where relacion.id_al=alumno.id_al 
and relacion.id_prof=profesor.id_prof 
and profesor.nom_prof='FERNANDO GARCIA';

/*11. Mostrar todos los alumnos(codigo) que hayan aprobado con el profesor P01*/
select alumno.id_al 
from relacion, alumno 
where nota>='5' 
and relacion.id_prof='P01' 
and relacion.id_al=alumno.id_al;

/*12. Mostrar todos los alumnos(nombre) que hayan aprobado con el profedor P01*/
select nom_al 
from relacion, alumno 
where nota>=5 
and relacion.id_prof='P01' 
and relacion.id_al=alumno.id_al;

/*13. Mostrar todos los alumnos(nombre) que hayan aprobado con el profesor 'Carmen Torres'*/
select nom_al 
from relacion, alumno, profesor 
where nota>=5 
and relacion.id_al=alumno.id_al 
and relacion.id_prof=profesor.id_prof 
and profesor.nom_prof='CARMEN TORRES';

/*14. Mostrar el alumno/s que haya obtenido la nota más alta con P01*/
select nom_al, nota 
from relacion, alumno
where relacion.id_al=alumno.id_al 
and nota=(select  max(nota) from relacion where relacion.id_prof='P01');

/*15. Mostrar los alumnos (nombre y codigo) que hayan aprobado todo*/
select nom_al, id_al
from relacion, alumno
where nota < 5;

select nom_al, id_al
from alumno
where id_al not in (select id_al
from relacion
where nota < 5);

/*Muestra cuantos alumnos tiene asignado cada profesor pero que muestre el nombre del profesor*/
select count(id_al), nom_prof
from relacion, profesor
where relacion.id_prof=profesor.id_prof
group by relacion.id_prof;

/*Muestra la media de los alumnos con cada profesor*/
select avg(nota), id_prof
from relacion
group by id_prof;

/*Nota media de cada alumno por id*/
select avg(nota), id_al
from relacion
group by id_al;

/*Nota media de cada alumno por nombre*/
select avg(nota), nom_al
from relacion, alumno
where relacion.id_al=alumno.id_al
group by relacion.id_al;

/*Nota media de los alumnos que obtienen una media mayor que 7*/
select avg(nota), nom_al
from relacion, alumno
where relacion.id_al=alumno.id_al
group by relacion.id_al
having avg(nota) >7;

/*Nombre del profesor que tiene a su cargo más de 3 alumnos*/
select nom_prof
from relacion, profesor
where relacion.id_prof=profesor.id_prof
group by nom_prof
having count(id_al) >4;




