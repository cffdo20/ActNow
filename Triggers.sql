/*
DELIMITER ##
CREATE TRIGGER  AFTER UPDATE ON 
FOR EACH ROW
BEGIN
    
END; ##
DELIMITER ;
*/
-- Triggers de LOG para projetosocial
use actnow24;
set global log_bin_trust_function_creators=1;
DELIMITER ##
CREATE TRIGGER tg_log_insert_projetosocial AFTER INSERT ON projetosocial
FOR EACH ROW
BEGIN
	declare v_nome_tabela varchar(40) default '';
    set v_nome_tabela = 'projetosocial';
    insert into log(logtabela,logtabcodid,logdatetime) values (v_nome_tabela,new.projid,current_timestamp());
END; ##
DELIMITER ;
drop trigger tg_log_insert_projetosocial;
insert into projetosocial(projtitulo, projdescricao, projpublicoalvo, projjustificativa, projobjetivos, projdatainicio, projdatafinal, projstatus, projuscod) values('teste', 'teste', 'teste', 'teste', 'teste', curdate(), null, 1, 1);
select * from projetosocial;
select * from log order by logdatetime desc;
select * from voluntario;

DELIMITER ##
CREATE TRIGGER tg_log_update_projetosocial AFTER UPDATE ON projetosocial
FOR EACH ROW
BEGIN
    
END; ##
DELIMITER ;

DELIMITER ##
CREATE TRIGGER tg_log_delete_projetosocial AFTER DELETE ON projetosocial
FOR EACH ROW
BEGIN
    
END; ##
DELIMITER ;

-- Triggers de LOG para voluntário

DELIMITER ##
CREATE TRIGGER tg_log_insert_voluntario AFTER INSERT ON voluntario
FOR EACH ROW
BEGIN
    declare v_nome_tabela varchar(40) default '';
    set v_nome_tabela = 'voluntario';
    insert into log(logtabela,logtabcodid,logdatetime) values (v_nome_tabela,new.voluscod,current_timestamp());
END; ##
DELIMITER ;
desc voluntario;
insert into voluntario(volcpf, voluscod, volnome, volnomesocial, volbio, voltelefone, volcidcod) 
values ('teste', 1, 'teste', 'teste', 'teste', '55598765432', 1); 

DELIMITER ##
CREATE TRIGGER tg_log_update_projetosocial AFTER UPDATE ON projetosocial
FOR EACH ROW
BEGIN
    
END; ##
DELIMITER ;

DELIMITER ##
CREATE TRIGGER tg_log_delete_projetosocial AFTER DELETE ON projetosocial
FOR EACH ROW
BEGIN
    
END; ##
DELIMITER ;

-- Triggers de LOG para instituicao

DELIMITER ##
CREATE TRIGGER tg_log_insert_instituicao AFTER INSERT ON instituicao
FOR EACH ROW
BEGIN
    declare v_nome_tabela varchar(40) default '';
    set v_nome_tabela = 'instituicao';
    insert into log(logtabela,logtabcodid,logdatetime) values (v_nome_tabela,new.instuscod,current_timestamp());
END; ##
DELIMITER ;
insert into instituicao(instcnpj, instuscod, instnomefantasia, instrazaosocial,instcidcodigo) values ('11111112345678', 1, 'teste', 'teste',1);

DELIMITER ##
CREATE TRIGGER tg_log_update_projetosocial AFTER UPDATE ON projetosocial
FOR EACH ROW
BEGIN
    
END; ##
DELIMITER ;

DELIMITER ##
CREATE TRIGGER tg_log_delete_projetosocial AFTER DELETE ON projetosocial
FOR EACH ROW
BEGIN
    
END; ##
DELIMITER ;

-- Triggers de LOG para usuario

DELIMITER ##
CREATE TRIGGER tg_log_insert_usuario AFTER INSERT ON usuario
FOR EACH ROW
BEGIN
    declare v_nome_tabela varchar(40) default '';
    set v_nome_tabela = 'usuario';
    insert into log(logtabela,logtabcodid,logdatetime) values (v_nome_tabela,new.uscodigo,current_timestamp());
END; ##
DELIMITER ;
insert into usuario(ususername, usemail, ususenha) values ('teste', 'teste', 'senha');

DELIMITER ##
CREATE TRIGGER tg_log_update_usuario AFTER UPDATE ON  usuario
FOR EACH ROW
BEGIN
    declare v_nome_tabela varchar(40) default '';
    declare v_alteracoes_tabela varchar(1000) default '';
    declare v_status_ususername, v_status_usemail, v_status_ususenha boolean default false;
    set v_nome_tabela = 'usuario';
    if new.ususername!=old.ususername then set v_status_ususername=true; end if;
    if new.usemail!=old.usemail then set v_status_usemail=true; end if;
    if new.ususenha!=old.ususenha then set v_status_ususenha=true; end if;
    if v_status_ususername then
		if v_status_usemail then
			if v_status_ussenha then
				set v_alteracoes_tabela =  concat('ususername,',old.ususername,"|usemail,",old.usemail,'|ususenha,',)
			end if;
			
        end if;
    else
    end if;
    if v_status_ussenha
				
	end if;
    insert into log(logtabela,logtabcodid,logdatetime) values (v_nome_tabela,new.uscodigo,v_alteracoes_tabela,current_timestamp());
END; ##
DELIMITER ;

DELIMITER ##
CREATE TRIGGER tg_log_delete_projetosocial AFTER DELETE ON projetosocial
FOR EACH ROW
BEGIN
    
END; ##
DELIMITER ;