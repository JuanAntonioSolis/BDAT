drop database if exists examen2024;
create database examen2024;

use examen2024;
use ExamenTema8;



create table if not exists instituto(
    cdinsti char(2) primary key,
    nombre varchar(30),
    ciudad varchar(20)
)engine = InnoDB;


create table if not exists profesores(
    cdprofe char(3) primary key,
    nombre varchar(30),
    fech_ingreso date,
    cddirector char(3),
    cdinsti char(2),
    foreign key(cddirector) references profesores(cdprofe)
    on update cascade 
    on delete set null,
    foreign key (cdinsti) references instituto(cdinsti)
    on update cascade
    on delete restrict
)engine = InnoDB;


create table if not exists proyecto(
    cdpro char(3) primary key,
    nombre varchar(60),
    cdinsti char(2),
    foreign key (cdinsti) references instituto(cdinsti)
    on update cascade
    on delete restrict
)engine = InnoDB;


create table if not exists trabaja(
    cdprofe char(3),
    cdpro char(3),
    primary key (cdprofe, cdpro),
    nhoras integer,
    foreign key (cdprofe) references profesores(cdprofe)
    on update cascade
    on delete cascade,
    foreign key (cdpro) references proyecto(cdpro)
    on update cascade
    on delete cascade
)engine = InnoDB;
describe trabaja;


insert into instituto(cdinsti, nombre, ciudad) values
('01' , 'IES Jaroso' , 'Cuevas del Almanzora'),
('02' , 'IES El Palmeral' , 'Vera'),
('03' , 'IES Alyanub' , 'Vera'),
('04' , 'IES Cura Valera' , 'Huercal Overa'),
('05' , 'IES Albujaira' , 'Huercal Overa'),
('06' , 'IES Cardenal Cisneros' , 'Albox');
select * from instituto; 


insert into profesores (cdprofe, nombre, fech_ingreso, cddirector, cdinsti) values
('A04', 'EDUARDO ROJO', '1997-09-01', NULL, '01'),
('A01', 'ANA VICENTE BELMONTE', '2022-09-01', 'A04', '01'),
('A02', 'CATALINA FLORES CAZORLA', '2002-09-01', 'A04', '01'),
('A03', 'JAVIER GUILLEN BENAVENTE', '2018-09-01', 'A04', '01'),
('A05', 'ELOY VILLAR', '2006-09-01', 'A04', '01'),
('A06', 'FRANCISCO MATIAS PRADO', '2016-09-01', 'A04', '01'),
('A07', 'FRANCISCO CARMONA', '1996-09-01', NULL, '02'),
('A08', 'MARI CARMEN SOLER', '1996-09-01', 'A07', '02'),
('A09', 'RICARDO MASIP', '1996-10-10', 'A07', '02'),
('A10', 'ESPERANZA MANZANERA', NULL, 'A07', '02'),
('A11', 'MARTIN FLORES', '2010-09-01', NULL, '05'),
('A12', 'FRANCISCA MARTÍNEZ DE HARO', '2014-09-01', 'A11', '05'),
('A14', 'JUAN ANGEL SOLER', '1995-09-01', NULL, '03'),
('A13', 'MANOLI DIAZ', '1995-09-01', 'A14', '03'),
('A15', 'PABLO FLORES DIAZ', '2021-09-01', 'A11', NULL),
('A16', 'PEDRO GARCÍA GARCÍA', '1996-09-01', NULL, '06'),
('A17', 'JESÚS MELLADO GARCÍA', '1997-09-01', 'A16', NULL);

insert into proyecto (cdpro, nombre, cdinsti) values
('CAE', 'CUIDADOS AUXILIARES DE ENFERMERÍA', '05'),
('DAW', 'DESARROLLO DE APLICACIONES WEBS', '01'),
('GAM', 'GESTION ADMINISTRATIVA GRADO MEDIO', '01'),
('GAS', 'GESTION ADMINISTRATIVA GRADO SUPERIOR', '03'),
('SMR', 'SISTEMAS MICROINFORMÁTICOS Y REDES', '04');


