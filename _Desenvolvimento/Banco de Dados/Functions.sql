use actnow24;
set global log_bin_trust_function_creators=1;

-- FUNÇÕES -------------------------------------------------


-- Função para validar string de status.
DELIMITER $$
CREATE FUNCTION f_validar_string_status(p_vss_atstatus VARCHAR(1)) RETURNS boolean
BEGIN
    RETURN p_vss_atstatus in ('1','0');
END$$
DELIMITER ;

-- select f_validar_string_status('1');

-- Função para transforma string de status em tinyint.
DELIMITER $$
CREATE FUNCTION f_transformar_string_status(p_tss_atstatus VARCHAR(1)) RETURNS tinyint
BEGIN
    DECLARE v_tss_status_tinyint tinyint default 0;
    
    if(p_tss_atstatus='1') then
		set v_tss_status_tinyint = 1;
    else
		if (p_tss_atstatus='0') then
			set v_tss_status_tinyint = 0;
		end if;
    end if;
    
    RETURN v_tss_status_tinyint;
END$$
DELIMITER ;

-- select f_transformar_string_status('1');

-- Função para gerar string com base no status.
DELIMITER $$
CREATE FUNCTION f_gerar_status_string(p_gss_atstatus tinyint) RETURNS varchar(10)
BEGIN
    DECLARE v_gss_status_string varchar(10) default '';
    
    if(p_gss_atstatus=1) then
		set v_gss_status_string = 'ABERTO';
    else
		if (p_gss_atstatus=0) then
			set v_gss_status_string = 'FECHADO';
		end if;
    end if;
    
    RETURN v_gss_status_string;
END$$
DELIMITER ;

-- select f_gerar_status_string(1);

-- Função para buscar codigo do usuário pelo username
DELIMITER $$
CREATE FUNCTION f_buscar_codigo_usuario(p_bcu_ususername varchar(20)) RETURNS int(11)
BEGIN
    DECLARE v_bcu_codigo_usuario int default 0;
    
    set v_bcu_codigo_usuario= (select uscodigo
		from usuario
        where ususername=p_bcu_ususername and usstatus=1);
    
    RETURN v_bcu_codigo_usuario;
END$$
DELIMITER ;

-- select f_buscar_codigo_usuario('user');

-- Função para validar o usuário pelo código
DELIMITER $$
CREATE FUNCTION f_validar_codigo_usuario(p_vcu_uscodigo int) RETURNS boolean
BEGIN
    DECLARE v_vcu_status_usuario boolean default false;
    
    set v_vcu_status_usuario = (select count(*)
		from usuario
        where uscodigo=p_vcu_uscodigo and usstatus=1);
    
    RETURN v_vcu_status_usuario;
END$$
DELIMITER ;

-- select f_validar_codigo_usuario(0);

-- função para contar projetos por usuário
DELIMITER $$
CREATE FUNCTION f_contar_projeto_usuario(p_cpu_uscodigo int) RETURNS tinyint
BEGIN
    DECLARE v_cpu_qt_projeto tinyint default 0;
    set v_cpu_qt_projeto=(select count(*)
							from projetosocial
							where projuscod=p_cpu_uscodigo and projstatus=1);
    
	return v_cpu_qt_projeto;
END$$
DELIMITER ;

-- select f_contar_projeto_usuario(1);

