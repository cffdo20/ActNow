create schema actnow2024;
use actnow2024;

create table usuario(
	uscodigo int UNSIGNED NOT NULL AUTO_INCREMENT DEFAULT '10000',
    ususername varchar(20) not null,
    usemail varchar(80) not null,
    primary key (usucodigo)
);

create table instituicao(
	instcnpj char(14) not null,
    instuscod int unsigned not null,
    instnomefantasia varchar(100) not null,
    instrazaosocial varchar(100) not null,
    primary key (instcnpj),
    FOREIGN KEY (instuscod) REFERENCES usuario (uscodigo)
);

create table voluntario(
	volcpf char(11) not null,
    volusacod int not null,
    volnome varchar(80) not null,
    volnomesocial varchar(100) null,
    volbio varchar(300),
    voltelefone char(11) not null,
    primary key (volcpf),
    foreign key (voluscod) references usuario(uscodigo)
);

create table 

