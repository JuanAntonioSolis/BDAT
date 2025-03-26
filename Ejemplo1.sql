create database ejemplo1;
create table estacion(
identificador mediumint unsigned not null,
latitud varchar(14),
longitud varchar(15),
altitud mediumint,
primary key (identificador)
);

create table muestra(
identificadorEstacion mediumint unsigned not null,
fecha date,
temperaturaMinima tinyint,
temperaturaMaxima tinyint,
precipitaciones smallint unsigned,
humedadMinima tinyint unsigned,
humedadMaxima tinyint unsigned,
velocidadVientoMin smallint unsigned,
velocidadVientoMax smallint unsigned,
foreign key (identificadorEstacion) references estacion(identificador) on delete cascade on update cascade);

describe estacion;
describe muestra;

