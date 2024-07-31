/*
DELIMITER ##
CREATE TRIGGER  AFTER UPDATE ON 
FOR EACH ROW
BEGIN
    
END; ##
DELIMITER ;
*/
-- Triggers de LOG para projetosocial

-- log para insert
use actnow24;
set global log_bin_trust_function_creators=1;
DELIMITER ##
CREATE TRIGGER tg_log_insert_projetosocial AFTER INSERT ON projetosocial
FOR EACH ROW
BEGIN
	declare v_nome_tabela varchar(40) default '';
    set v_nome_tabela = 'projetosocial';
    insert into log(logtabela,logtabcodid,logdatetime,logoperacao) values (v_nome_tabela,new.projid,current_timestamp(),'insert');
END; ##
DELIMITER ;

-- log para update
DELIMITER ##
CREATE TRIGGER tg_log_update_projetosocial AFTER UPDATE ON projetosocial
FOR EACH ROW
BEGIN
    declare v_nome_tabela varchar(40) default '';
    declare v_alteracoes_tabela varchar(1000) default '';
    declare v_status_projtitulo, v_status_projdescricao, v_status_projpublicoalvo, v_status_projjustificativa, v_status_projobjetivos, v_status_projdatainicio, v_status_projdatafinal, v_status_projstatus boolean default false;
    set v_nome_tabela = 'projetosocial';
    if not new.projtitulo=old.projtitulo then set v_status_projtitulo=true; end if;
    if not new.projdescricao=old.projdescricao then set v_status_projdescricao=true; end if;
    if not new.projpublicoalvo=old.projpublicoalvo then set v_status_projpublicoalvo=true; end if;
    if not new.projjustificativa=old.projjustificativa then set v_status_projjustificativa=true; end if;
    if not new.projobjetivos=old.projobjetivos then set v_status_projobjetivos=true; end if;
    if not new.projdatainicio=old.projdatainicio then set v_status_projdatainicio=true; end if;
    if not new.projdatafinal=old.projdatafinal then set v_status_projdatafinal=true; end if;
    if not new.projstatus=old.projstatus then set v_status_projstatus=true; end if;
    if v_status_projtitulo then
		set v_alteracoes_tabela = concat(v_alteracoes_tabela,'projtitulo,',old.projtitulo,'|');
    end if;
    if v_status_projdescricao then
		set v_alteracoes_tabela = concat(v_alteracoes_tabela,"projdescricao,",old.projdescricao,'|');
    end if;
    if v_status_projpublicoalvo then
		set v_alteracoes_tabela = concat(v_alteracoes_tabela,'projpublicoalvo,',old.projpublicoalvo,'|');
    end if;
    if v_status_projjustificativa then
		set v_alteracoes_tabela = concat(v_alteracoes_tabela,'projjustificativa,',old.projjustificativa,'|');
    end if;
    if v_status_projobjetivos then
		set v_alteracoes_tabela = concat(v_alteracoes_tabela,'projobjetivos,',old.projobjetivos,'|');
    end if;
    if v_status_projdatainicio then
		set v_alteracoes_tabela = concat(v_alteracoes_tabela,'projdatainicio,',old.projdatainicio,'|');
    end if;
    if v_status_projdatafinal then
		set v_alteracoes_tabela = concat(v_alteracoes_tabela,'projdatafinal,',ifnull(old.projdatafinal,'null'),'|');
    end if;
    if v_status_projstatus then
		set v_alteracoes_tabela = concat(v_alteracoes_tabela,'projstatus,',old.projstatus,'|');
    end if;
    insert into log(logtabela,logtabcodid,logalteracoes,logdatetime,logoperacao) values (v_nome_tabela,new.projid,v_alteracoes_tabela,current_timestamp(),'update');
END; ##
DELIMITER ;