insert into trabaja (cdprofe, cdpro, nhoras) values
('A01', 'DAW', 5),
('A02', 'DAW', 120),
('A02', 'SMR', 80),
('A03', 'DAW', 180),
('A03', 'SMR', 40),
('A04', 'DAW', 0),
('A04', 'SMR', 100),
('A05', 'GAM', 20),
('A06', 'GAS', 0),
('A11', 'CAE', 100),
('A13', 'GAM', 10),
('A14', 'GAS', 0),
('A16', 'DAW', 20);

/*1. Crea un procedimiento que actualice la fecha de ingreso del profesor 
que le pasaremos como parámetro de entrada. Para ello le pasaremos dos parámetros 
de entrada una será el nombre del profesor y el otro será la nueva fecha de ingreso.
 Usa la base de datos PROFESORES. (1 punto)*/
 delimiter $$
 drop procedure if exists actualizar $$
 create procedure actualizar(in nuevaFecha date, in nom varchar(30))
 begin
	update profesores set fech_ingreso = nuevaFecha
    where nombre = nom;
 end
 $$
 
 call actualizar('2000-09-01','EDUARDO ROJO');
 
 /*2. Haz un procedimiento para dar de alta nuevos institutos, con las siguientes características.
El procedimiento recibe 3 parámetros de entrada cdinsti char(2), nombre varchar(30), ciudad varchar(20) y
 devolverá como salida un parámetro llamado error que tendrá valor igual a 0 si la inserción se ha podido realizar con
 éxito y un valor igual a 1 en caso contrario. El procedimiento de para dar de alta realiza los siguientes pasos: (2 puntos)
 
 Inicia una transacción.
 Inserta una fila en la tabla.
 Comprueba si ha ocurrido algún error en las operaciones anteriores. Si no ocurre ningún error entonces aplica un COMMIT a la transacción y si ha ocurrido algún error aplica un ROLLBACK.
 Deberá manejar el siguiente error que pueda ocurrir durante el proceso de inserción. ERROR 1062 (Duplicate entry for PRIMARY KEY).

Usa la base de datos PROFESORES.*/
delimiter $$
drop procedure if exists nuevoInsti $$
create procedure nuevoInsti(in codigoInsti char(2), in nomInsti varchar(30), in city varchar(20), out error tinyint)
begin
    
	declare continue handler for 1062
    begin
    set error=1; /*Si hay error*/
    end;
    
    set error=0;/*Si no hay error*/

	insert into instituto values
    (codigoInsti,nomInsti,city);
end
$$

call nuevoInsti(19,"Instituto nuevo","Granada",@error);
select @error;

