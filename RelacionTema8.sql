/*1. Crea una base de datos llamada procedimientos que contenga una tabla llamada
Operaciones.

La tabla debe de contener cuatro columnas de tipo int unsigned,
cuatro columnas llamadas num1, num2, suma y producto.

Una vez creada la base de datos y la tabla crear un procedimiento llamado
Calcular_Operaciones con las siguientes características. 
El procedimiento recibe
dos parámetro, uno llamado número y otro tope de tipo int unsigned y calculara
el valor de la suma y del producto de los números naturales comprendidos entre
número y tope.

Ten en cuenta que el procedimiento deberá eliminar el contenido actual de la
tabla antes de insertar los nuevos valores de la suma y el producto que va a
calcular.
*/
create database procedimientos;
use procedimientos;
use practica5;


create table Operaciones(
num1 int unsigned,
num2 int unsigned,
suma int unsigned,
producto int unsigned
)engine = InnoDB;

delimiter $$
drop procedure if exists CalcularOperaciones $$
create procedure CalcularOperaciones(in numero int unsigned,in tope int unsigned)
begin
	delete from Operaciones;
	while numero <= tope do
		insert into Operaciones values(numero, tope, numero+tope,numero*numero);
		set numero=numero+1;
	end while;
end
$$
call CalcularOperaciones(1,8);
select * from Operaciones;

/*3. Utiliza un bucle REPEAT para resolver el procedimiento del ejercicio anterior.*/

delimiter $$
drop procedure if exists Ej1Repeat $$
create procedure Ej1Repeat(in numero int unsigned, in tope int unsigned)
begin
	delete from Operaciones;
	repeat
		insert into Operaciones values(numero, tope, numero+tope,numero*numero);
		set numero=numero+1;
	until numero > tope
    end repeat;
end
$$
call Ej1Repeat(1,10);
select * from Operaciones;

/*4. Utiliza un bucle LOOP para resolver el procedimiento del ejercicio anterior.*/

delimiter $$
drop procedure if exists Ej1Loop $$
create procedure Ej1Loop(in numero int unsigned, in tope int unsigned)
begin
	delete from Operaciones;
	bucle:loop
    if numero <= tope then
		insert into Operaciones values(numero, tope, numero+tope,numero*numero);
		set numero=numero+1;
        iterate bucle;
	end if;
    leave bucle;
    end loop bucle;
end 
$$
call Ej1Loop(4,10);
select * from Operaciones;

/*5. Escribe un procedimiento que reciba el nombre de un departamento como parámetro de entrada
 y realice una consulta para obtener todos los empleados de ese departamento. Usa base de datos relacion6.*/
delimiter $$
drop procedure if exists EmpleadosDept $$
create procedure EmpleadosDept(in nomDep varchar(30))
begin
	select empleado.*
    from empleado, departamento
    where empleado.cddep = departamento.cddep
    and departamento.nombre = nomDep;
end
$$
call EmpleadosDept("Gerencia");

/*6. Haga un procedimiento que muestre un listado de todos los empleados
 y el número de horas total que ha trabajado en proyectos 
 (ten en cuenta que algunos han trabajado en más de un proyecto).
 Usa la base de datos relacion6.*/
 
 delimiter $$
 drop procedure if exists listadoEmpHoras $$
 create procedure listadoEmpHoras()
 begin
	select empleado.nombre, sum(nhoras)
    from empleado, trabaja
    where empleado.cdemp = trabaja.cdemp
    group by trabaja.cdemp;
 end
 $$
 call listadoEmpHoras;
 
/*7. Escribe un procedimiento que modifique la localidad de un departamento. 
El procedimiento recibirá como parámetros el código del departamento y la nueva
localidad. Usa la base de datos relacion6.*/
delimiter $$
drop procedure if exists localidadDep $$
create procedure localidadDep(in codDepa char(2), in nuevaLoca varchar(20))
begin
	update departamento set ciudad = nuevaLoca 
    where cddep = codDepa;
end
$$
call localidadDep("02",'Venecia');
select * from departamento;

/*8. Escribe un procedimiento que reciba como parámetro de entrada
 el nombre de un proyecto y que devuelva como salida el nombre de los departamentos al que pertenece.
 Usa la base de datos relacion6.*/
 
 delimiter $$
 drop procedure if exists departamentosProyecto $$
 create procedure departamentosProyecto(in nomPro varchar(30))
 begin
	select departamento.nombre
    from departamento, proyecto
    where departamento.cddep = proyecto.cddep
    and proyecto.nombre = nomPro;
 end
 $$
 call departamentosProyecto("Depuracion de aguas");
 
 /*9. Codifica un procedimiento que permita borrar un empleado cuyo código se pasara en la llamada al procedimiento.
 Usa la base de datos relacion6.*/
 delimiter $$
 drop procedure if exists borrarEmp $$
 create procedure borrarEmp(in codEmp char(3))
 begin
	delete from empleado
    where cdemp = codEmp;
 end
 $$
 call borrarEmp("A13");
 
 /*10. Haz un procedimiento que borre los departamentos que no tienen empleados. Usa la base de datos relacion6.*/
 delimiter $$
 drop procedure if exists borrarDepCero $$
 create procedure borrarDepCero()
 begin
	delete from departamento where cddep not in (select cddep
											from empleado
                                            where cddep is not null);
 end
 $$
 call borrarDepCero();
 
/*Funciones sin sentencias SQL*/
/*1. Escribe una función que devuelva true o false si un número es divisible por otro.*/
delimiter $$
drop function if exists divisible $$
create function divisible(num1 int, num2 int)
begin
end
$$
select divisible(10,4);


											
 
