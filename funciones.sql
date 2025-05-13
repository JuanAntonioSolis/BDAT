/*FUNCIONES*/
set GLOBAL log_bin_trust_function_creators =1; /*Para crear funciones*/
use TIENDA;

/*FUNCIONES SIN SENTENCIAS*/
/*1. Escribe una función que reciba un número entero de entrada y devuelva TRUE si el número es par o FALSE
en caso contrario*/
delimiter $$
drop function if exists esPar $$
create function esPar(num int unsigned)
returns boolean
begin
	declare par boolean;
    if num%2=0 then
		set par = true;
	else
		set par = false;
end if;
return par;
end
$$

select esPar(10);

/*2. Escribe una función que devuelva el valor de la hipotenusa de un triángulo a partir de los valores de sus
lados*/
delimiter $$
drop function if exists hipotenusa $$
create function hipotenusa(lado1 float,lado2 float)
returns float
begin
	declare hipot float;
    set hipot=sqrt(pow(lado1, 2) + pow(lado2,2));
return hipot;
end
$$

select hipotenusa(10,8);

/*3. Escribe una función que reciba como parámetro de entrada un valor numérico que represente un día de
la semana y que devuelva una cadena de caracteres con el nombre del día de la semana correspondiente.
Por ejemplo, para el valor de entrada 1 debería devolver la cadena lunes.*/
delimiter $$
drop function if exists diaSemana $$
create function diaSemana(num int)
returns varchar(50)
begin
	declare dia varchar(50);
    case num
		when 1 then
			set dia = 'Lunes';
		when 2 then
			set dia = 'Martes';
		when 3 then
			set dia = 'Miércoles';
		when 4 then
			set dia = 'Jueves';
		when 5 then
			set dia = 'Viernes';
		when 6 then
			set dia = 'Sábado';
		when 7 then
			set dia = 'Domingo';
		else
			set dia = 'Día no válido';
	end case;
return dia;
end
$$

select diaSemana(5);

/*4. Escribe una función que reciba tres números reales como parámetros de entrada y devuelva el mayor de
los tres.*/
delimiter $$
drop function if exists mayor $$
create function mayor(num1 int, num2 int, num3 int)
returns int
begin
	declare mayor int;
    if num1 > num2 and num1 > num3 then
		set mayor = num1;
	elseif num2 > num1 && num2 > num3 then
		set mayor = num2;
	elseif num3 > num1 and num3 > num2 then
		set mayor = num3;
	end if;
return mayor;
end
$$

select mayor(91,15,20);

/*5. Escribe una función que devuelva el valor del área de un círculo a partir del valor del radio que se recibirá
como parámetro de entrada.*/
delimiter $$
drop function if exists area $$
create function area(radio float)
returns float
begin
	declare a float;
    set a = pi()*pow(radio,2);
    return a;
end
$$

select area(5);

/*6. Escribe una función que devuelva como salida el número de años que han transcurrido entre dos fechas
que se reciben como parámetros de entrada. Por ejemplo, si pasamos como parámetros de entrada las
fechas 2018-01-01 y 2008-01-01 la función tiene que devolver que han pasado 10 años.*/
delimiter $$
drop function if exists intervalo $$
create function intervalo(fecha1 date, fecha2 date)
returns int
begin
	declare interv int;
    set interv = datediff(fecha1, fecha2)/365;
return interv;
end
$$

select intervalo("2018-01-01", "2008-01-01");


/*--------------------------------------------------------------------------------------------------*/
/*FUNCIONES CON SENTENCIAS SQL*/
/*1. Escribe una función para la base de datos tienda que devuelva el número total de productos que hay en
la tabla productos.*/
delimiter $$
drop function if exists calcularTotal $$
create function calcularTotal()
returns int
begin
	declare total int;
    set total=(select count(*) from Articulos);
    return total;
end
$$

select calcularTotal();

/*2. Escribe una función para la base de datos tienda que devuelva el valor medio del precio de los productos
de un determinado fabricante que se recibirá como parámetro de entrada. El parámetro de entrada será
el nombre del fabricante.*/
delimiter $$
drop function if exists mediaProductosFab $$
create function mediaProductosFab(fabricante varchar(50))
returns float
begin
	declare media float;
    set media = (select avg(Articulos.precio) 
					from Articulos,Fabricantes 
                    where Articulos.clave_fabricante = Fabricantes.clave_fabricante
					and Fabricantes.nombre = fabricante);
return media;
end
$$

select mediaProductosFab("Logitech");

/*3. Escribe una función para la base de datos tienda que devuelva el 
valor máximo del precio de los productos de un determinado fabricante que se recibirá como parámetro de entrada. El parámetro de entrada
será el nombre del fabricante.*/
delimiter $$
drop function if exists precioMax $$
create function precioMax(fabricante varchar(50))
returns float
begin
	declare pMax float;
    set pMax = (select max(precio)
				from Articulos, Fabricantes
                where Articulos.clave_fabricante=Fabricantes.clave_fabricante
				and Fabricantes.nombre = fabricante);
return pMax;
end
$$

select precioMax("Seagate");

/*4. Escribe una función para la base de datos tienda que
devuelva el valor mínimo del precio de los productos de un determinado fabricante que se recibirá como parámetro de entrada. El parámetro de entrada
será el nombre del fabricante.*/
delimiter $$
drop function if exists precioMin $$
create function precioMin(fabricante varchar(50))
returns float
begin
	declare pMin float;
    set pMin = (select min(precio)
				from Articulos, Fabricantes
                where Articulos.clave_fabricante=Fabricantes.clave_fabricante
				and Fabricantes.nombre = fabricante);
return pMin;
end
$$

select precioMin("Adata");