/*3. Haz un procedimiento donde introduzcas el nombre de un profesor como
 parámetro de entrada y que te devuelva como salida el nombre del instituto en que trabaja.
 Usa la base de datos PROFESORES. (1 punto)*/
 delimiter $$
 drop procedure if exists instiTrabaja $$
 create procedure instiTrabaja(in nomProf varchar(30))
 begin
	select instituto.nombre
    from profesores, instituto
    where profesores.cdinsti = instituto.cdinsti
    and profesores.nombre = nomProf;
 end
 $$
 
 call instiTrabaja("MANOLI DIAZ");
 
 /*4. Haz un procedimiento donde te muestre un listado de todos los nombres de los profesores,
 y el número de proyectos en los que está trabajando (ten en cuenta que algunos profesores no
 trabajan en ningún proyecto). Usa la base de datos PROFESORES. (1 punto)*/
 delimiter $$
 drop procedure if exists listaProfesores $$
 create procedure listaProfesores()
 begin
	select profesores.nombre, count(trabaja.cdprofe)
    from trabaja
    right join profesores
    on trabaja.cdprofe = profesores.cdprofe
    group by profesores.cdprofe;
    
 end
 $$
 
 call listaProfesores();
 
 /*5. Crea un procedimiento para Borrar los institutos que no tienen profesores.
 Usa la base de datos PROFESORES. (1 punto)*/
 delimiter $$
 
 drop procedure if exists deleteInsti $$
 create procedure deleteInsti()
 begin
	delete from instituto where cdinsti not in (select cdinsti
												from profesores);
 end
 $$
 
 call deleteInsti();
 
 /*6. Crea una base de datos llamada ExamenTema8 que contenga una tabla llamada divisores,
 la tabla tendrá una única columna llamada número y el tipo de dato de esta columna debe ser INT UNSIGNED. (1 punto)
 
 
Crear un procedimiento llamado Calculardivisores con las siguientes características. 
El procedimiento recibe un parámetro de entrada llamado número y deberá almacenar en la tabla divisores sus divisores.
 Ej. 16 -> sus divisores son: 1, 2, 4, 6,16
Ten en cuenta que el procedimiento deberá eliminar el contenido actual de la tabla antes de insertar los nuevos valores que va a calcular.
Utiliza un bucle WHILE para resolver el procedimiento. (1 punto)*/

delimiter $$
drop procedure if exists CalcularDivisores $$
create procedure CalcularDivisores(in numero int)
begin
	declare x int default 1	;
	delete from divisores;
    
    while x <= numero do
    if numero%x = 0 then
    insert into divisores values
    (x);
    end if;
    set x = x+1;
    end while;
end
$$

call CalcularDivisores(15);

select * from divisores;

/*
7. Haz una función que introduzcas el nombre de un profesor y te devuelva el número
 de años que lleva trabajando. Usa la base de datos PROFESORES. (1 punto)*/
 delimiter $$
 drop function if exists workedYears $$
 create function workedYears(nomProf varchar(30))
 returns int deterministic
 begin
	declare periodo int;
    set periodo = (select datediff(curdate(),fech_ingreso)/365
					from profesores
                    where nombre = nomProf);
	return periodo;
 end
 $$
 
 select workedYears('CATALINA FLORES CAZORLA');
 
 /*8. Un número perfecto es aquel en el que la suma de todos sus divisores,
 sin incluirlo a él mismo da como resultado ese número. Por ejemplo, 
 el número 6 es perfecto ya que los divisores de 6: 1, 2 y 3 (sin contar el 6) sumados dan 6.
 
 Hacer una función que lea un número y diga si es o no perfecto. Usa la base de datos ExamenTema8. (1 punto)*/
 delimiter $$
 drop function if exists numeroPerfecto $$
 create function numeroPerfecto(numPedido int)
 returns varchar(30) deterministic
 begin
	declare perfecto varchar(30);
    declare x int default 1;
	declare suma int default 0;
    
    while x < numPedido do
		if numPedido % x = 0 then
			set suma = suma+x;
		end if;
    set x = x +1;
    end while;
    
    if suma = numPedido then
	set perfecto = "Si";
    else
    set perfecto = "No";
    end if;
    
    return perfecto;
 end
 $$
 
 select numeroPerfecto(7);
 
 /*9. Escribe una función para la base de datos PROFESORES que le pases el nombre
 de un profesor y te diga si es director o no, que devuelva un valor booleano true o false.
Usa la base de datos PROFESORES. (1 punto)*/
delimiter $$

drop function if exists esDirector $$
create function esDirector (nomProfe varchar(30))
returns boolean deterministic
begin
	declare direc boolean;
    
    if (nomProfe in (select director.nombre
					 from profesores, profesores as director
                     where profesores.cddirector = director.cdprofe)) then
	set direc = true;
    else
    set direc = false;
    end if;

return direc;
end
$$

select esDirector('EDUARDO ROJO');



 
 
 




 
 














 