-- Função para pesquisar ID do projeto pelo código do usuário.
DELIMITER $$
CREATE FUNCTION f_buscar_projeto_codigo_usuario(p_bpcu_uscodigo int) RETURNS varchar(10)
BEGIN
    DECLARE v_bpcu_string_projeto varchar(10) default '';
    declare v_cont, v_qt_proj_usuario tinyint default 1;
    DECLARE v_done INT DEFAULT FALSE;
	DECLARE v_linha INT;
    DECLARE v_cursor CURSOR FOR 
		SELECT projid FROM (select projid
							from projetosocial
							where projuscod=p_bpcu_uscodigo) as v_consulta;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
    set v_qt_proj_usuario=f_contar_projeto_usuario(p_bpcu_uscodigo);
    if v_qt_proj_usuario>1 then
        while v_cont<=v_qt_proj_usuario do
			OPEN v_cursor;
			l_constuir_string: LOOP
				FETCH v_cursor INTO v_linha;
				IF v_done THEN
					LEAVE l_constuir_string;
				else
					if v_cont=v_qt_proj_usuario then
						set v_bpcu_string_projeto=concat(v_bpcu_string_projeto,'|',v_linha,'|');
						set v_bpcu_string_projeto=substring(v_bpcu_string_projeto,2);
					else
						set v_bpcu_string_projeto=concat(v_bpcu_string_projeto,'|',v_linha);
					end if;
                    SET v_cont = v_cont + 1;
				END IF;
			END LOOP;
			CLOSE v_cursor;
        end while;
	else 
		if v_qt_proj_usuario=1 then
			set v_bpcu_string_projeto = concat(convert((select projid
									from projetosocial
									where projuscod=p_bpcu_uscodigo), char),'|');
		else
			if v_qt_proj_usuario<1 then
                set v_bpcu_string_projeto='0';
			end if;
        end if;
	end if;
    RETURN v_bpcu_string_projeto;
END$$
DELIMITER ;

-- select f_buscar_projeto_codigo_usuario(1);

-- função para buscar id do projeto pelo título
DELIMITER $$
CREATE FUNCTION f_buscar_id_projeto(p_bip_projtitulo varchar(100)) RETURNS int(11)
BEGIN
    DECLARE v_bip_id_projeto int default 0;
    
    set v_bip_id_projeto= (select projid
		from projetosocial
        where projtitulo=p_bip_projtitulo and projstatus=1);
    
    RETURN v_bip_id_projeto;
END$$
DELIMITER ;

-- select f_buscar_id_projeto('Construindo Comunidades');

-- Função para validar projeto pelo ID.
DELIMITER $$
CREATE FUNCTION f_validar_id_projeto(p_vip_projid int) RETURNS boolean
BEGIN
    DECLARE v_vip_status_projeto boolean default false;
    
    set v_vip_status_projeto = (select count(*)
		from projetosocial
        where projid=p_vip_projid);
    
    RETURN v_vip_status_projeto;
END$$
DELIMITER ;

-- Função para validar datas - stand by;

-- Função para validar atividade pelo ID.
DELIMITER $$
CREATE FUNCTION f_validar_atividade_id(p_vai_atid int) RETURNS boolean
BEGIN
    DECLARE v_vai_status_atividade boolean default false;
    
    set v_vai_status_atividade = (select count(*)
		from atividade
        where atid=p_vai_atid);
    
    RETURN v_vai_status_atividade;
END$$
DELIMITER ;

-- Função para validar data de entrega da atividade - stand by.

-- função para contar atividades por projeto
DELIMITER $$
CREATE FUNCTION f_contar_ativ_projeto(p_cap_projid int) RETURNS tinyint
BEGIN
    DECLARE v_cap_qt_ativ tinyint default 0;
    set v_cap_qt_ativ=(select count(*)
							from atividade
							where atprojid=p_cap_projid);
    
	return v_cap_qt_ativ;
END$$
DELIMITER ;

-- select f_contar_ativ_projeto(1);

-- Função para encontrar IDs de atividades de um projeto.
DELIMITER $$
CREATE FUNCTION f_buscar_atividade_projeto_id(p_baip_projid int) RETURNS varchar(100)
BEGIN
    DECLARE v_baip_string_atividade varchar(100) default '';
    declare v_cont, v_qt_ativ_projeto tinyint default 1;
    DECLARE v_done INT DEFAULT FALSE;
	DECLARE v_linha INT;
    DECLARE v_cursor CURSOR FOR 
		SELECT atid FROM (select atid
							from atividade
							where atprojid=p_baip_projid) as v_consulta;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
    set v_qt_ativ_projeto=f_contar_ativ_projeto(p_baip_projid);
    if v_qt_ativ_projeto>1 then
        while v_cont<=v_qt_ativ_projeto do
			OPEN v_cursor;
			l_constuir_string: LOOP
				FETCH v_cursor INTO v_linha;
				IF v_done THEN
					LEAVE l_constuir_string;
				else
					if v_cont=v_qt_ativ_projeto then
						set  v_baip_string_atividade=concat(v_baip_string_atividade,'|',v_linha,'|');
                        set v_baip_string_atividade=substring(v_baip_string_atividade,2);
					else
						set v_baip_string_atividade=concat(v_baip_string_atividade,'|',v_linha);
					end if;
                    SET v_cont = v_cont + 1;
				END IF;
			END LOOP;
			CLOSE v_cursor;
        end while;
	else 
		if v_qt_ativ_projeto=1 then
			set v_baip_string_atividade = concat(convert((select atid
													from atividade
													where atprojid=p_baip_projid), char),'|');
		else
			if v_qt_ativ_projeto<1 then
                set v_baip_string_atividade='0';
			end if;
        end if;
	end if;
    RETURN v_baip_string_atividade;
