/*1. Creación de usuarios y otorgamiento de privilegios:
● Crea un nuevo usuario llamado 'usuario1' con contraseña 'contraseña1' y
otorga los privilegios SELECT y INSERT en todas las tablas de la base de
datos 'GESTIÓN DE PROYECTOS'.*/
create user 'usuario1'@'%' identified by 'Contraseña.1';
GRANT SELECT, INSERT ON Practica5.* TO 'usuario1'@'%';

/*2. Revocación de privilegios:
● Revoca el privilegio de DELETE en todas las tablas de la base de datos
'GESTIÓN DE PROYECTOS' para el usuario 'usuario1'.*/
revoke delete on Practica5.* from 'usuario1'@'%';

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
grant select on Practica5.empleado to 'usuario1'@'%';
grant insert on Practica5.trabaja to 'usuario1'@'%';

/*8. Revocación de todos los privilegios:
● Revoca todos los privilegios para el usuario 'usuario1'.*/
revoke all privileges on Practica5.* from 'usuario1'@'%';

/*9. Otorgamiento de privilegios a nivel de columna:
● Otorga al usuario 'usuario1' el privilegio de SELECT en la columna 'nombre'
de la tabla 'EMPLEADO' de la base de datos 'GESTIÓN DE PROYECTOS'.*/
grant select (nombre) on Practica5.empleado to 'usuario1'@'%';

/*10. Revocación de privilegios a nivel de columna:
● Revoca el privilegio de INSERT en la columna 'fecha_ingreso' de la tabla
'empleado' para el usuario 'usuario1'.*/
revoke insert (fecha_ingreso) on Practica5.empleado from 'usuario1'@'%';

/*11. Creación de usuario con permisos de solo lectura a nivel global:
● Crea un nuevo usuario llamado 'lectorglobal' con contraseña 'contraseña4' y
otorga únicamente el privilegio SELECT a nivel global.*/
create user 'lectorglobal'@'%' identified by 'Contraseña.4';
grant select on *.* to 'lectorglobal'@'%';

/*12. Revocación de todos los privilegios a nivel global:
● Revoca todos los privilegios a nivel global para el usuario 'lectorglobal'.*/
revoke all privileges on *.* from 'lectorglobal'@'%';












