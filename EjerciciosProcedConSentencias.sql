create database if not exists procedimientosSentenciaSQL;
use jardineria;

/*1. Escribe un procedimiento que reciba el nombre de un país como parámetro de entrada y realice una
consulta sobre la tabla cliente para obtener todos los clientes que existen en la tabla de ese país.*/
delimiter $$
drop procedure if exists Ejercicio1 $$
create procedure Ejercicio1(in paisBusca varchar(50))
begin
	select * from cliente
    where pais = paisBusca;
end
$$
call Ejercicio1('USA');


/*2. Escribe un procedimiento que reciba como parámetro de entrada una forma de pago,
 que será una cadena de caracteres (Ejemplo: PayPal, Transferencia, etc).
 Y devuelva como salida el pago de máximo valor realizado para esa forma de pago.
 Deberá hacer uso de la tabla pago de la base de datos jardineria.*/
 delimiter $$
 drop procedure if exists Ejercicio2 $$
 create procedure Ejercicio2(in formaP varchar(40),out maximo float)
 begin
	set maximo=(select max(total) 
				from pago 
				where pago.forma_pago = formaP);
 end
 $$
 call Ejercicio2('Cheque',@maximo);
 select @maximo;
 
 
/*3. Escribe un procedimiento que reciba como parámetro de entrada una forma de pago, que será una cadena de caracteres (Ejemplo: PayPal, Transferencia, etc).
Y devuelva como salida los siguientes valores
teniendo en cuenta la forma de pago seleccionada como parámetro de entrada:
• el pago de máximo valor,
• el pago de mínimo valor,
• el valor medio de los pagos realizados,
• la suma de todos los pagos,
• el número de pagos realizados para esa forma de pago.
Deberá hacer uso de la tabla pago de la base de datos jardineria.*/
delimiter $$
drop procedure if exists Ejercicio3 $$
create procedure Ejercicio3(in formaP varchar(40),out max float, out min float, out media float, out suma float, out numPagos float)
begin
	set max = (select max(total) from pago where forma_pago = formaP);
    set min = (select min(total) from pago where forma_pago = formaP);
    set media = (select avg(total) from pago where forma_pago = formaP);
    set suma = (select sum(total) from pago where forma_pago = formaP);
    set numPagos = (select count(total) from pago where forma_pago = formaP);
end
$$
call Ejercicio3('PayPal',@max,@min,@media,@suma,@numPagos);
select @max,@min,@media,@suma,@numPagos; 



/*4. Crea una base de datos llamada procedimientos que contenga una tabla llamada cuadrados. 
La tabla cuadrados debe tener dos columnas de tipo INT UNSIGNED, una columna llamada número y otra
columna llamada cuadrado.
Una vez creada la base de datos y la tabla deberá crear un procedimiento llamado calcular_cuadrados
con las siguientes características. El procedimiento recibe un parámetro de entrada llamado tope de tipo INT
UNSIGNED y calculará el valor de los cuadrados de los primeros números naturales hasta el valor introducido
como parámetro. El valor del números y de sus cuadrados deberán ser almacenados en la tabla cuadrados
que hemos creado previamente.
Tenga en cuenta que el procedimiento deberá eliminar el contenido actual de la tabla antes de insertar los
nuevos valores de los cuadrados que va a calcular.
Utilice un bucle WHILE para resolver el procedimiento.*/
delimiter $$
drop procedure if exists Ejercicio4 $$
create procedure Ejercicio4(in tope int unsigned)
begin
	declare numero int unsigned;
    delete from cuadrados;
    set numero=1;
    while numero <= tope do
		insert into cuadrados values
        (numero,numero*numero);
        set numero = numero+1;
	end while;
end
$$
call Ejercicio4(20);
select * from cuadrados;


/*5. Utilice un bucle REPEAT para resolver el procedimiento del ejercicio anterior.*/
delimiter $$
drop procedure if exists Ejercicio5 $$
create procedure Ejercicio5(in tope int unsigned)
begin
	declare numero int unsigned;
    delete from cuadrados;
    set numero=1;
    repeat
		insert into cuadrados values
        (numero, numero*numero);
        set numero = numero+1;
	until numero > tope
    end repeat;
end
$$
call Ejercicio5(15);
select * from cuadrados;


/*6. Utilice un bucle LOOP para resolver el procedimiento del ejercicio anterior.*/
delimiter $$
drop procedure if exists Ejercicio6 $$
create procedure Ejercicio6(in tope int unsigned)
begin
	declare numero int unsigned;
    delete from cuadrados;
    set numero=1;
    bucle: loop
    if numero <= tope then
		insert into cuadrados values
        (numero, numero*numero);
		set numero = numero + 1;
        iterate bucle;
	end if;
    leave bucle;
	end loop bucle;
end
$$
call Ejercicio6(10);
select * from cuadrados;


/*7. Crea una base de datos llamada procedimientos que contenga una tabla llamada ejercicio. La tabla
debe tener una única columna llamada número y el tipo de dato de esta columna debe ser INT UNSIGNED
.
Una vez creada la base de datos y la tabla deberá crear un procedimiento llamado calcular_números con
las siguientes características. El procedimiento recibe un parámetro de entrada llamado valor_inicial de
tipo INT UNSIGNED y deberá almacenar en la tabla ejercicio toda la secuencia de números desde el valor
inicial pasado como entrada hasta el 1.
Tenga en cuenta que el procedimiento deberá eliminar el contenido actual de las tablas antes de insertar los
nuevos valores.
Utilice un bucle WHILE para resolver el procedimiento.*/
delimiter $$
drop procedure if exists Ejercicio7 $$
create procedure Ejercicio7(in valor_inicial int unsigned)
begin
    delete from ejercicio;
    while valor_inicial > 1 do
		set valor_inicial = valor_inicial-1;
        insert into ejercicio values
        (valor_inicial);
	end while;
end
$$
call Ejercicio7(10);
select * from ejercicio;



/*8. Utilice un bucle REPEAT para resolver el procedimiento del ejercicio anterior.
9. Utilice un bucle LOOP para resolver el procedimiento del ejercicio anterior.
10. Crea una base de datos llamada procedimientos que contenga una tabla llamada pares y otra tabla
llamada impares. Las dos tablas deben tener única columna llamada número y el tipo de dato de esta
columna debe ser INT UNSIGNED.
Una vez creada la base de datos y las tablas deberá crear un procedimiento llamado calcular_pares_impares
con las siguientes características. El procedimiento recibe un parámetro de entrada llamado tope de tipo
INT UNSIGNED y deberá almacenar en la tabla pares aquellos números pares que existan entre el número
1 el valor introducido como parámetro. Habrá que realizar la misma operación para almacenar los números
impares en la tabla impares.
Tenga en cuenta que el procedimiento deberá eliminar el contenido actual de las tablas antes de insertar los
nuevos valores.
Utilice un bucle WHILE para resolver el procedimiento.
Unidad 7. Triggers, procedimientos y funciones en MySQL
2
0
11. Utilice un bucle REPEAT para resolver el procedimiento del ejercicio anterior.
12. Utilice un bucle LOOP para resolver el procedimiento del ejercicio anterior.*/