END$$
DELIMITER ;

-- select f_buscar_atividade_projeto_id(1);

-- select atprojid, count(*) from atividade group by atprojid;

-- função para encontrar id da atividade por id de projeto e título
DELIMITER $$
CREATE FUNCTION f_buscar_ativ_atid_attitulo_projeto(p_capt_projid int, p_capt_attitulo varchar(100)) RETURNS int
BEGIN
    DECLARE v_capt_qt_ativ tinyint default 0;
    declare v_cont int default 1;
    declare v_string_id_ativ varchar(100) default '';
    declare v_id_ativ_resultado, v_id_ativ_posicao int default 0;
    set v_string_id_ativ = f_buscar_atividade_projeto_id(p_capt_projid);
    set v_capt_qt_ativ = f_contar_ativ_projeto(p_capt_projid);
    while v_cont<=v_capt_qt_ativ do
		set v_id_ativ_posicao = cast(f_extrair_parametros(v_string_id_ativ,v_cont) as unsigned int);
        if (select attitulo from atividade where atid=v_id_ativ_posicao)=p_capt_attitulo then
			set v_id_ativ_resultado = v_id_ativ_posicao;
        end if;
        set v_cont=v_cont+1;
    end while;
    return v_id_ativ_resultado;
END$$
DELIMITER ;

-- select f_buscar_ativ_atid_attitulo_projeto(1,'Campeonato de Futebol');

-- select * from atividade where atprojid=1;



-- Função para buscar username por código de usuário
DELIMITER $$
CREATE FUNCTION f_buscar_username(p_bu_uscodigo int) RETURNS varchar(20)
BEGIN
	declare v_bu_ususername varchar(20);
    if (f_validar_codigo_usuario(p_bu_uscodigo)) is not true then
		set v_bu_ususername = 'ERRO: O usuário indicado não existe';
    else
		set v_bu_ususername = (select ususername from usuario where uscodigo=p_bu_uscodigo and usstatus=1);
    end if;
    return v_bu_ususername;
END$$
DELIMITER ;

-- select f_buscar_username(1);

-- Função para buscar Título de projeto pelo ID do Projeto
DELIMITER $$
CREATE FUNCTION f_buscar_titulo_projeto(p_btp_projid int) RETURNS varchar(100)
BEGIN
	declare v_btp_titulo varchar(100);
    if (f_validar_id_projeto(p_btp_projid)) is not true then
		set v_btp_titulo = 'ERRO: O Projeto indicado não existe';
    else
		set v_btp_titulo = (select projtitulo from projetosocial where projid=p_btp_projid and projstatus=1);
    end if;
    return v_btp_titulo;
END$$
DELIMITER ;
-- select f_buscar_titulo_projeto(1);

-- Função para validar voluntario pelo código de usuário.
DELIMITER $$
CREATE FUNCTION f_validar_voluntario_uscodigo(p_vvu_voluscod int) RETURNS boolean
BEGIN
    DECLARE v_vvu_status_voluntario boolean default false;
    
    set v_vvu_status_voluntario = (select count(*)
		from voluntario
        where voluscod=p_vvu_voluscod and volstatus=1);
    
    RETURN v_vvu_status_voluntario;
END$$
DELIMITER ;

-- função para validar id de dia da semana
DELIMITER $$
CREATE FUNCTION f_validar_diasemana_id(p_vdi_dsid int) RETURNS boolean
BEGIN
    DECLARE v_vdn_status_diasemana boolean default false;
    
    set v_vdn_status_diasemana = (select count(*)
		from diasemana
        where dsid=p_vdi_dsid);
    
    RETURN v_vdn_status_diasemana;
