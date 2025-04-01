create database if not exists joins;
use joins;

create table juego(
id_juego int not null,
nombre_juego varchar(255) default null,
primary key (id_juego)
)engine = InnoDB;

create table usuario(
id_usuario int not null,
username varchar(255) default null,
primary key (id_usuario)
)engine = InnoDB;

create table juegoyusuario(
id_usuario int not null,
id_juego int not null,
primary key (id_usuario, id_juego),
foreign key (id_usuario) references usuario(id_usuario) on delete cascade on update cascade,
foreign key (id_juego) references juego(id_juego) on delete cascade on update cascade
)engine=InnoDB;

insert into usuario values
("1","vichaunter"),
("2","pepito"),
("3","jaimito"),
("4","ataulfo");

insert into juego values
("1","Final Fantasy VII"),
("2","Zelda: A link to the past"),
("3","Crazy Taxy"),
("4","Donkey Kong Country"),
("5","Fallout 4"),
("6","Saints Row III"),
("7","La taba");

insert into juegoyusuario values
("1","1"),
("1","2"),
("1","3"),
("1","4"),
("1","6"),
("1","7"),
("2","3"),
("2","7"),
("4","1"),
("4","2"),
("4","4"),
("4","7");

/*A)Cuántos juegos tiene asignados cada usuario*/
select username, count(id_juego)
from usuario
left join juegoyusuario
on usuario.id_usuario = juegoyusuario.id_usuario
group by usuario.id_usuario;

/*B)Queremos saber todos los juegos que tenemos, y a qué usuarios pertenecen*/
select nombre_juego, username
from juego
left join juegoyusuario
on juegoyusuario.id_juego=juego.id_juego
left join usuario
on juegoyusuario.id_usuario=usuario.id_usuario;

/*C)Mostrar todos los usuarios que tienen asignados al menos un juego*/
select username
from usuario
right join juegoyusuario
on usuario.id_usuario = juegoyusuario.id_usuario
group by juegoyusuario.id_usuario
having count(id_juego) > 1;







