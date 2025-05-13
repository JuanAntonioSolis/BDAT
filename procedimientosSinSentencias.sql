create database if not exists procedimientosSinSentencias;
use procedimientosSinSentencias;

/*1. Escribe un procedimiento que no tenga ningún parámetro de entrada ni de salida y que muestre el texto
¡Hola mundo!.*/
delimiter $$
drop procedure if exists HolaMundo $$
create procedure HolaMundo()
begin
	select 'Hola Mundo!';
end
$$

call HolaMundo();

/*2. Escribe un procedimiento que reciba un número real de entrada y muestre un mensaje indicando si el
número es positivo, negativo o cero.*/
delimiter $$
drop procedure if exists ComprobarNum $$
create procedure ComprobarNum(in num float)
begin
	if num > 0 then
		select 'El número es positivo';
	elseif num < 0 then
		select 'El número es negativo';
	else
		select 'El número es 0';
	end if;
end
$$

call ComprobarNum(-10);

/*3. Modifique el procedimiento diseñado en el ejercicio anterior para que tenga un parámetro de entrada,
con el valor un número real, y un parámetro de salida, con una cadena de caracteres indicando si el número es positivo, negativo o cero.*/
delimiter $$
drop procedure if exists ComprobarNumEj3 $$
create procedure ComprobarNumEj3(in num float, out signo varchar(30))
begin
	if num > 0 then
		set signo = 'El número es positivo';
	elseif num < 0 then
		set signo = 'El número es negativo';
	else
		set signo = 'El número es 0';
	end if;
    
end
$$

call ComprobarNumEj3(0,@signo);
select @signo

/*4. Escribe un procedimiento que reciba un número real de entrada, que representa el valor de la nota de
un alumno, y muestre un mensaje indicando qué nota ha obtenido teniendo en cuenta las siguientes
condiciones:
• [0,5) = Insuficiente
• [5,6) = Aprobado
• [6, 7) = Bien
• [7, 9) = Notable
• [9, 10] = Sobresaliente
• En cualquier otro caso la nota no será válida.*/
delimiter $$
drop procedure if exists Notas $$
create procedure Notas(in nota float)
begin
	if nota > 0 and nota <=5 then
		select 'Insuficiente';
	elseif nota > 5 and nota <=6 then
		select 'Aprobado';
	elseif nota > 6 and nota <=7 then
		select 'Bien';
	elseif nota > 7 and nota <=9 then
		select 'Notable';
	else
		select 'Sobresaliente';
	end if;
end
$$

call Notas(8);


/*5. Modifique el procedimiento diseñado en el ejercicio anterior para que tenga un parámetro de entrada,
con el valor de la nota en formato numérico y un parámetro de salida, con una cadena de texto indicando
la nota correspondiente.*/
delimiter $$
drop procedure if exists Notas2 $$
create procedure Notas2(in nota float, out result varchar(50))
begin
	if nota > 0 and nota <=5 then
		set result = 'Insuficiente';
	elseif nota > 5 and nota <=6 then
		set result = 'Aprobado';
	elseif nota > 6 and nota <=7 then
		set result = 'Bien';
	elseif nota > 7 and nota <=9 then
		set result = 'Notable';
	else
		set result = 'Sobresaliente';
	end if;
end
$$

call Notas2(8,@result);
select @result;

/*6. Resuelva el procedimiento diseñado en el ejercicio anterior haciendo uso de la estructura de control CASE*/
delimiter $$
drop procedure if exists Expediente $$
create procedure Expediente(in nota float,out calificacion varchar(50))
begin
	case nota
		when nota >= 0 and nota < 5 then
			set calificacion = 'Insuficiente';
		when nota >= 5 and nota < 6 then
			set calificacion = 'Aprobado';
		when nota >= 6 and nota < 7 then
			set calificacion = 'Bien';
		when nota >= 7 and nota < 9 then
			set calificacion = 'Notable';
		when nota >= 9 and nota < 10 then
			set calificacion = 'Sobresaliente';
		else
			set calificacion = 'Nota inválida';
	end case;
end
$$
call Expediente(7,@calificacion);
select @calificacion;

/*7. Escribe un procedimiento que reciba como parámetro de entrada un valor numérico que represente un
día de la semana y que devuelva una cadena de caracteres con el nombre del día de la semana correspondiente. Por ejemplo, para el valor de entrada 1 debería devolver la cadena lunes.*/