drop database if exists actnow24;
create database actnow24;
use actnow24;

create table usuario(
	uscodigo int UNSIGNED NOT NULL AUTO_INCREMENT,
    ususername varchar(20) unique not null,
    usemail varchar(80) not null,
    ususenha varchar(15) null,
    primary key (uscodigo)
);

create table instituicao(
	instcnpj char(14) not null,
    instuscod int unsigned not null,
    instnomefantasia varchar(100) not null,
    instrazaosocial varchar(100) unique not null,
    primary key (instcnpj),
    FOREIGN KEY (instuscod) REFERENCES usuario (uscodigo)
);

create table estado(
	estcodigo int unsigned not null auto_increment,
    estsigla char(2) unique not null,
    estnome varchar(30) unique not null,
    primary key (estcodigo)
);

create table cidade(
	cidcodigo int unsigned not null auto_increment,
    cidnome varchar(40) not null,
    cidestcod int unsigned not null,
    primary key (cidcodigo),
    foreign key (cidestcod) references estado (estcodigo)
);

create table voluntario(
	volcpf char(11) not null,
    voluscod int unsigned not null,
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
    projtitulo varchar(100) unique not null,
    projdescricao varchar(500) not null,
    projpublicoalvo varchar(45) not null,
    projjustificativa varchar(100) not null,
    projobjetivos varchar(100) not null,
    projdatainicio date not null,
    projdatafinal date null,
    projstatus tinyint not null,
    projuscod int unsigned not null,
    primary key(projid),
    foreign key (projuscod) references usuario (uscodigo)
);

create table atividade(
	atid int unsigned not null auto_increment,
    attitulo varchar(100) not null,
    atdescricao varchar(200) not null,
    atdataentrega date null,
    atstatus tinyint not null,
    atprojid int unsigned not null,
    primary key (atid),
    foreign key (atprojid) references projetosocial(projid)
);

create table habilidade(
	habid int unsigned not null auto_increment,
    habnome varchar(20),
    primary key (habid)
);

create table voluntariohabilidade(
	volhabid int unsigned not null,
    volhabcpf char(11) not null,
    primary key(volhabid, volhabcpf),
    foreign key (volhabid) references habilidade(habid),
    foreign key (volhabcpf) references voluntario(volcpf)
);

create table diasemana(
	dsid int unsigned not null auto_increment,
    dsnomeclatura varchar(15) not null,
    primary key (dsid)
);

create table turnodia(
	turid int unsigned not null auto_increment,
    turnomeclatura varchar(10) not null,
    primary key (turid)
);

create table voluntariodiasemana(
	voldsid int unsigned not null,
    voldscpf char(11) not null,
    voldsturid int unsigned not null,
    primary key(voldsid,voldscpf,voldsturid),
    foreign key (voldsid) references diasemana(dsid),
    foreign key (voldscpf) references voluntario(volcpf),
    foreign key (voldsturid) references turnodia(turid)
);

create table voluntarioprojeto(
	volprojid int unsigned not null,
    volprojcpf char(11) not null,
    primary key(volprojid, volprojcpf),
    foreign key (volprojid) references projetosocial(projid),
    foreign key (volprojcpf) references voluntario(volcpf)
);

create table instituicaoprojeto(
	instprojid int unsigned not null,
    instprojcnpj char(14) not null,
    primary key(instprojid, instprojcnpj),
    foreign key (instprojid) references projetosocial(projid),
    foreign key (instprojcnpj) references instituicao(instcnpj)
);

create table projetosocialfuncionamento(
	projfunprojid int unsigned not null,
    projfundsid int unsigned not null,
    projfunturid int unsigned not null,
    primary key(projfunprojid, projfundsid, projfunturid),
    foreign key (projfundsid) references diasemana(dsid),
    foreign key (projfunprojid) references projetosocial(projid),
    foreign key (projfunturid) references turnodia(turid)
);

-- criando tabela de logs
create table log(
	logcodigo int unsigned auto_increment not null,
    logtabela varchar(40) not null default '',
    logtabcodid int unsigned not null,
    logalteracoes varchar(1000) null default '',
    logdatetime datetime not null,
	primary key(logcodigo)
);