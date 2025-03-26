create database if not exists mecanicos;
use mecanicos;

create table mecanico(
id_mec char(3) not null,
nom_mec varchar(15),
sueldo int,
fec_nac date,
primary key (id_mec)
)engine = InnoDB;

create table coche(
mat_co char(8) not null,
mod_co varchar(25),
color varchar(10),
tipo varchar(10),
primary key (mat_co)
)engine = InnoDB;

create table periodos(
id_per char(3) not null,
fec_ini date,
fec_fin date,
primary key (id_per)
)engine = InnoDB;

create table tipo(
id_tipo char(3) not null,
nom_tipo varchar(15),
primary key(id_tipo)
)engine = InnoDB;

create table pieza(
id_piez char(3) not null,
nom_piez varchar(15),
id_tipo char(3) not null,
primary key(id_piez),
foreign key(id_tipo) references tipo(id_tipo) on delete cascade on update cascade
)engine = InnoDB;

create table relacion4(
id_mec char(3) not null,
mat_co char(8) not null,
id_per char(3) not null,
id_piez char(3) not null,
precio int,
primary key(id_mec, mat_co, id_per, id_piez),
foreign key(id_mec) references mecanico(id_mec) on delete cascade on update cascade,
foreign key(mat_co) references coche(mat_co) on delete cascade on update cascade,
foreign key(id_per) references periodos(id_per) on delete cascade on update cascade,
foreign key(id_piez) references pieza(id_piez) on delete cascade on update cascade
)engine = InnoDB;

insert into mecanico values
('ME1', 'JUAN ROMUALDO','1289','1970-09-05'),
('ME2', 'RAMON FERNANDEZ','1678','1976-07-05'),
('ME3', 'ANA LUCAS','1100','1968-09-04');

insert into coche values
('1234-CDF','SEAT LEON', 'GRIS', 'DIESEL'),
('0987-CCC','RENAULT MEGANE', 'BLANCO', 'GASOLINA'),
('0123-BVC','OPEL ASTRA', 'AZUL', 'DIESEL'),
('1456-BNL','FORD FOCUS', 'VERDE', 'DIESEL'),
('1111-CSA','SEAT TOLEDO', 'ROJO', 'GASOLINA'),
('4567-BCB','VOLKSWAGEN POLO', 'BLANCO', 'DIESEL'),
('0987-BFG','FORD FIESTA', 'NEGRO', 'GASOLINA');

insert into periodos values
('PE1', '2003-04-09', '2003-04-10'),
('PE2', '2004-05-12', '2004-05-17'),
('PE3', '2004-06-17', '2004-06-27'),
('PE4', '2005-08-22', '2005-09-1'),
('PE5', '2005-09-10', '2005-09-15'),
('PE6', '2005-10-1', '2005-10-17');

insert into tipo values
('TI1', 'CHAPA'),
('TI2', 'MECANICA'),
('TI3', 'ELECTRICIDAD'),
('TI4', 'ACCESORIOS');

insert into pieza values
('PI1', 'FILTRO', 'TI4'),
('PI2', 'BATERIA', 'TI3'),
('PI3', 'ACEITE', 'TI2'),
('PI4', 'RADIO', 'TI4'),
('PI5', 'EMBRAGUE', 'TI2'),
('PI6', 'ALETA', 'TI1'),
('PI7', 'PILOTO', 'TI3'),
('PI8', 'CALENTADOR', 'TI2'),
('PI9', 'CORREAS', 'TI4');

insert into relacion4 values
('ME1', '1234-CDF', 'PE1', 'PI1', '23'),
('ME1', '0123-BVC', 'PE2', 'PI2', '98'),
('ME1', '1456-BNL', 'PE3', 'PI6', '124'),
('ME1', '4567-BCB', 'PE4', 'PI5', '245'),
('ME2', '0987-CCC ', 'PE1', 'PI9', '345'),
('ME2', '0987-CCC ', 'PE1', 'PI8', '232'),
('ME2', '0987-BFG', 'PE2', 'PI1', '17'),
('ME2', '4567-BCB', 'PE3', 'PI7', '99'),
('ME2', '1111-CSA', 'PE4', 'PI4', '124'),
('ME2', '1111-CSA', 'PE4', 'PI2', '153'),
('ME3', '1456-BNL ', 'PE6', 'PI3', '89'),
('ME3', '1456-BNL ', 'PE1', 'PI4', '232'),
('ME3', '1234-CDF', 'PE2', 'PI8', '235'),
('ME3', '1111-CSA ', 'PE3', 'PI9', '567'),
('ME3', '0123-BVC ', 'PE5', 'PI6', '232'),
('ME3', '0987-CCC', 'PE4', 'PI2', '78'),
('ME1', '0987-BFG ', 'PE5', 'PI3', '64'),
('ME2', '1234-CDF', 'PE6', 'PI5', '234'),
('ME1', '0987-BFG', 'PE6', 'PI9', '345'),
('ME2', '1234-CDF', 'PE6', 'PI1', '12'),
('ME1', '1234-CDF', 'PE1', 'PI6', '187'),
('ME3', '1111-CSA', 'PE3', 'PI4', '345'),
('ME1', '0123-BVC', 'PE2', 'PI3', '72'),
('ME2', '0123-BVC', 'PE6', 'PI3', '89');

