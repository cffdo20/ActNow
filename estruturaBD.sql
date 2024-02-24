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
    volcidcod int unsigned not null,
    primary key (volcpf),
    foreign key (voluscod) references usuario(uscodigo),
    foreign key (volcidcod) references cidade(cidcodigo)
);

create table projetosocial(
	projid int unsigned not null auto_increment,
    projtitulo varchar(100) not null,
    projdescricao varchar(500) not null,
    projpublicoalvo varchar(45) not null,
    projjustificativa varchar(100) not null,
    projobjetivos varchar(100) not null,
    projdatainicio date not null,
    projdatafinal date null,
    projstatus tinyint not null,
    projuscodigo int not null,
    primary key(projid),
    foreign key (projuscodigo) references usuario (uscodigo)
);

create table atividade();

create table cidade(
	cidcodigo int unsigned not null auto_increment,
    
);

create table estado();

create table habilidade();

create table voluntariohabilidade();

create table diasemana();

create table turnodia();

create table voluntariodiasemana();

create table voluntarioprojeto();

create table instituicaoprojeto();