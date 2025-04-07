/*1. Creación de usuarios y otorgamiento de privilegios:
● Crea un nuevo usuario llamado 'usuario1' con contraseña 'contraseña1' y
otorga los privilegios SELECT y INSERT en todas las tablas de la base de
datos 'GESTIÓN DE PROYECTOS'.*/
create user 'usuario1'@'%' identified by 'Contraseña.1';
GRANT SELECT, INSERT ON mecanicos.* TO 'usuario1'@'%';

/*2. Revocación de privilegios:
● Revoca el privilegio de DELETE en todas las tablas de la base de datos
'GESTIÓN DE PROYECTOS' para el usuario 'usuario1'.*/
revoke delete on mecanicos.* from 'usuario1'@'%';

/*3. Creación de usuarios con privilegios específicos:
● Crea un nuevo usuario llamado 'usuario2' con contraseña 'contraseña2' y
otorga únicamente el privilegio SELECT en la tabla 'empleado' de la base de
datos 'GESTIÓN DE PROYECTOS'.*/
create user 'usuario2'@'%' identified by 'Contraseña.2';
grant select on Practica5.empleado to 'usuario2'@'%';

/*4. Creación de usuario con privilegios globales:
● Crea un nuevo usuario llamado 'usuario3' con contraseña 'contraseña3' y
otorga el privilegio de CREATE TABLESPACE a nivel global.*/
create user 'usuario3'@'%' identified by 'Contraseña.3';
grant create tablespace on *.* to 'usuario3'@'%'; 

/*5. Eliminación de usuarios:
● Elimina el usuario 'usuario2'.*/
drop user 'usuario2'@'%';

/*6. Modificación de usuarios:
● Cambia la contraseña del usuario 'usuario3' a 'nuevacontraseña'.*/
alter user 'usuario3'@'%' identified by 'Nuevacontraseña.3';

/*7. Combinación de privilegios:
● Otorga al usuario 'usuario1' el privilegio de SELECT en la tabla
'EMPLEADO' y el privilegio de INSERT en la tabla 'TRABAJA’' de la base
de datos"GESTIÓN DE PROYECTOS''.*/














