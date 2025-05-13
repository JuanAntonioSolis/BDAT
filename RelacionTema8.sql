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
	while numero <= tope do
    insert into Operaciones values(
	
end
$$
call CalcularOperaciones();