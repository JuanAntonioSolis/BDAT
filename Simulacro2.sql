create database pruebaExamen;
use jardineria;

/*a)
• Función: calcular_precio_total_pedido
• Descripción: Dado un código de pedido la función debe calcular la suma total del pedido. Tenga en cuenta
que un pedido puede contener varios productos diferentes y varias cantidades de cada producto.
• Parámetros de entrada: codigo_pedido (INT)
• Parámetros de salida: El precio total del pedido (FLOAT)*/

/*select sum(cantidad*precio_unidad) as Total
				from detalle_pedido
                where codigo_pedido = 1
                group by codigo_pedido;*/

delimiter $$
drop function if exists calcular_precio_total_pedido $$
create function calcular_precio_total_pedido(codPedido int)
returns float deterministic
begin
	declare total float;
    
    set total = (select sum(cantidad*precio_unidad) as Total
				from detalle_pedido
                where codigo_pedido = codPedido
                group by codigo_pedido);
	return total;
end
$$

select calcular_precio_total_pedido(1);

/*b)
• Función: calcular_suma_pedidos_cliente
• Descripción: Dado un código de cliente la función debe calcular la suma total
 de todos los pedidos realizados por el cliente. Deberá hacer uso de la función
 calcular_precio_total_pedido que ha desarrollado en el apartado anterior.
 
• Parámetros de entrada: codigo_cliente (INT)
• Parámetros de salida: La suma total de todos los pedidos del cliente (FLOAT)*/

delimiter $$
drop function if exists calcular_suma_pedidos_cliente $$
create function calcular_suma_pedidos_cliente(codCliente int)
returns float deterministic
begin
	declare totalPedido float;
    set totalPedido = (select count(codigo_cliente)
						from pedido
                        where codigo_cliente = codCliente
                        group by codigo_cliente);
	return totalPedido;
end
$$

select calcular_suma_pedidos_cliente(1);

/*c)
• Función: calcular_suma_pagos_cliente
• Descripción: Dado un código de cliente la función debe calcular la suma total de los pagos realizados por
ese cliente.
• Parámetros de entrada: codigo_cliente (INT)
• Parámetros de salida: La suma total de todos los pagos del cliente (FLOAT)*/

delimiter $$
drop function if exists calcular_suma_pagos_cliente $$
create function calcular_suma_pagos_cliente(codCli int)
returns float deterministic
begin
	declare totalPagos float;
    set totalPagos = (select sum(total)
						from pago
                        where codigo_cliente = codCli
                        group by codigo_cliente);
	return totalPagos;
end
$$

select calcular_suma_pagos_cliente(1);

/*d)
• Procedimiento: calcular_pagos_pendientes
• Descripción: Deberá calcular los pagos pendientes de todos los clientes. Para saber si un cliente tiene
algún pago pendiente deberemos calcular cuál es la cantidad de todos los pedidos y los pagos que ha
realizado. Si la cantidad de los pedidos es mayor que la de los pagos entonces ese cliente tiene pagos
pendientes.

Deberá insertar en una tabla llamada clientes_con_pagos_pendientes los siguientes datos:
• id_cliente
• suma_total_pedidos
• suma_total_pagos
• pendiente_de_pago*/

/*Cantidad pagos*/
delimiter $$
drop function if exists cantidadPagos $$
create function cantidadPagos(codCli int)
returns float deterministic
begin
	declare totalPagos float;
    set totalPagos = (select count(codigo_cliente)
						from pago
                        where codigo_cliente = codCli
                        group by codigo_cliente);
	return totalPagos;
end
$$

select cantidadPagos(1);

/*Numero clientes*/
select count(codigo_cliente)
from cliente;

/*Creacion tabla*/
create table clientes_con_pagos_pendientes(
codigo_cliente int not null,
suma_total_pedidos int,
suma_total_pagos int,
pendiente_de_pago int,
primary key (codigo_cliente),
foreign key (codigo_cliente) references cliente(codigo_cliente)
);

delimiter $$
drop procedure if exists calcular_pagos_pendientes $$
create procedure calcular_pagos_pendientes()
begin
	declare num int default 3;
    declare max_id int;
    TRUNCATE TABLE clientes_con_pagos_pendientes;

    set max_id = (select count(codigo_cliente)
					from cliente);
    while num <= max_id do
	
		if	(select cantidadPagos(num)) < (select calcular_suma_pedidos_cliente(num)) then
			insert into clientes_con_pagos_pendientes values
            (num, calcular_suma_pedidos_cliente(num), cantidadPagos(num), calcular_suma_pedidos_cliente(num) - cantidadPagos(num));
		end if;
        set num = num+1;
	end while;
end
$$

call calcular_pagos_pendientes();

/*15. Escriba un procedimiento llamado obtener_numero_empleados que reciba como parámetro de entrada el código de una oficina y devuelva el número de empleados que tiene.
Escriba una sentencia SQL que realice una llamada al procedimiento realizado para comprobar que se ejecuta
correctamente.*/
delimiter $$
drop procedure if exists obtener_numero_empleados $$
create procedure obtener_numero_empleados(in codOficina VARCHAR(10))
begin
	select count(codigo_empleado)
    from empleado
    where codigo_oficina = codOficina
    group by codigo_oficina;
end
$$

call obtener_numero_empleados("TAL-ES");

/*16. Escriba una función llamada cantidad_total_de_productos_vendidos que reciba como parámetro
de entrada el código de un producto y devuelva la cantidad total de productos que se han vendido con 
ese código.
Escriba una sentencia SQL que realice una llamada a la función realizada para comprobar que se ejecuta correctamente.*/
delimiter $$
drop function if exists cantidad_total_de_productos_vendidos $$
create function cantidad_total_de_productos_vendidos(codProd VARCHAR(15))
returns int deterministic
begin
	declare total int;
    set total = (select sum(cantidad)
				 from detalle_pedido
                 where codigo_producto = codProd
                 group by codigo_producto);
	return total;
end
$$

select cantidad_total_de_productos_vendidos('OR-141');

