/*1. DATOS DEL MECANICO DE MAYOR SUELDO*/
select * 
from mecanico
group by id_mec
having sueldo = (select max(sueldo)
				from mecanico);

/*2. DATOS DEL EMPLEADO MAYOR*/
select * 
from mecanico
group by id_mec
having fec_nac = (select min(fec_nac)
				from mecanico);
                
/*3. DATOS DEL EMPLEADO MENOR*/
select * 
from mecanico
group by id_mec
having fec_nac = (select max(fec_nac)
				from mecanico);  
                
/*4. DATOS DE TODOS LOS COCHES DIESEL*/
select *
from coche
where tipo = "DIESEL";

/*5. DATOS DEL COCHE QUE MÁS HA IDO AL TALLER*/
select coche.*
from relacion4, coche
where relacion4.mat_co=coche.mat_co
group by relacion4.mat_co
having count(relacion4.mat_co)=(select count(relacion4.mat_co)
						from relacion4
                        group by relacion4.mat_co
                        order by 1 desc limit 1);
                       
/*6. PRECIO TOTAL DE TODAS LAS REPARACIONES*/
select sum(precio)
from relacion4;

/*7. NOMBRE DE PIEZA Y TIPO DE LA PIEZA MAS USADA*/
select nom_piez, count(relacion4.id_piez), nom_tipo, count(pieza.id_tipo)
from relacion4, pieza, tipo
where relacion4.id_piez = pieza.id_piez
and pieza.id_tipo = tipo.id_tipo
group by relacion4.id_piez
having (count(relacion4.id_piez), count(pieza.id_tipo)) = (select count(relacion4.id_piez), count(pieza.id_tipo)
											from relacion4, pieza, tipo
                                            where relacion4.id_piez = pieza.id_piez
                                            and pieza.id_tipo = tipo.id_tipo
                                            group by relacion4.id_piez
                                            order by 1 desc limit 1);

/*8. NOMBRE Y TIPO DE LA PIEZA MENOS USADA*/
select count(relacion4.id_piez), count(pieza.id_tipo)
from relacion4, pieza, tipo
where relacion4.id_piez = pieza.id_piez
and pieza.id_tipo = tipo.id_tipo
group by relacion4.id_piez
order by 1 asc limit 1;

select nom_piez, nom_tipo
from relacion4, pieza, tipo
where relacion4.id_piez = pieza.id_piez
and pieza.id_tipo = tipo.id_tipo
group by relacion4.id_piez
having (count(relacion4.id_piez), count(pieza.id_tipo)) = (select count(relacion4.id_piez), count(pieza.id_tipo)
											from relacion4, pieza, tipo
                                            where relacion4.id_piez = pieza.id_piez
                                            and pieza.id_tipo = tipo.id_tipo
                                            group by relacion4.id_piez
                                            order by 1 asc limit 1);

/*9. MATRICULA, MARCA MODELO COLOR PIEZA Y TIPO DE TODOS LOS COCHES REPARADOS*/
select distinct coche.mat_co as 'Matricula', mod_co as 'Marca', color, nom_piez as 'Pieza', nom_tipo as 'Tipo Pieza'
from relacion4, pieza, coche, tipo
where relacion4.mat_co = coche.mat_co
and relacion4.id_piez = pieza.id_piez
and pieza.id_tipo=tipo.id_tipo;

/*10. MODELO DE PIEZA Y TIPO PUESTAS A '0123-BVC'*/
select distinct nom_piez as 'Pieza', nom_tipo as 'Tipo Pieza'
from relacion4, pieza, tipo, coche
where relacion4.id_piez = pieza.id_piez
and pieza.id_tipo = tipo.id_tipo
and relacion4.mat_co = '0123-BVC';

/*11. DINERO QUE HA GASTADO EN REPARACIONES 1234-CDF*/
select sum(precio)
from relacion4
where mat_co = '1234-CDF';

/*12. DATOS DEL COCHE QUE MAS HA GASTADO EN REPARACIONES*/
select coche.*
from relacion4, coche
where relacion4.mat_co = coche.mat_co
group by relacion4.mat_co
having sum(precio) = (select sum(precio)
						from relacion4
                        group by relacion4.mat_co
                        order by 1 desc limit 1);
	