-- Log para delete
DELIMITER ##
CREATE TRIGGER tg_log_delete_projetosocial before DELETE ON projetosocial
FOR EACH ROW
BEGIN
    declare v_nome_tabela varchar(40) default '';
    declare v_alteracoes_tabela varchar(1500) default '';
    declare v_alteracao_1, v_alteracao_2, v_alteracao_3, v_alteracao_4, v_alteracao_5, v_alteracao_6, v_alteracao_7, v_alteracao_8, v_alteracao_9, v_alteracao_10 varchar(500) default '';
    set v_nome_tabela = 'projetosocial';
    set v_alteracao_1 = concat('projid,',old.projid,'|');
    set v_alteracao_2 = concat('projtitulo,',old.projtitulo,'|');
    set v_alteracao_3 = concat('projdescricao,',old.projdescricao,'|');
    set v_alteracao_4 = concat('projpublicoalvo,',old.projpublicoalvo,'|');
    set v_alteracao_5 = concat('projjustificativa,',old.projjustificativa,'|');
    set v_alteracao_6 = concat('projobjetivos,',old.projobjetivos,'|');
    set v_alteracao_7 = concat('projdatainicio,',old.projdatainicio,'|');
    set v_alteracao_8 = concat('projdatafinal,',ifnull(old.projdatafinal,'null'),'|');
    set v_alteracao_9 = concat('projstatus,',old.projstatus,'|');
    set v_alteracao_10 = concat('projuscod,',old.projuscod,'|');
    set v_alteracoes_tabela = concat(v_alteracao_1, v_alteracao_2, v_alteracao_3, v_alteracao_4, v_alteracao_5, v_alteracao_6, v_alteracao_7, v_alteracao_8, v_alteracao_9, v_alteracao_10);
    insert into log(logtabela,logtabcodid,logalteracoes,logdatetime,logoperacao) values (v_nome_tabela,old.projid,v_alteracoes_tabela,current_timestamp(),'delete');
END; ##
DELIMITER ;

-- Triggers de LOG para voluntário

-- log para insert
DELIMITER ##
CREATE TRIGGER tg_log_insert_voluntario AFTER INSERT ON voluntario
FOR EACH ROW
BEGIN
    declare v_nome_tabela varchar(40) default '';
    set v_nome_tabela = 'voluntario';
    insert into log(logtabela,logtabcodid,logdatetime,logoperacao) values (v_nome_tabela,new.voluscod,current_timestamp(),'insert');
END; ##
DELIMITER ;

-- log para update
DELIMITER ##
CREATE TRIGGER tg_log_update_voluntario AFTER UPDATE ON voluntario
FOR EACH ROW
BEGIN
    declare v_nome_tabela varchar(40) default '';
    declare v_alteracoes_tabela varchar(1000) default '';
    declare v_status_volnome, v_status_volnomesocial, v_status_volbio, v_status_voltelefone, v_status_volcidcod boolean default false;
    set v_nome_tabela = 'voluntario';
    if not new.volnome=old.volnome then set v_status_volnome=true; end if;
    if not new.volnomesocial=old.volnomesocial then set v_status_volnomesocial=true; end if;
    if not new.volbio=old.volbio then set v_status_volbio=true; end if;
    if not new.voltelefone=old.voltelefone then set v_status_voltelefone=true; end if;
    if not new.volcidcod=old.volcidcod then set v_status_volcidcod=true; end if;
    if v_status_volnome then
		set v_alteracoes_tabela = concat(v_alteracoes_tabela,'volnome,',old.volnome,'|');
    end if;
    if v_status_volnomesocial then
		set v_alteracoes_tabela = concat(v_alteracoes_tabela,"volnomesocial,",old.volnomesocial,'|');
    end if;
    if v_status_volbio then
		set v_alteracoes_tabela = concat(v_alteracoes_tabela,'volbio,',ifnull(old.volbio,'null'),'|');
    end if;
    if v_status_voltelefone then
		set v_alteracoes_tabela = concat(v_alteracoes_tabela,'voltelefone,',old.voltelefone,'|');
    end if;
    if v_status_volcidcod then
		set v_alteracoes_tabela = concat(v_alteracoes_tabela,'volcidcod,',old.volcidcod,'|');
    end if;
    insert into log(logtabela,logtabcodid,logalteracoes,logdatetime,logoperacao) values (v_nome_tabela,new.voluscod,v_alteracoes_tabela,current_timestamp(),'update');
END; ##
DELIMITER ;

