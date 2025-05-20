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
use mecanicos;


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
create function divisible(num1 int unsigned, num2 int unsigned)
returns boolean DETERMINISTIC
begin
	declare divi boolean;
    if num1%num2 = 0 then
		set divi = true;
	else
		set divi = false;
	end if;
return divi;
end
$$

select divisible(10,5);

/*2. Escribe una función que reciba un número entero de entrada y devuelva TRUE si el número es múltiplo de 5 o FALSE en caso contrario.*/
delimiter $$
drop function if exists multiploCinco $$
create function multiploCinco(num int)
returns boolean deterministic
begin
	declare mult boolean;
	
    if num%5=0 then
		set mult = true;
	else
		set mult = false;
	end if;
return mult;
end
$$

select multiploCinco(41);

/*3. Escribe una función que devuelva el área de un triángulo a partir del valor de su base y de su altura.*/
delimiter $$
drop function if exists areaTri $$
create function areaTri(base float, altura float)
returns float deterministic
begin
	declare area float;
    set area = (base * altura) / 2;
    return area;
end
$$

select areaTri(5,3);

/*4. Escribe una función que reciba como parámetro de entrada un valor numérico
 que represente un mes y que devuelva una cadena de caracteres con el nombre del mes de la semana correspondiente.
 Por ejemplo, para el valor de entrada 1 debería devolver la cadena Enero.*/
 delimiter $$
 drop function if exists nombreMes $$
 create function nombreMes(num int)
 returns varchar(30) deterministic
 begin
	declare mes varchar(30);
    case num
		when 1 then
			set mes = 'Enero';
		when 2 then
			set mes = 'Febrero';
		when 3 then
			set mes = 'Marzo';
		when 4 then
			set mes = 'Abril';
		when 5 then
			set mes = 'Mayo';
		when 6 then
			set mes = 'Junio';
		when 7 then
			set mes = 'Julio';
		when 8 then
			set mes = 'Agosto';
		when 9 then
			set mes = 'Septiembre';
		when 10 then
			set mes = 'Octubre';
		when 11 then
			set mes = 'Noviembre';
		when 12 then
			set mes = 'Diciembre';
		else
			set mes = 'Mes no válido';
	end case;
	return mes;
 end
 $$
 
 select nombreMes(6);
 
 /*5. Escribe una función que reciba tres números reales como parámetros de entrada y devuelva el menor de los tres.*/
 delimiter $$
drop function if exists menor $$
create function menor(num1 int, num2 int, num3 int)
returns int deterministic
begin
	declare menor int;
    if num1 < num2 and num1 < num3 then
		set menor = num1;
	elseif num2 < num1 and num2 < num3 then
		set menor = num2;
	elseif num3 < num1 and num3 < num2 then
		set menor = num3;
	end if;
return menor;
end
$$

select menor(10,15,9);

/*FUNCIONES CON SENTENCIAS SQL*/
/*6. Escribe una función para la base de datos Gestión de relación6 que devuelva la fecha de ingreso mínima 
de los empleados de un determinado departamento. El paramento de entrada será el nombre del departamento.*/

delimiter $$
drop function if exists fechaIngMinima $$
create function fechaIngMinima(nomDep varchar(30))
returns date deterministic
begin
	declare fechaMinima date;
    set fechaMinima = (select min(fecha_ingreso) 
						from empleado, departamento
                        where empleado.cddep = departamento.cddep
                        and departamento.nombre = nomDep);
return fechaMinima;
end
$$

select fechaIngMinima("Gerencia");

/*7. Escribe una función para la base de datos relación6 que le pases el nombre de un empleado
 y te diga si es jefe o no, que devuelva un valor booleano true o false.*/

 delimiter $$
 drop function if exists esJefe $$
 create function esJefe(nomEmp varchar(30))
 returns boolean deterministic
 begin
	declare jefe boolean;
		if nomEmp in (select jefe.nombre
					from empleado, empleado as jefe
					where empleado.cdjefe = jefe.cdemp) then
	set jefe = true;
    else
    set jefe = false;
    
    end if;
return jefe;
 end
 $$
 
select esJefe("Elena Blanco");

/*8. Escribe una función para la base de datos relación6 que devuelva el número total de empleados.*/
delimiter $$
drop function if exists totalEmpleados $$
create function totalEmpleados()
returns int deterministic
begin
	declare total int;
    set total = (select count(cdemp)
					from empleado);
	return total;
end
$$

select totalEmpleados();

/*9. Usa a base de datos relación3 mecánicos y escribe una función que devuelva el número
de veces que un coche ha ido al taller. El parámetro de Entrada será la matrícula del coche.*/
 delimiter $$
 drop function if exists vecesTaller $$
 create function vecesTaller(matricula varchar(25))
 returns int deterministic
 begin
	declare veces int;
    set veces = (select count(relacion4.mat_co)
					from relacion4
                    where mat_co = matricula
                    group by mat_co);
                    
return veces;
 end
 $$
 
 select vecesTaller("0123-BVC");
 
 

 
 
 


											
 