/*13. DATOS DEL COCHE QUE MENOS HA GASTADO EN REPARACIONES*/
select coche.*, sum(precio)
from relacion4, coche
where relacion4.mat_co = coche.mat_co
group by relacion4.mat_co
having sum(precio) = (select sum(precio)
						from relacion4
                        group by relacion4.mat_co
                        order by 1 asc limit 1);
                        
/*14. DATOS DEL COCHE QUE MENOS HA GASTADO EN EL TALLER*/

/*15. TOTAL DE TODAS LAS REPARACIONES DE 'ANA LUCAS'*/
select sum(precio) as 'Precio total', mecanico.nom_mec
from relacion4, mecanico
where relacion4.id_mec=mecanico.id_mec
and mecanico.nom_mec = 'ANA LUCAS';                     

/*16. DATOS DE LOS COCHES Y LAS PIEZAS PUESTAS POR 'JUAN ROMUALDO'*/
select coche.*, nom_piez
from relacion4, pieza, mecanico, coche
where relacion4.mat_co=coche.mat_co
and relacion4.id_piez=pieza.id_piez
and relacion4.id_mec=mecanico.id_mec
and mecanico.nom_mec = 'Juan Romualdo';

/*17. FECHA DE INICIO Y FIN DEL PERIODO EN QUE MAS SE HA TRABAJADO*/
select count(id_per), id_per
from relacion4
group by id_per;

select fec_ini, fec_fin
from relacion4, periodos
where relacion4.id_per = periodos.id_per
group by relacion4.id_per
having count(relacion4.id_per) = (select count(relacion4.id_per)
						from relacion4
                        group by relacion4.id_per
                        order by 1 desc limit 1);
                        
/*18. FECHA DE INICIO Y FIN DEL PERIODO QUE MENOS SE HA TRABAJADO*/
select fec_ini, fec_fin
from relacion4, periodos
where relacion4.id_per = periodos.id_per
group by relacion4.id_per
having count(relacion4.id_per) = (select count(relacion4.id_per)
						from relacion4
                        group by relacion4.id_per
                        order by 1 asc limit 1);

/*19. DINERO QUE SE HA HECHO EN EL PERIODO PE3*/
select sum(precio)
from relacion4, periodos
where relacion4.id_per = periodos.id_per
and relacion4.id_per = 'PE3';

/*20. DATOS DE LOS COCHES A LOS QUE SE LES HAYA PUESTO UN EMBRAGUE*/
select coche.*
from relacion4, coche, pieza
where relacion4.mat_co = coche.mat_co
and relacion4.id_piez = pieza.id_piez
and pieza.nom_piez = 'EMBRAGUE';	

/*21. DATOS DE LOS COCHES A LOS QUE SE LES HAYA CAMBIADO EL ACEITE*/					
select coche.*
from relacion4, coche, pieza
where relacion4.mat_co = coche.mat_co
and relacion4.id_piez = pieza.id_piez
and pieza.nom_piez = 'ACEITE';

/*22. DATOS DE LOS MECANICOS QUE HAYAN PUESTO ALGUNA PIEZA DE TIPO 'ELECTRICIDAD'*/
select distinct mecanico.*
from relacion4, mecanico, pieza, tipo
where relacion4.id_piez = pieza.id_piez
and relacion4.id_mec = mecanico.id_mec
and pieza.id_tipo = tipo.id_tipo
and tipo.nom_tipo = 'ELECTRICIDAD';

/*23. MONTO ECONÓMICO DE TODAS LAS PIEZAS DE TIPO CHAPA*/
select sum(precio)
from relacion4, pieza, tipo
where relacion4.id_piez = pieza.id_piez
and pieza.id_tipo = tipo.id_tipo
and nom_tipo = 'CHAPA';

/*24. TIPO DE PIEZA QUE MAS DINERO HA DEJADO EN EL TALLER*/
select nom_tipo
from relacion4, pieza, tipo
where relacion4.id_piez = pieza.id_piez
and pieza.id_tipo = tipo.id_tipo
group by pieza.id_piez
having sum(precio) = (select sum(precio)
						from relacion4, pieza
                        where relacion4.id_piez = pieza.id_piez
                        group by pieza.id_piez
                        order by 1 desc limit 1);
                        
/*25. DATOS DEL MECANICO QUE MENOS HA TRABAJADO*/
select mecanico.*, count(relacion4.id_mec) as 'Veces'
from relacion4, mecanico
where relacion4.id_mec = mecanico.id_mec
group by relacion4.id_mec
having count(relacion4.id_mec) = (select count(relacion4.id_mec)
									from relacion4, mecanico
                                    where relacion4.id_mec = mecanico.id_mec
                                    group by relacion4.id_mec
                                    order by 1 asc limit 1);