END$$
DELIMITER ;

-- função para buscar id pela nomeclatura do dia da semana;
DELIMITER $$
CREATE FUNCTION f_buscar_diasemana_id(p_bdi_dsnomeclatura varchar(15)) RETURNS boolean
BEGIN
    DECLARE v_bdi_id_diasemana int default 0;
    
    set v_bdi_id_diasemana = (select dsid
		from diasemana
        where dsnomeclatura=p_bdi_dsnomeclatura);
    
    RETURN v_bdi_id_diasemana;
END$$
DELIMITER ;

-- função para buscar id pelo nome da da habilidade;
DELIMITER $$
CREATE FUNCTION f_buscar_habilidade_id(p_bhi_habnome varchar(20)) RETURNS boolean
BEGIN
    DECLARE v_bhi_id_habilidade int default 0;
    
    set v_bhi_id_habilidade = (select habid
		from habilidade
        where habnome=p_bhi_habnome);
    
    RETURN v_bhi_id_habilidade;
END$$
DELIMITER ;

-- função para validar id de habilidade
DELIMITER $$
CREATE FUNCTION f_validar_habilidade_id(p_vhi_habid int) RETURNS boolean
BEGIN
    DECLARE v_vdn_status_habilidade boolean default false;
    
    set v_vdn_status_habilidade = (select count(*)
		from habilidade
        where habid=p_vhi_habid);
    
    RETURN v_vdn_status_habilidade;
END$$
DELIMITER ;

-- função para buscar codigo pelo nome da da cidade;
DELIMITER $$
CREATE FUNCTION f_buscar_cidade_codigo(p_bcc_cidnome varchar(40)) RETURNS boolean
BEGIN
    DECLARE v_bcc_codigo_cidade int default 0;
    
    set v_bcc_codigo_cidade = (select cidcodigo
		from cidade
        where cidnome=p_bcc_cidnome);
    
    RETURN v_bcc_codigo_cidade;
END$$
DELIMITER ;

-- função para buscar codigo pelo nome do estado;
DELIMITER $$
CREATE FUNCTION f_buscar_estado_codigo(p_bce_estnome varchar(30)) RETURNS int
BEGIN
    DECLARE v_bce_codigo_estado int default 0;
    
    set v_bce_codigo_estado = (select estcodigo
		from estado
        where estnome=p_bce_estnome);
    
    RETURN v_bce_codigo_estado;
END$$
DELIMITER ;
-- drop FUNCTION f_buscar_estado_codigo;

-- função para validar codigo de cidade
DELIMITER $$
CREATE FUNCTION f_validar_cidade_codigo(p_vcc_cidcodigo int) RETURNS boolean
BEGIN
    DECLARE v_vcc_status_cidade boolean default false;
    
    set v_vcc_status_cidade = (select count(*)
		from cidade
        where cidcodigo=p_vcc_cidcodigo);
    
    RETURN v_vcc_status_cidade;
END$$
DELIMITER ;



-- Função para consultar quantos projetos um usuário cadastrou pelo username:
DELIMITER $$
CREATE FUNCTION f_verificar_projetos_usuario(p_cpu_uscodigo int) RETURNS boolean
BEGIN
    DECLARE v_cpu_status_projetos_usuario boolean default false;
    
    set v_cpu_status_projetos_usuario = (select count(*)
		from projetosocial
        where projuscod=p_cpu_uscodigo and projstatus=1);
    
    RETURN v_cpu_status_projetos_usuario;
END$$
DELIMITER ;

-- Função para validar e-mail de um usuario
DELIMITER $$
CREATE FUNCTION f_validar_email_usuario(p_veu_usemail varchar(80)) RETURNS int(11)
BEGIN
    DECLARE v_veu_email_usuario boolean default false;
    
    set v_veu_email_usuario = (select count(*)
		from usuario
        where usemail=p_veu_usemail and usstatus=1);
    
    RETURN v_veu_email_usuario;
END$$
DELIMITER ;


-- Função para validar o username de um usuario
DELIMITER $$
CREATE FUNCTION f_validar_username_usuario(p_vuu_ususername varchar(20)) RETURNS int(11)
BEGIN
    DECLARE v_vuu_ususername_usuario int default 0;
    
    set v_vuu_ususername_usuario= (select count(*)
		from usuario
        where ususername=p_vuu_ususername and usstatus=1);
    
    RETURN v_vuu_ususername_usuario;