-- Log para delete
DELIMITER ##
CREATE TRIGGER tg_log_delete_voluntario AFTER DELETE ON voluntario
FOR EACH ROW
BEGIN
    declare v_nome_tabela varchar(40) default '';
    declare v_alteracoes_tabela varchar(1500) default '';
    declare v_alteracao_1, v_alteracao_2, v_alteracao_3, v_alteracao_4, v_alteracao_5, v_alteracao_6, v_alteracao_7 varchar(500) default '';
    set v_nome_tabela = 'voluntario';
    set v_alteracao_1 = concat('volcpf,',old.volcpf,'|');
    set v_alteracao_2 = concat('voluscod,',old.voluscod,'|');
    set v_alteracao_3 = concat('volnome,',old.volnome,'|');
    set v_alteracao_4 = concat('volnomesocial,',old.volnomesocial,'|');
    set v_alteracao_5 = concat('volbio,',ifnull(old.volbio,'null'),'|');
    set v_alteracao_6 = concat('voltelefone,',old.voltelefone,'|');
    set v_alteracao_7 = concat('volcidcod,',old.volcidcod,'|');
    set v_alteracoes_tabela = concat(v_alteracao_1, v_alteracao_2, v_alteracao_3, v_alteracao_4, v_alteracao_5, v_alteracao_6, v_alteracao_7);
    insert into log(logtabela,logtabcodid,logalteracoes,logdatetime,logoperacao) values (v_nome_tabela,old.voluscod,v_alteracoes_tabela,current_timestamp(),'delete');	
END; ##
DELIMITER ;


-- Triggers de LOG para usuario

-- log para insert
DELIMITER ##
CREATE TRIGGER tg_log_insert_usuario AFTER INSERT ON usuario
FOR EACH ROW
BEGIN
    declare v_nome_tabela varchar(40) default '';
    set v_nome_tabela = 'usuario';
    insert into log(logtabela,logtabcodid,logdatetime) values (v_nome_tabela,new.uscodigo,current_timestamp(),'insert');
END; ##
DELIMITER ;

-- log para update
DELIMITER ##
CREATE TRIGGER tg_log_update_usuario after UPDATE ON usuario
FOR EACH ROW
BEGIN
    declare v_nome_tabela varchar(40) default '';
    declare v_alteracoes_tabela varchar(1000) default '';
    declare v_status_ususername, v_status_usemail, v_status_ususenha boolean default false;
    set v_nome_tabela = 'usuario';
    if not new.ususername=old.ususername then set v_status_ususername=true; end if;
    if not new.usemail=old.usemail then set v_status_usemail=true; end if;
    if not new.ususenha=old.ususenha then set v_status_ususenha=true; end if;
    if v_status_ususername then
		set v_alteracoes_tabela = concat(v_alteracoes_tabela,'ususername,',old.ususername,'|');
    end if;
    if v_status_usemail then
		set v_alteracoes_tabela = concat(v_alteracoes_tabela,"usemail,",old.usemail,'|');
    end if;
    if v_status_ususenha then
		set v_alteracoes_tabela = concat(v_alteracoes_tabela,'ususenha,',old.ususenha,'|');
    end if;
    insert into log(logtabela,logtabcodid,logalteracoes,logdatetime,logoperacao) values (v_nome_tabela,new.uscodigo,v_alteracoes_tabela,current_timestamp(),'update');
END; ##
DELIMITER ;

-- Log para delete
DELIMITER ##
CREATE TRIGGER tg_log_delete_usuario AFTER DELETE ON usuario
FOR EACH ROW
BEGIN
    declare v_nome_tabela varchar(40) default '';
    declare v_alteracoes_tabela varchar(1500) default '';
    declare v_alteracao_1, v_alteracao_2, v_alteracao_3, v_alteracao_4 varchar(500) default '';
    set v_nome_tabela = 'usuario';
    set v_alteracao_1 = concat('uscodigo,',old.uscodigo,'|');
    set v_alteracao_2 = concat('ususername,',old.ususername,'|');
    set v_alteracao_3 = concat("usemail,",old.usemail,'|');
    set v_alteracao_4 = concat('ususenha,',old.ususenha,'|');
    set v_alteracoes_tabela = concat(v_alteracao_1, v_alteracao_2, v_alteracao_3, v_alteracao_4);
    insert into log(logtabela,logtabcodid,logalteracoes,logdatetime,logoperacao) values (v_nome_tabela,old.uscodigo,v_alteracoes_tabela,current_timestamp(),'delete');
END; ##
DELIMITER ;

-- Trigger para mudar disponibilidade de voluntário insert
DELIMITER ##
CREATE TRIGGER tg_disponibilidade_voluntario AFTER insert ON voluntarioprojeto
FOR EACH ROW
BEGIN
    update voluntario set volstatusdisponibilidade=1 where volcpf=new.volprojcpf;
END; ##
DELIMITER ;
-- Trigger para mudar disponibilidade de voluntário delete
DELIMITER ##
CREATE TRIGGER tg_ddisponibilidade_voluntario AFTER delete ON voluntarioprojeto
FOR EACH ROW
BEGIN
    update voluntario set volstatusdisponibilidade=0 where volcpf=old.volprojcpf;
END; ##
DELIMITER ;