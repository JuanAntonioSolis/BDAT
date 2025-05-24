create database simulacro;
use simulacro;

CREATE TABLE departamentos (
    id_departamento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
)engine=InnoDB;

CREATE TABLE empleados (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    salario DECIMAL(10,2),
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento)
)engine=InnoDB;

CREATE TABLE proyectos (
    id_proyecto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    presupuesto DECIMAL(12,2),
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento)
)engine=InnoDB;

INSERT INTO departamentos (nombre) VALUES 
('Recursos Humanos'), 
('Tecnología'), 
('Finanzas');

INSERT INTO empleados (nombre, salario, id_departamento) VALUES
('Ana Gómez', 2500.00, 1),
('Luis Pérez', 3200.00, 2),
('Carlos Ruiz', 4000.00, 2),
('Elena Martínez', 2100.00, 1),
('Sofía Torres', 2900.00, 3);

INSERT INTO proyectos (nombre, presupuesto, id_departamento) VALUES
('Sistema Nómina', 100000.00, 1),
('Plataforma Web', 250000.00, 2),
('Control Gastos', 80000.00, 3);



/*1. Crea un procedimiento llamado mostrar_bienvenida que reciba un nombre como parámetro (VARCHAR(50)) y muestre el siguiente mensaje:*/
/*Bienvenido/a al sistema, [nombre]*/

delimiter $$
drop procedure if exists mostrar_bienvenida $$
create procedure mostrar_bienvenida(in nombre varchar(50))
begin
	select concat("Bienvenido al sistema ", nombre);
end
$$

call mostrar_bienvenida("Juan");


/*2. Crea un procedimiento ver_departamentos que muestre una lista con los nombres de todos los departamentos existentes..*/

delimiter $$
drop procedure if exists ver_departamentos $$
create procedure ver_departamentos()
begin
	select departamentos.nombre
    from departamentos;
end
$$
call ver_departamentos();


/*3. Crea un procedimiento subir_sueldo_departamento que reciba:
el id del departamento,
un porcentaje de aumento (por ejemplo, 10 para un 10%).
El procedimiento debe aumentar el salario de todos los empleados del departamento indicado.*/

delimiter $$
drop procedure if exists subir_sueldo_departamento $$
create procedure subir_sueldo_departamento(in idDep int, in porcentaje int)
begin
	update empleados set salario = salario + salario*(porcentaje/100)
    where id_departamento = idDep;
end
$$
call subir_sueldo_departamento(3,21);

/*4. Crea un procedimiento insertar_empleado que reciba:
nombre del empleado
salario
id_departamento
El procedimiento debe insertar el empleado solo si existe el departamento.
Si no existe, no debe hacer nada.*/
delimiter $$
drop procedure if exists insertar_empleado $$
create procedure insertar_empleado(in nom varchar(100), in money decimal(10,2), in idDep int)
begin
	insert into empleados values
    (null,nom, money, idDep);
end
$$
call insertar_empleado("Juan",1700.00,3);


/*5. Crea una función fecha_actual_completa que devuelva la fecha y hora actual del sistema (DATETIME).*/

delimiter $$
drop function if exists fecha_actual_completa $$
create function fecha_actual_completa()
returns datetime deterministic
begin
	return now();
end
$$
select fecha_actual_completa();

/*6. Crea una función nombre_mayusculas que reciba un nombre y lo devuelva en mayúsculas.
	Por ejemplo: luis pérez → LUIS PÉREZ.*/

delimiter $$
drop function if exists nombre_mayusculas $$ 
create function nombre_mayusculas (nom varchar(40))
returns varchar(40) deterministic
begin
	return upper(nom);
end
$$
select nombre_mayusculas("alonso");
    
/*7. Crea un procedimiento eliminar_empleado que reciba el id_empleado.
Si el empleado existe, lo borra.
Si no existe, no lanza error, pero guarda un mensaje en una tabla errores que debes crear con esta estructura:*/
delimiter $$
drop procedure if exists eliminar_empleado $$
create procedure eliminar_empleado(in idEmp int,out error varchar(50))
begin
	declare continue handler for 1062
	begin
	set error='El ID de empleado no existe';
    end;
set error='Empleado borrado con éxito';
delete from empleados where id_empleado = idEmp;
end
$$
call eliminar_empleado(6,@error);
select @error;

/*8. Crea una función total_empleados_en_departamento que reciba un id_departamento y devuelva cuántos empleados hay en ese departamento.*/
delimiter $$
drop function if exists total_empleados_en_departamento $$
create function total_empleados_en_departamento(idDep int)
returns int deterministic
begin
	declare total int;
    
    set total = (select count(id_empleado)
					from empleados
                    where id_departamento = idDep
                    group by id_departamento);
	return total;
end
$$
select total_empleados_en_departamento(2);

/*9. Crea una función salario_promedio que reciba un id_departamento y devuelva el salario promedio de sus empleados.*/
delimiter $$
drop function if exists salario_promedio $$
create function salario_promedio (idDep int)
returns float deterministic
begin
	declare media float;
    set media = (select avg(salario)
				from empleados
				where id_departamento = idDep
                group by id_departamento);
	return media;
end
$$
select salario_promedio(1);

/*10. Crea una función presupuesto_total_proyectos que reciba un id_departamento y devuelva la suma total del presupuesto de todos los proyectos del departamento.*/
delimiter $$
drop function if exists presupuesto_total_proyectos $$
create function presupuesto_total_proyectos(idDep int)
returns float deterministic
begin
	declare total float;
    set total = (select sum(presupuesto)
				 from proyectos
                 where id_departamento = idDep);
	return total;
end
$$
select presupuesto_total_proyectos(2);


/*11. Crea una función mejor_pagado_nombre que reciba un id_departamento y devuelva el nombre del empleado con mayor salario de ese departamento.*/
delimiter $$
drop function if exists mejor_pagado_nombre $$
create function mejor_pagado_nombre (idDep int)
returns varchar(50) deterministic
begin
	declare mejor varchar(50);
    set mejor = (select max(nombre)
				from empleados
                where id_departamento=idDep
                group by salario
                order by 1 limit 1);
    return mejor;
end
$$
select mejor_pagado_nombre(2);