END$$
DELIMITER ;

-- Função para buscar cpf de voluntário pelo username de usuário
DELIMITER $$
CREATE FUNCTION f_buscar_cpf_voluntario(p_bcv_ususername varchar(20)) RETURNS char(11)
BEGIN
    DECLARE v_bcv_volcpf char(11);
    declare v_bcv_uscodigo int default 0;
    
    set v_bcv_uscodigo = f_buscar_codigo_usuario(p_bcv_ususername);
    
    set v_bcv_volcpf = (select volcpf
		from voluntario
        where voluscod=v_bcv_uscodigo and volstatus=1);
    
    RETURN v_bcv_volcpf;
END$$
DELIMITER ;
-- select f_buscar_cpf_voluntario('ashleywhite');
-- select * from voluntario;
-- select * from usuario;

-- Função para validar CPF de um voluntário
DELIMITER $$
CREATE FUNCTION f_validar_cpf_voluntario(p_vcv_volcpf char(11)) RETURNS boolean
BEGIN
    DECLARE v_vcv_volcpf_status boolean default false;
    
    set v_vcv_volcpf_status = (select count(*)
		from voluntario
        where volcpf=p_vcv_volcpf and volstatus=1);
    
    RETURN v_vcv_volcpf_status;
END$$
DELIMITER ;
-- select f_validar_cpf_voluntario('12345678910');

-- Função para cadastrar habilidades para um voluntario


-- Função para verificar cadastro de voluntario em projeto
DELIMITER $$
CREATE FUNCTION f_validar_voluntario_projeto(p_vvp_volcpf char(11), p_vvp_projid int) RETURNS boolean
BEGIN
    DECLARE v_vvp_volproj_status boolean default false;
    
    set v_vvp_volproj_status = (select count(*)
		from voluntarioprojeto
        where volprojcpf=p_vvp_volcpf and volprojid=p_vvp_projid );
    
    RETURN v_vvp_volproj_status;
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION f_voluntarios_projeto(p_vp_projid int) RETURNS boolean
BEGIN
    DECLARE v_vp_volproj_status boolean default false;
    
    set v_vp_volproj_status = (select count(*)
		from voluntarioprojeto
        where volprojid=p_vp_projid);
    
    RETURN v_vp_volproj_status;
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION f_projetos_voluntario(p_pv_volcpf char(11)) RETURNS boolean
BEGIN
    DECLARE v_pv_volproj_status boolean default false;
    
    set v_pv_volproj_status = (select count(*)
		from voluntarioprojeto
        where volprojcpf=p_pv_volcpf);
    
    RETURN v_pv_volproj_status;
END$$
DELIMITER ;


-- Função para  verificar se um projeto está ligado a um voluntário
DELIMITER $$
CREATE FUNCTION f_verificar_voluntario_projeto(p_vvp_projid int, p_vvp_volcpf char(11)) RETURNS boolean
BEGIN
    DECLARE v_vvp_volproj_status boolean default false;
    
    set v_vvp_volproj_status = (select count(*)
		from voluntarioprojeto
        where volprojid=p_vvp_projid and volprojcpf=p_vvp_volcpf);
    
    RETURN v_vvp_volproj_status;
END$$
DELIMITER ;

-- Função para verificar se um usuário possui as habilidades requisitadas
DELIMITER $$
CREATE FUNCTION f_verificar_habilidades_username(p_vhsu_ususername varchar(20), p_vhsu_parametros varchar(1000), p_vhsu_qt_habilidades int) RETURNS int
BEGIN
    declare v_vhsu_cont int default 0;
    declare v_vhsu_cont_habilidades int default 7;
    declare v_vhsu_conteudo_parametro_id int default 0;
    declare v_vhsu_resultado int default 0;
    while v_vhsu_cont<=p_vhsu_qt_habilidades do
		set v_vhsu_conteudo_parametro_id = f_buscar_habilidade_id(f_extrair_parametros(p_vhsu_parametros,v_vhsu_cont_habilidades));
        -- erro crasso aqui
		if f_verificar_habilidade_username(p_vhsu_ususername,v_vhsu_conteudo_parametro_id) then
			set v_vhsu_resultado=v_vhsu_resultado+1;
        end if;
        set v_vhsu_cont_habilidades=v_vhsu_cont_habilidades+1;
        set v_vhsu_cont=v_vhsu_cont+1;
	end while;
    return v_vhsu_resultado;
END$$
DELIMITER ;

-- Função para definir habilidadesde um voluntario
DELIMITER $$
CREATE FUNCTION f_definir_habilidades_voluntario(p_dhv_volcpf char(11), p_dhv_qt_habilidades int, p_dhv_parametros varchar(1000)) RETURNS boolean
BEGIN
    declare v_dhv_cont int default 0;
    declare v_dhv_cont_habilidades int default 3;
    declare v_dhv_conteudo_parametro_id int default 0;
    declare v_dhv_cont_resultado int default 0;
    declare v_dhv_resultado boolean default false;
    declare v_dhv_habilidade varchar(20) default '';
    while v_dhv_cont<=p_dhv_qt_habilidades do
		set v_dhv_habilidade=f_extrair_parametros(p_dhv_parametros,v_dhv_cont_habilidades);
        if f_buscar_habilidade_id(v_dhv_habilidade) is null then
			set v_dhv_resultado = false;
		else
			set v_dhv_conteudo_parametro_id = f_buscar_habilidade_id(v_dhv_habilidade);
			if f_verificar_habilidade_voluntario(p_dhv_volcpf,v_dhv_conteudo_parametro_id) is true then
				set v_dhv_resultado = false;
            else
				insert into voluntariohabilidade(volhabid,volhabcpf) values(v_dhv_conteudo_parametro_id,p_dhv_volcpf);
                if f_verificar_habilidade_voluntario(p_dhv_volcpf,v_dhv_conteudo_parametro_id) is not true then
					set v_dhv_resultado = false;
				else
					set v_dhv_cont_resultado=v_dhv_cont_resultado+1;
				end if;
			end if;
        end if;
        set v_dhv_cont_habilidades=v_dhv_cont_habilidades+1;
        set v_dhv_cont=v_dhv_cont+1;
	end while;
    if v_dhv_cont_resultado=p_dhv_qt_habilidades then
		set v_dhv_resultado=true;
    else
		set v_dhv_resultado=false;
    end if;
    return v_dhv_resultado;
END$$
DELIMITER ;

/*
drop FUNCTION f_definir_habilidades_voluntario;
select f_definir_habilidades_voluntario('11122233344',2,'bobsmith|2|Costura|Marcenaria|');

select * from voluntario;
select * from voluntariohabilidade;
select * from voluntariohabilidade where volhabcpf='11122233344';
select * from habilidade;
*/

-- função para verificar se há uma habilidade cadastrada de um voluntário
DELIMITER $$
CREATE FUNCTION f_verificar_habilidade_voluntario(p_vhv_volcpf char(11), p_vhv_habid int) RETURNS boolean
BEGIN
    DECLARE vhv_volhab_status boolean default false;
    
    set vhv_volhab_status = (select count(*)
		from voluntariohabilidade
        where volhabid=p_vhv_habid and volhabcpf=p_vhv_volcpf);
    
    RETURN vhv_volhab_status;
END$$
DELIMITER ;

-- função para verificar usuário e senha
DELIMITER $$
CREATE FUNCTION f_validar_senha_usuario(p_vsu_ususenha varchar(15), p_vsu_uscodigo int) RETURNS boolean 
BEGIN
    DECLARE v_vsu_ususenha_status boolean default false;
    
    set v_vsu_ususenha_status = (select count(*)
		from usuario
        where uscodigo=p_vsu_uscodigo and ususenha=p_vsu_ususenha and usstatus=1);
    
    RETURN v_vsu_ususenha_status;
END$$
DELIMITER ;

-- função para buscar username por email
DELIMITER $$
CREATE FUNCTION f_buscar_username_email(p_bue_usemail varchar(80)) RETURNS varchar(20) 
BEGIN
    DECLARE v_bue_ususername varchar(20);
    
    set v_bue_ususername = (select ususername
		from usuario
        where usemail=p_bue_usemail and usstatus=1);
    
    RETURN v_bue_ususername;
END$$

DELIMITER ;