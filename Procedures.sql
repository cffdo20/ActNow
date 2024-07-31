use actnow24;
set global log_bin_trust_function_creators=1;

-- STORED PROCEDURES -----------------------------

-- Stored procedure para criar um projeto
DELIMITER $$
CREATE Procedure sp_criar_projeto(in p_crpj_parametros VARCHAR(1000))
BEGIN
	DECLARE v_crpj_projtitulo VARCHAR(100);
	DECLARE v_crpj_projdescricao VARCHAR(500);
	DECLARE v_crpj_projpublicoalvo VARCHAR(100);
	DECLARE v_crpj_projjustificativa VARCHAR(100);
	DECLARE v_crpj_projobjetivos VARCHAR(100);
	DECLARE v_crpj_projdatainicio VARCHAR(10);
    DECLARE v_crpj_projdatafinal VARCHAR(10);
	DECLARE v_crpj_projstatusvarchar VARCHAR(1);
    DECLARE v_crpj_projstatustinyint tinyint;
	DECLARE v_crpj_projuscod int default 0;
    declare v_crpj_ususername varchar (20);
    
	SET v_crpj_projtitulo = f_extrair_parametros(p_crpj_parametros, 1);
	SET v_crpj_projdescricao = f_extrair_parametros(p_crpj_parametros, 2);
	SET v_crpj_projpublicoalvo = f_extrair_parametros(p_crpj_parametros, 3);
	SET v_crpj_projjustificativa = f_extrair_parametros(p_crpj_parametros, 4);
	SET v_crpj_projobjetivos = f_extrair_parametros(p_crpj_parametros, 5);
	SET v_crpj_projdatainicio = cast(f_extrair_parametros(p_crpj_parametros, 6) as date);
    set v_crpj_projstatusvarchar = f_extrair_parametros(p_crpj_parametros, 7);
	SET v_crpj_ususername = f_extrair_parametros(p_crpj_parametros, 8);
    set v_crpj_projuscod = f_buscar_codigo_usuario(v_crpj_ususername);
    if (f_buscar_parametros_nulos(p_crpj_parametros,8) or f_buscar_caracteres_prejudiciais(p_crpj_parametros,8)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if not f_validar_string_status(v_crpj_projstatusvarchar) then
			select 'ERRO: O status informado para o projeto é inválido.' as erro;
		else
			set v_crpj_projstatustinyint = f_transformar_string_status(v_crpj_projstatusvarchar);
			if not f_validar_codigo_usuario(v_crpj_projuscod) then
				select 'ERRO: Este usuário não existe.' as erro;
			else
				if (select count(*) from projetosocial where projtitulo=v_crpj_projtitulo)>=1 then
					select 'ERRO: Já existe um projeto com esse Título.' as erro;
				else
					insert into projetosocial(projtitulo,projdescricao,projpublicoalvo,projjustificativa,projobjetivos,projdatainicio,projdatafinal,projstatus,projuscod) 
					values(v_crpj_projtitulo,v_crpj_projdescricao,v_crpj_projpublicoalvo,v_crpj_projjustificativa,v_crpj_projobjetivos,v_crpj_projdatainicio,NULL,v_crpj_projstatustinyint,v_crpj_projuscod);
					if (select count(*) from projetosocial where projtitulo=v_crpj_projtitulo and projuscod=v_crpj_projuscod)<1 then
						select 'ERRO: O projeto não foi criado no banco de dados.' as erro;
					else
						select 'Projeto criado com sucesso.' as resposta;
					end if;
				end if;
			end if;
		end if;
    end if;
END$$
DELIMITER ;

-- Stored procedure para definir uma atividade
DELIMITER $$
CREATE Procedure sp_definir_Atividade(in p_dfat_parametros VARCHAR(1000))
BEGIN

	DECLARE v_dfat_attitulo VARCHAR(100);
	DECLARE v_dfat_atdescricao VARCHAR(200);
	DECLARE v_dfat_atdataentrega date;
	DECLARE v_dfat_atstatus VARCHAR(1);
    DECLARE v_dfat_atprojtitulo varchar(500);
    DECLARE v_dfat_atprojid int unsigned;
    DECLARE v_dfat_atstatustinyint tinyint(1) unsigned;
    
	SET v_dfat_attitulo = f_extrair_parametros(p_dfat_parametros, 1);
	SET v_dfat_atdescricao = f_extrair_parametros(p_dfat_parametros, 2);
	SET v_dfat_atdataentrega = cast(f_extrair_parametros(p_dfat_parametros, 3) as date);
	SET v_dfat_atstatus = f_extrair_parametros(p_dfat_parametros, 4);
	SET v_dfat_atprojtitulo = f_extrair_parametros(p_dfat_parametros, 5);
    set v_dfat_atprojid= f_buscar_id_projeto(v_dfat_atprojtitulo);
    if (f_buscar_parametros_nulos(p_dfat_parametros,5) or f_buscar_caracteres_prejudiciais(p_dfat_parametros,5)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if not f_validar_string_status(v_dfat_atstatus) then
			select 'ERRO: O status informado para a atividade é inválido.' as erro;
		else 
			set v_dfat_atstatustinyint = f_transformar_string_status(v_dfat_atstatus);
			if not f_validar_id_projeto(v_dfat_atprojid) then
				select 'ERRO: O projeto indicado não existe.' as erro;
			else
				if f_buscar_ativ_atid_attitulo_projeto(v_dfat_atprojid,v_dfat_attitulo) > 0 then
					select 'ERRO: Uma atividade com esse título já foi criada nesse projeto.' as erro;
                else
					insert into atividade(attitulo,atdescricao,atdataentrega,atstatus,atprojid) 
					values(v_dfat_attitulo,v_dfat_atdescricao,v_dfat_atdataentrega,v_dfat_atstatustinyint,v_dfat_atprojid);            
					if (select count(*) from atividade where attitulo=v_dfat_attitulo and atprojid=v_dfat_atprojid)<1 then
						select 'ERRO: A Atividade não foi criada no banco de dados.' as erro;
					else
						select 'Atividade criada no banco de dados.' as resposta;
					end if;
				end if;
			end if;
		end if;
	end if;
END$$
DELIMITER ;


-- Stored procedure para alterar a data de uma atividade

DELIMITER $$
CREATE Procedure sp_alterar_data_atividade(in p_adta_parametros VARCHAR(1000))
BEGIN
	
    declare v_adta_attitulo varchar(100);
    declare v_adta_projtitulo varchar(100);
	DECLARE v_adta_atid int unsigned;
	DECLARE v_adta_atdataentrega date;
    
    SET v_adta_attitulo = f_extrair_parametros(p_adta_parametros, 1);
    SET v_adta_projtitulo = f_extrair_parametros(p_adta_parametros, 2);
	SET v_adta_atdataentrega = cast(f_extrair_parametros(p_adta_parametros, 3) as date);
    set v_adta_atid = f_buscar_ativ_atid_attitulo_projeto(f_buscar_id_projeto(v_adta_projtitulo),v_adta_attitulo);
    if (f_buscar_parametros_nulos(p_adta_parametros,3) or f_buscar_caracteres_prejudiciais(p_adta_parametros,3)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_atividade_id(v_adta_atid) is true then
			update atividade set atdataentrega=v_adta_atdataentrega where atid=v_adta_atid;
			if (select count(*) from atividade where atid=v_asta_atid and atdataentrega=v_adta_atdataentrega)<1 then
				select 'ERRO: Data de entrega da atividade não atualizada.' as erro;
			else
				SELECT 'Data de entrega da atividade alterada no banco de dados.' AS resposta;
			end if;
		else
			select 'ERRO: A atividade indicada não existe.' as erro;
		end if;
	end if;
END$$
DELIMITER ;

-- Stored procedure para alterar o status de uma atividade

DELIMITER $$
CREATE Procedure sp_alterar_status_atividade(in p_asta_parametros VARCHAR(1000))
BEGIN

	declare v_asta_attitulo varchar(100);
    declare v_asta_projtitulo varchar(100);
	DECLARE v_asta_atid int unsigned;
	DECLARE v_asta_atstatus VARCHAR(1);
    DECLARE v_asta_atstatustinyint tinyint(1) unsigned;
    
    SET v_asta_attitulo = f_extrair_parametros(p_asta_parametros, 1);
    SET v_asta_projtitulo = f_extrair_parametros(p_asta_parametros, 2);
	SET v_asta_atstatus = f_extrair_parametros(p_asta_parametros, 3);
    set v_asta_atid = f_buscar_ativ_atid_attitulo_projeto(f_buscar_id_projeto(v_asta_projtitulo),v_asta_attitulo);
    if (f_buscar_parametros_nulos(p_asta_parametros,3) or f_buscar_caracteres_prejudiciais(p_asta_parametros,3)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_atividade_id(v_asta_atid) is true then
			if !f_validar_string_status(v_asta_atstatus) then
				select 'ERRO: O status informado para a atividade é inválido.' as erro;
			else 
				set v_asta_atstatustinyint = f_transforma_string_status(v_asta_atstatus);
				update atividade set atstatus=v_asta_atstatustinyint where atid=v_asta_atid;
				if (select count(*) from atividade where atid=v_asta_atid and atstatus=v_asta_atstatustinyint)<1 then
					select 'ERRO: Status da atividade não atualizada.' as erro;
				else
					SELECT 'Status da atividade alterada no banco de dados.' AS resposta;
				end if;
			end if;
		else
			select 'ERRO: A atividade indicada não existe.' as erro;
		end if;
	end if;
END$$
DELIMITER ;

-- Stored procedure ara alterar a descrição de uma atividade

DELIMITER $$
CREATE Procedure sp_alterar_descricao_atividade(in p_adesa_parametros VARCHAR(1000))
BEGIN

	declare v_adesa_attitulo varchar(100);
    declare v_adesa_projtitulo varchar(100);
	DECLARE v_adesa_atid int unsigned;
	DECLARE v_adesa_atdescricao VARCHAR(200);
    
    SET v_adesa_attitulo = f_extrair_parametros(p_adesa_parametros, 1);
    SET v_adesa_projtitulo = f_extrair_parametros(p_adesa_parametros, 2);
	SET v_adesa_atdescricao = f_extrair_parametros(p_adesa_parametros, 3);
    set v_adesa_atid = f_buscar_ativ_atid_attitulo_projeto(f_buscar_id_projeto(v_adesa_projtitulo),v_adesa_attitulo);
    if (f_buscar_parametros_nulos(p_adesa_parametros,2) or f_buscar_caracteres_prejudiciais(p_adesa_parametros,2)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_atividade_id(v_adesa_atid) is true then
			update atividade set atdescricao=v_adesa_atdescricao where atid=v_adesa_atid;
			if (select count(*) from atividade where atid=v_adesa_atid and atdescricao=v_adesa_atdescricao)<1 then
				select 'ERRO: Descrição da atividade não atualizada.' as erro;
			else
				SELECT 'Descrição da atividade alterada no banco de dados.' AS resposta;
			end if;
		else
			select 'ERRO: A atividade indicada não existe.' as erro;
		end if;
    end if;
END$$
DELIMITER ;

-- Stored procedure pra calendário de atividades pelo Título do Projeto.
DELIMITER $$
CREATE Procedure sp_consultar_atividades_projeto(in p_cap_parametros VARCHAR(1000))
BEGIN
	DECLARE v_cap_projtitulo VARCHAR(500);
    declare v_cap_projid int default 0;
    SET v_cap_projtitulo = f_extrair_parametros(p_cap_parametros, 1);
    set v_cap_projid = f_buscar_id_projeto(v_cap_projtitulo);
    if (f_buscar_parametros_nulos(p_cap_parametros,1) or f_buscar_caracteres_prejudiciais(p_cap_parametros,1)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_id_projeto(v_cap_projid) is not true then
			select 'ERRO: O projeto indicado não existe.' as erro;
		else
			if f_contar_ativ_projeto(v_cap_projid)<1 then
				select 'ERRO: Não existem Atividades cadastradas para esse projeto.' as erro;
			else
				select attitulo 'titulo', atdescricao 'descricao', f_formata_data(atdataentrega) 'Entrega',f_gerar_status_string(atstatus) 'Status', f_buscar_titulo_projeto(atprojid) 'Projeto' from atividade where atprojid=v_cap_projid;
			end if;
		end if;
	end if;
END$$
DELIMITER ;

-- Stored procedure para consultar informações de projeto pelo título do projeto.
DELIMITER $$
CREATE Procedure sp_consultar_projeto(in p_cp_parametros VARCHAR(1000))
BEGIN
	DECLARE v_cp_projtitulo VARCHAR(500);
    declare v_cp_projid int default 0;
    declare v_cp_ususername varchar(20);
    SET v_cp_projtitulo = f_extrair_parametros(p_cp_parametros, 1);
    set v_cp_projid = f_buscar_id_projeto(v_cp_projtitulo);
    if (f_buscar_parametros_nulos(p_cp_parametros,1) or f_buscar_caracteres_prejudiciais(p_cp_parametros, 1)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_id_projeto(v_cp_projid) is not true then
			select 'ERRO: O projeto indicado não existe.' as erro;
		else
			if f_transformar_string_status((select projstatus from projetosocial where projid=v_cp_projid)) = 0 then
				-- select projtitulo 'titulo',projdescricao 'descricao',projpublicoalvo 'publico',projjustificativa 'justificativa',projobjetivos 'objetivos',f_formata_data(projdatainicio) 'inicio',f_formata_data(projdatafinal) 'final',f_gerar_status_string(f_transformar_string_status(projstatus)) 'status',f_buscar_username(projuscod) 'criador' from projetosocial where projid=v_cp_projid;
                select 'ERRO: O projeto indicado está inativo.' as erro;
			else
				if f_transformar_string_status((select projstatus from projetosocial where projid=v_cp_projid)) = 1 then
					select projtitulo 'titulo',projdescricao 'descricao',projpublicoalvo 'publico',projjustificativa 'justificativa',projobjetivos 'objetivos',f_formata_data(projdatainicio) 'inicio',f_gerar_status_string(f_transformar_string_status(projstatus)) 'status',f_buscar_username(projuscod) 'criador' from projetosocial where projid=v_cp_projid and projstatus=1;
				end if;
			end if;
		end if;
	end if;
END$$
DELIMITER ;
-- drop procedure sp_consultar_projeto;
-- call sp_consultar_projeto('Construindo Comunidades|');
-- select * from projetosocial;

-- Stored procedures para consultar informações de voluntário pelo username.
DELIMITER $$
CREATE Procedure sp_consultar_voluntario(in p_cv_parametros VARCHAR(1000))
BEGIN
	DECLARE v_cv_ususername VARCHAR(20);
    declare v_cv_uscodigo int default 0;
    SET v_cv_ususername = f_extrair_parametros(p_cv_parametros, 1);
    set v_cv_uscodigo = f_buscar_codigo_usuario(v_cv_ususername);
    if (f_buscar_parametros_nulos(p_cv_parametros,1) or f_buscar_caracteres_prejudiciais(p_cv_parametros,1)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_codigo_usuario(v_cv_uscodigo) is not true then
			select 'ERRO: O usuário indicado não existe.' as erro;
		else
			if f_validar_voluntario_uscodigo(v_cv_uscodigo) is not true then
				select 'ERRO: O voluntário indicado não existe.' as erro;
            else
				select volcpf as 'cpf',
						volnome as 'nome',
						volnomesocial as 'nome Social',
						volbio as 'biografia',
						voltelefone as 'telefone',
						(select cidnome from cidade where cidcodigo=volcidcod) as 'cidade'
				from voluntario
				where voluscod = v_cv_uscodigo and volstatus=1;
			end if;
		end if;
    end if;
END$$
DELIMITER ;


DELIMITER $$
CREATE Procedure sp_filtrar_voluntarios(in p_fv_parametros VARCHAR(1000))
BEGIN
	declare v_fv_manha, v_fv_tarde, v_fv_noite boolean default false;
    declare v_fv_id_diasemana, v_fv_id_habilidade int default 0;
    SET  v_fv_id_diasemana = f_buscar_diasemana_id(f_extrair_parametros(p_fv_parametros, 1));
    set v_fv_manha = f_extrair_parametros(p_fv_parametros, 2);
    set v_fv_tarde = f_extrair_parametros(p_fv_parametros, 3);
    set v_fv_noite = f_extrair_parametros(p_fv_parametros, 4);
    set v_fv_id_habilidade = f_buscar_habilidade_id(f_extrair_parametros(p_fv_parametros, 5));
    
    if (f_buscar_parametros_nulos(p_fv_parametros,5) or f_buscar_caracteres_prejudiciais(p_fv_parametros,5)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_diasemana_id(v_fv_id_diasemana) is not true then
			select 'ERRO: O dia da semana indicado não existe.' as erro;
		else
			if f_validar_habilidade_id(v_fv_id_habilidade) is not true then
				select 'ERRO: A habilidade indicada não existe.' as erro;
			else
				if v_fv_manha is true and v_fv_tarde is true and v_fv_noite is true then
					select ususername 'username'
					from usuario
					join voluntario on uscodigo=voluscod
					join voluntariohabilidade on volhabcpf=volcpf
					join habilidade on  volhabid = habid
					join voluntariodiasemana on voldscpf=volcpf
					join diasemana on voldsid=dsid
					join turnodia on voldsturid=turid
					where dsid=v_fv_id_diasemana and turid in (1,2,3) and habid=v_fv_id_habilidade;
				else
					if v_fv_manha is true and v_fv_tarde is true then
						select ususername 'username'
						from usuario
						join voluntario on uscodigo=voluscod
						join voluntariohabilidade on volhabcpf=volcpf
						join habilidade on  volhabid = habid
						join voluntariodiasemana on voldscpf=volcpf
						join diasemana on voldsid=dsid
						join turnodia on voldsturid=turid
						where dsid=v_fv_id_diasemana and turid in (1,2) and habid=v_fv_id_habilidade;
					else
						if v_fv_tarde is true and v_fv_noite is true then
							select ususername 'username'
							from usuario
							join voluntario on uscodigo=voluscod
							join voluntariohabilidade on volhabcpf=volcpf
							join habilidade on  volhabid = habid
							join voluntariodiasemana on voldscpf=volcpf
							join diasemana on voldsid=dsid
							join turnodia on voldsturid=turid
							where dsid=v_fv_id_diasemana and turid in (2,3) and habid=v_fv_id_habilidade;
						else
							if v_fv_noite is true and v_fv_manha is true then
								select ususername 'username'
								from usuario
								join voluntario on uscodigo=voluscod
								join voluntariohabilidade on volhabcpf=volcpf
								join habilidade on  volhabid = habid
								join voluntariodiasemana on voldscpf=volcpf
								join diasemana on voldsid=dsid
								join turnodia on voldsturid=turid
								where dsid=v_fv_id_diasemana and turid in (1,3) and habid=v_fv_id_habilidade;
							else
								if v_fv_manha is true then
									select ususername 'username'
									from usuario
									join voluntario on uscodigo=voluscod
									join voluntariohabilidade on volhabcpf=volcpf
									join habilidade on  volhabid = habid
									join voluntariodiasemana on voldscpf=volcpf
									join diasemana on voldsid=dsid
									join turnodia on voldsturid=turid
									where dsid=v_fv_id_diasemana and turid in (1) and habid=v_fv_id_habilidade;
								else
									if v_fv_tarde is true then
										select ususername 'username'
										from usuario
										join voluntario on uscodigo=voluscod
										join voluntariohabilidade on volhabcpf=volcpf
										join habilidade on  volhabid = habid
										join voluntariodiasemana on voldscpf=volcpf
										join diasemana on voldsid=dsid
										join turnodia on voldsturid=turid
										where dsid=v_fv_id_diasemana and turid in (2) and habid=v_fv_id_habilidade;
									else
										if v_fv_noite is true then
											select ususername 'username'
											from usuario
											join voluntario on uscodigo=voluscod
											join voluntariohabilidade on volhabcpf=volcpf
											join habilidade on  volhabid = habid
											join voluntariodiasemana on voldscpf=volcpf
											join diasemana on voldsid=dsid
											join turnodia on voldsturid=turid
											where dsid=v_fv_id_diasemana and turid in (3) and habid=v_fv_id_habilidade;
										else
												select ususername 'username'
												from usuario
												join voluntario on uscodigo=voluscod
												join voluntariohabilidade on volhabcpf=volcpf
												join habilidade on  volhabid = habid
												join voluntariodiasemana on voldscpf=volcpf
												join diasemana on voldsid=dsid
												join turnodia on voldsturid=turid
												where dsid=v_fv_id_diasemana and habid=v_fv_id_habilidade;
										end if;
									end if;
								end if;
							end if;
						end if;
					end if;
				end if;
			end if;
		end if;
    end if;
END$$
DELIMITER ;

-- Procedure para listar projetos geridos por um usuário.
DELIMITER $$
CREATE Procedure sp_consultar_projetos_usuario(in p_cpu_parametros VARCHAR(1000))
BEGIN
	DECLARE v_cpu_ususername VARCHAR(20);
    declare v_cpu_uscodigo int default 0;
    SET v_cpu_ususername = f_extrair_parametros(p_cpu_parametros, 1);
    set v_cpu_uscodigo = f_buscar_codigo_usuario(v_cpu_ususername);
    if (f_buscar_parametros_nulos(p_cpu_parametros,1) or f_buscar_caracteres_prejudiciais(p_cpu_parametros,1)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_codigo_usuario(v_cpu_uscodigo) is not true then
			select 'ERRO: O usuário indicado não existe.' as erro;
		else
			if f_verificar_projetos_usuario(v_cpu_uscodigo) is not true then
				select 'ERRO: O usuário indicado não possui projetos cadastrados.' as erro;
            else
				select projtitulo 'titulo'
				from projetosocial 
				where projuscod=v_cpu_uscodigo and projstatus=1;
			end if;
		end if;
    end if;
END$$
DELIMITER ;
call 
-- Procedure para alterar a descrição de um projeto
DELIMITER $$
CREATE Procedure sp_alterar_descricao_projeto(in p_adp_parametros VARCHAR(1000))
BEGIN
	DECLARE v_adp_projtitulo, v_adp_projdescricao VARCHAR(500);
    declare v_adp_projid int default 0;
    SET v_adp_projtitulo = f_extrair_parametros(p_adp_parametros, 1);
    SET v_adp_projdescricao = f_extrair_parametros(p_adp_parametros, 2);
    set v_adp_projid = f_buscar_id_projeto(v_adp_projtitulo);
    if (f_buscar_parametros_nulos(p_adp_parametros,2) or f_buscar_caracteres_prejudiciais(p_adp_parametros,2)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_id_projeto(v_adp_projid) is not true then
			select 'ERRO: O projeto indicado não existe.' as erro;
		else
			if f_transformar_string_status((select projstatus from projetosocial where projid=v_adp_projid)) = 0 then
                select 'ERRO: O projeto indicado está inativo.' as erro;
			else
				if f_transformar_string_status((select projstatus from projetosocial where projid=v_adp_projid)) = 1 then
					update projetosocial set projdescricao=v_adp_projdescricao where projid=v_adp_projid;
                    select 'Descrição do projeto alterada com sucesso!' as resposta;
				end if;
			end if;
		end if;
	end if;
END$$
DELIMITER ;

-- call sp_alterar_descricao_projeto('Construindo Comunidades|teste2|');
-- select * from projetosocial;
-- Procedure para alterar o público alvo de um projeto.
DELIMITER $$
CREATE Procedure sp_alterar_publico_projeto(in p_app_parametros VARCHAR(1000))
BEGIN
	DECLARE v_app_projtitulo, v_app_projpublicoalvo VARCHAR(500);
    declare v_app_projid int default 0;
    SET v_app_projtitulo = f_extrair_parametros(p_app_parametros, 1);
    SET v_app_projpublicoalvo = f_extrair_parametros(p_app_parametros, 2);
    set v_app_projid = f_buscar_id_projeto(v_app_projtitulo);
    if (f_buscar_parametros_nulos(p_app_parametros,2) or f_buscar_caracteres_prejudiciais(p_app_parametros,2)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_id_projeto(v_app_projid) is not true then
			select 'ERRO: O projeto indicado não existe.' as erro;
		else
			if f_transformar_string_status((select projstatus from projetosocial where projid=v_app_projid)) = 0 then
                select 'ERRO: O projeto indicado está inativo.' as erro;
			else
				if f_transformar_string_status((select projstatus from projetosocial where projid=v_app_projid)) = 1 then
					update projetosocial set projpublicoalvo=v_app_projpublicoalvo where projid=v_app_projid;
                    select 'Público-alvo do projeto alterado com sucesso!' as resposta;
				end if;
			end if;
		end if;
	end if;
END$$
DELIMITER ;
-- call sp_alterar_publico_projeto('Construindo Comunidades|teste2|');
-- select * from projetosocial;

-- Procedure para alterar a justificativa de um projeto.
DELIMITER $$
CREATE Procedure sp_alterar_justificativa_projeto(in p_ajp_parametros VARCHAR(1000))
BEGIN
	DECLARE v_ajp_projtitulo, v_ajp_projjustificativa VARCHAR(500);
    declare v_ajp_projid int default 0;
    SET v_ajp_projtitulo = f_extrair_parametros(p_ajp_parametros, 1);
    SET v_ajp_projjustificativa = f_extrair_parametros(p_ajp_parametros, 2);
    set v_ajp_projid = f_buscar_id_projeto(v_ajp_projtitulo);
    if (f_buscar_parametros_nulos(p_ajp_parametros,2) or f_buscar_caracteres_prejudiciais(p_ajp_parametros,2)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_id_projeto(v_ajp_projid) is not true then
			select 'ERRO: O projeto indicado não existe.' as erro;
		else
			if f_transformar_string_status((select projstatus from projetosocial where projid=v_ajp_projid)) = 0 then
                select 'ERRO: O projeto indicado está inativo.' as erro;
			else
				if f_transformar_string_status((select projstatus from projetosocial where projid=v_ajp_projid)) = 1 then
					update projetosocial set projjustificativa=v_ajp_projjustificativa where projid=v_ajp_projid;
                    select 'Justificativa do projeto alterada com sucesso!' as resposta;
				end if;
			end if;
		end if;
	end if;
END$$
DELIMITER ;
-- call sp_alterar_justificativa_projeto('Construindo Comunidades|teste2|');
-- select * from projetosocial;

-- Procedure para alterar os objetivos de um projeto
DELIMITER $$
CREATE Procedure sp_alterar_objetivos_projeto(in p_aop_parametros VARCHAR(1000))
BEGIN
	DECLARE v_aop_projtitulo, v_aop_projobjetivos VARCHAR(500);
    declare v_aop_projid int default 0;
    SET v_aop_projtitulo = f_extrair_parametros(p_aop_parametros, 1);
    SET v_aop_projobjetivos = f_extrair_parametros(p_aop_parametros, 2);
    set v_aop_projid = f_buscar_id_projeto(v_aop_projtitulo);
    if (f_buscar_parametros_nulos(p_aop_parametros,2) or f_buscar_caracteres_prejudiciais(p_aop_parametros,2)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_id_projeto(v_aop_projid) is not true then
			select 'ERRO: O projeto indicado não existe.' as erro;
		else
			if f_transformar_string_status((select projstatus from projetosocial where projid=v_aop_projid)) = 0 then
                select 'ERRO: O projeto indicado está inativo.' as erro;
			else
				if f_transformar_string_status((select projstatus from projetosocial where projid=v_aop_projid)) = 1 then
					update projetosocial set projobjetivos=v_aop_projobjetivos where projid=v_aop_projid;
                    select 'Objetivos do projeto alterados com sucesso!' as resposta;
				end if;
			end if;
		end if;
	end if;
END$$
DELIMITER ;
-- call sp_alterar_objetivos_projeto('Construindo Comunidades|teste2|');
-- select * from projetosocial;
-- Procedure para inativar um projeto.
DELIMITER $$
CREATE Procedure sp_inativar_projeto(in p_ip_parametros VARCHAR(1000))
BEGIN
	DECLARE v_ip_projtitulo VARCHAR(500);
    declare v_ip_projid int default 0;
    SET v_ip_projtitulo = f_extrair_parametros(p_ip_parametros, 1);
    set v_ip_projid = f_buscar_id_projeto(v_ip_projtitulo);
    if (f_buscar_parametros_nulos(p_ip_parametros,1) or f_buscar_caracteres_prejudiciais(p_ip_parametros,1)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_id_projeto(v_ip_projid) is not true then
			select 'ERRO: O projeto indicado não existe.' as erro;
		else
			if f_transformar_string_status((select projstatus from projetosocial where projid=v_ip_projid)) = 0 then
                select 'ERRO: O projeto indicado está inativo.' as erro;
			else
				if f_transformar_string_status((select projstatus from projetosocial where projid=v_ip_projid)) = 1 then
					update projetosocial set projstatus=0, projdatafinal=current_date() where projid=v_ip_projid;
                    select 'Projeto inativado.' as resposta;
				end if;
			end if;
		end if;
	end if;
END$$
DELIMITER ;
-- call sp_inativar_projeto('Construindo Comunidades|');
-- select * from projetosocial;

-- Stored Procedure pra criar um usuário
DELIMITER $$
CREATE Procedure sp_criar_usuario(in p_crus_parametros VARCHAR(1000))
BEGIN
	DECLARE v_crus_ususername VARCHAR(20);
	DECLARE v_crus_ususenha VARCHAR(15);
	DECLARE v_crus_usemail VARCHAR(80);
    
	SET v_crus_ususername = f_extrair_parametros(p_crus_parametros, 1);
	SET v_crus_ususenha = f_extrair_parametros(p_crus_parametros, 2);
	SET v_crus_usemail = f_extrair_parametros(p_crus_parametros, 3);
    if (f_buscar_parametros_nulos(p_crus_parametros,3) or f_buscar_caracteres_prejudiciais(p_crus_parametros,3)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_username_usuario(v_crus_ususername)>0 then
			select 'ERRO: Um usuário com esse username já existe.' as erro;
		else
			if f_validar_email_usuario(v_crus_usemail) then
				select 'ERRO: Um usuário com esse e-mail já existe.' as erro;
			else
				insert into usuario(ususername,ususenha,usemail) 
				values(v_crus_ususername,v_crus_ususenha,v_crus_usemail);
				if (select count(*) from usuario where ususername=v_crus_ususername and usemail=v_crus_usemail and ususenha=v_crus_ususenha)<1 then
					select 'ERRO: O Usuário não foi criado no banco de dados.' as erro;
				else
					select 'Usuário criado com sucesso.' as resposta;
				end if;
			end if;
		end if;
    end if;
END$$
DELIMITER ;
-- drop procedure sp_criar_usuario;
-- call sp_criar_usuario('testes|teste|teste|');
-- select * from usuario;

-- Store procedure para buscar um usuário pelo username
DELIMITER $$
CREATE Procedure sp_consultar_usuario(in p_cnus_parametros VARCHAR(1000))
BEGIN
	DECLARE v_cnus_ususername VARCHAR(20);
    declare v_cnus_uscodigo int default 0;
    SET v_cnus_ususername = f_extrair_parametros(p_cnus_parametros, 1);
    set v_cnus_uscodigo = f_buscar_codigo_usuario(v_cnus_ususername);
    if (f_buscar_parametros_nulos(p_cnus_parametros,1) or f_buscar_caracteres_prejudiciais(p_cnus_parametros,1)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_codigo_usuario(v_cnus_uscodigo) is not true then
			select 'ERRO: O usuário indicado não existe.' as erro;
		else
			select ususername as 'username',
					usemail as 'e-mail',
                    ususenha as 'senha'
			from usuario
            where uscodigo=v_cnus_uscodigo;
		end if;
    end if;
END$$
DELIMITER ;
-- drop procedure sp_consultar_usuario;
-- call sp_consultar_usuario('testes|');

-- Store procedure para inativar um usuário pelo username
DELIMITER $$
CREATE Procedure sp_inativar_usuario(in p_iu_parametros VARCHAR(1000))
BEGIN
	DECLARE v_iu_username VARCHAR(20);
    declare v_iu_uscodigo int default 0;
    SET v_iu_username = f_extrair_parametros(p_iu_parametros, 1);
    set v_iu_uscodigo = f_buscar_codigo_usuario(v_iu_username);
    if (f_buscar_parametros_nulos(p_iu_parametros,1) or f_buscar_caracteres_prejudiciais(p_iu_parametros,1)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_codigo_usuario(v_iu_uscodigo) is not true then
			select 'ERRO: O usuário indicado não existe.' as erro;
		else
			if f_transformar_string_status((select usstatus from usuario where uscodigo=v_iu_uscodigo)) = 0 then
                select 'ERRO: O usuário indicado está inativo.' as erro;
			else
				if f_transformar_string_status((select usstatus from usuario where uscodigo=v_iu_uscodigo)) = 1 then
					update usuario set usstatus=0 where uscodigo=v_iu_uscodigo;
                    if f_validar_voluntario_uscodigo(v_iu_uscodigo) is not true then
						select 'Usuário inativado.' as resposta;
					else
						update voluntario set volstatus=0 where voluscod=v_iu_uscodigo;
                        select 'Usuário inativado.' as resposta;
                    end if;
				end if;
			end if;
		end if;
	end if;
END$$
DELIMITER ;
-- drop procedure sp_inativar_usuario;
-- call sp_inativar_usuario('bobsmith|');
-- select * from usuario;
-- select * from voluntario;

-- stored procedure para alterar a senha de um usuário.
DELIMITER $$
CREATE Procedure sp_alterar_senha_usuario(in p_asu_parametros VARCHAR(1000))
BEGIN
	DECLARE v_asu_ususername, v_asu_ususenha VARCHAR(500);
    declare v_asu_uscodigo int default 0;
    SET v_asu_ususername = f_extrair_parametros(p_asu_parametros, 1);
    SET v_asu_ususenha = f_extrair_parametros(p_asu_parametros, 2);
    set v_asu_uscodigo = f_buscar_codigo_usuario(v_asu_ususername);
    if (f_buscar_parametros_nulos(p_asu_parametros,2) or f_buscar_caracteres_prejudiciais(p_asu_parametros,2)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_codigo_usuario(v_asu_uscodigo) is not true then
			select 'ERRO: O usuario indicado não existe.' as erro;
		else
			if f_transformar_string_status((select usstatus from usuario where uscodigo=v_asu_uscodigo)) = 0 then
                select 'ERRO: O usuário indicado está inativo.' as erro;
			else
				if f_transformar_string_status((select usstatus from usuario where uscodigo=v_asu_uscodigo)) = 1 then
					update usuario set ususenha=v_asu_ususenha where uscodigo=v_asu_uscodigo;
                    select 'Senha do usuário alterada com sucesso!' as resposta;
				end if;
			end if;
		end if;
	end if;
END$$
DELIMITER ;
-- drop Procedure sp_alterar_senha_usuario;
-- select * from usuario;
-- call sp_alterar_senha_usuario('user123|teste|');

-- stored procedure para alterar o e-mail de um usuário
DELIMITER $$
CREATE Procedure sp_alterar_email_usuario(in p_aeu_parametros VARCHAR(1000))
BEGIN
	DECLARE v_aeu_ususername, v_aeu_usemail VARCHAR(500);
    declare v_aeu_uscodigo int default 0;
    SET v_aeu_ususername = f_extrair_parametros(p_aeu_parametros, 1);
    SET v_aeu_usemail = f_extrair_parametros(p_aeu_parametros, 2);
    set v_aeu_uscodigo = f_buscar_codigo_usuario(v_aeu_ususername);
    if (f_buscar_parametros_nulos(p_aeu_parametros,2) or f_buscar_caracteres_prejudiciais(p_aeu_parametros,2)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_codigo_usuario(v_aeu_uscodigo) is not true then
			select 'ERRO: O usuario indicado não existe.' as erro;
		else
			if f_validar_email_usuario(v_aeu_usemail) then
				select 'ERRO: Um usuário com esse e-mail já existe.' as erro;
            else
				if f_transformar_string_status((select usstatus from usuario where uscodigo=v_aeu_uscodigo)) = 0 then
					select 'ERRO: O usuário indicado está inativo.' as erro;
				else
					if f_transformar_string_status((select usstatus from usuario where uscodigo=v_aeu_uscodigo)) = 1 then
						update usuario set usemail=v_aeu_usemail where uscodigo=v_aeu_uscodigo;
						select 'E-mail do usuário alterado com sucesso!' as resposta;
					end if;
				end if;
			end if;
		end if;
	end if;
END$$
DELIMITER ;
-- drop Procedure sp_alterar_email_usuario;
-- select * from usuario;
-- call sp_alterar_email_usuario('user123|johndoe@email.com|');

-- stored procedure para criar voluntário
DELIMITER $$
CREATE Procedure sp_criar_voluntario(in p_crvol_parametros VARCHAR(1000))
BEGIN
	DECLARE v_crvol_volcpf CHAR(11);
    declare v_crvol_ususername varchar(20);
	DECLARE v_crvol_volnome VARCHAR(80);
	DECLARE v_crvol_volnomesocial VARCHAR(80);
	DECLARE v_crvol_volbio varchar(300);
    DECLARE v_crvol_voltelefone char(11);
    DECLARE v_crvol_volcidcod, v_crvol_voluscod int;
    declare v_crvol_volcidnome varchar(40);
    
	SET v_crvol_ususername = f_extrair_parametros(p_crvol_parametros, 1);
    SET v_crvol_volcpf = f_extrair_parametros(p_crvol_parametros, 2);
	SET v_crvol_volnome = f_extrair_parametros(p_crvol_parametros, 3);
	SET v_crvol_volnomesocial = f_extrair_parametros(p_crvol_parametros, 4);
    SET v_crvol_volbio = f_extrair_parametros(p_crvol_parametros, 5);
    SET v_crvol_voltelefone = f_extrair_parametros(p_crvol_parametros, 6);
    SET v_crvol_volcidnome = f_extrair_parametros(p_crvol_parametros, 7);
    set v_crvol_volcidcod = f_buscar_cidade_codigo(v_crvol_volcidnome);
    set v_crvol_voluscod = f_buscar_codigo_usuario(v_crvol_ususername);
    if (f_buscar_parametros_nulos(p_crvol_parametros,3) or f_buscar_caracteres_prejudiciais(p_crvol_parametros,3)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_codigo_usuario(v_crvol_voluscod) is not true then
			select 'ERRO: O usuário indicado não existe.';
        else
			if f_buscar_cpf_voluntario(v_crvol_ususername) is not null then
				select 'ERRO: Esse usuário já esta cadastrado como voluntário.' as erro;
			else
				if f_validar_cpf_voluntario(v_crvol_volcpf) is true then
					select 'ERRO: Um Voluntário com esse CPF já existe.' as erro;
				else
					if f_validar_cidade_codigo(v_crvol_volcidcod) is null then
						select 'ERRO: A Cidade indicada não existe' as erro;
					else
						insert into voluntario(volcpf, voluscod, volnome, volnomesocial, volbio, voltelefone, volcidcod)
						values(v_crvol_volcpf, v_crvol_voluscod, v_crvol_volnome, v_crvol_volnomesocial, v_crvol_volbio, v_crvol_voltelefone, v_crvol_volcidcod);
						if (select count(*) from voluntario where volcpf=v_crvol_volcpf and volstatus=1)<1 then
							select 'ERRO: O Usuário não foi criado no banco de dados.' as erro;
						else
							select 'Voluntário criado com sucesso.' as resposta;
						end if;
					end if;
				end if;
			end if;
		end if;
    end if;
END$$
DELIMITER ;
/* 
drop Procedure sp_criar_voluntario;
call sp_criar_voluntario('user123|12345767889|TESTER|BETATESTER|TESTANDO ISSO AQUI!|11111111111|MANAUS|');
select * from usuario;
select * from voluntario;
*/

-- stored procedure para buscar voluntario pelo cpf
DELIMITER $$
CREATE Procedure sp_consultar_voluntario_cpf(in p_cvc_parametros VARCHAR(1000))
BEGIN
	DECLARE v_cvc_ususername VARCHAR(20);
    declare v_cvc_volcpf int default 0;
    SET v_cvc_ususername = f_extrair_parametros(p_cvc_parametros, 1);
    set v_cvc_volcpf = f_buscar_cpf_voluntario(v_cvc_username);
    if (f_buscar_parametros_nulos(p_cvc_parametros,1) or f_buscar_caracteres_prejudiciais(p_cvc_parametros,1)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_cpf_voluntario(v_cvc_volcpf) is not true then
			select 'ERRO: O voluntário indicado não existe.' as erro;
		else
			if f_transformar_string_status((select volstatus from voluntario where volcpf=v_cvc_volcpf)) = 0 then
				select 'ERRO: O voluntario indicado está inativo.' as erro;
			else
				if f_transformar_string_status((select volstatus from voluntario where volcpf=v_cvc_volcpf)) = 1 then
					select volcpf as 'cpf',
							volnome as 'nome',
							volnomesocial as 'nome Social',
							volbio as 'biografia',
							voltelefone as 'telefone',
							(select cidnome from cidade where cidcodigo=volcidcod) as 'cidade'
					from voluntario
					where volcpf = v_cvc_volcpf and volstatus=1;
				end if;
			end if;
		end if;
    end if;
END$$
DELIMITER ;

-- stored procedure para inativar voluntário pelo username
DELIMITER $$
CREATE Procedure sp_inativar_voluntario(in p_iv_parametros VARCHAR(1000))
BEGIN
	DECLARE v_iv_username VARCHAR(20);
    declare v_iv_volcpf char(11);
    SET v_iv_username = f_extrair_parametros(p_iv_parametros, 1);
    set v_iv_volcpf = f_buscar_cpf_voluntario(v_iv_username);
    if (f_buscar_parametros_nulos(p_iv_parametros,1) or f_buscar_caracteres_prejudiciais(p_iv_parametros,1)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_cpf_voluntario(v_iv_volcpf) is not true then
			select 'ERRO: O voluntário indicado não existe.' as erro;
		else
			if f_transformar_string_status((select volstatus from voluntario where volcpf=v_iv_volcpf)) = 0 then
                select 'ERRO: O voluntario indicado está inativo.' as erro;
			else
				if f_transformar_string_status((select volstatus from voluntario where volcpf=v_iv_volcpf)) = 1 then
					update voluntario set volstatus=0 where volcpf=v_iv_volcpf;
				end if;
			end if;
		end if;
	end if;
END$$
DELIMITER ;

-- stored procedure para alterar nomesocial do voluntário
DELIMITER $$
CREATE Procedure sp_alterar_nomesocial_voluntario(in p_anv_parametros VARCHAR(1000))
BEGIN
	DECLARE v_anv_username VARCHAR(20);
    declare v_anv_volnomesocial varchar(100);
    declare v_anv_volcpf char(11);
    SET v_anv_username = f_extrair_parametros(p_anv_parametros, 1);
    SET v_anv_volnomesocial = f_extrair_parametros(p_anv_parametros, 2);
    set v_anv_volcpf = f_buscar_cpf_voluntario(v_anv_username);
    if (f_buscar_parametros_nulos(p_anv_parametros,2) or f_buscar_caracteres_prejudiciais(p_anv_parametros,2)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_cpf_voluntario(v_anv_volcpf) is not true then
			select 'ERRO: O voluntário indicado não existe.' as erro;
		else
			if f_transformar_string_status((select volstatus from voluntario where volcpf=v_anv_volcpf)) = 0 then
                select 'ERRO: O voluntario indicado está inativo.' as erro;
			else
				if f_transformar_string_status((select volstatus from voluntario where volcpf=v_anv_volcpf)) = 1 then
					update voluntario set volnomesocial=v_anv_volnomesocial where volcpf=v_anv_volcpf;
				end if;
			end if;
		end if;
	end if;
END$$
DELIMITER ;

-- stored procedure para mudar biografia do voluntario
DELIMITER $$
CREATE Procedure sp_alterar_bio_voluntario(in p_abv_parametros VARCHAR(1000))
BEGIN
	DECLARE v_abv_username VARCHAR(20);
    declare v_abv_volbio varchar(300);
    declare v_abv_volcpf char(11);
    SET v_abv_username = f_extrair_parametros(p_abv_parametros, 1);
    SET v_abv_volbio = f_extrair_parametros(p_abv_parametros, 2);
    set v_abv_volcpf = f_buscar_cpf_voluntario(v_abv_username);
    if (f_buscar_parametros_nulos(p_abv_parametros,2) or f_buscar_caracteres_prejudiciais(p_abv_parametros,2)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_cpf_voluntario(v_abv_volcpf) is not true then
			select 'ERRO: O voluntário indicado não existe.' as erro;
		else
			if f_transformar_string_status((select volstatus from voluntario where volcpf=v_abv_volcpf)) = 0 then
                select 'ERRO: O voluntario indicado está inativo.' as erro;
			else
				if f_transformar_string_status((select volstatus from voluntario where volcpf=v_abv_volcpf)) = 1 then
					update voluntario set volbio=v_abv_volbio where volcpf=v_abv_volcpf;
				end if;
			end if;
		end if;
	end if;
END$$
DELIMITER ;

-- stored procedure para mudar telefone do voluntario
DELIMITER $$
CREATE Procedure sp_alterar_telefone_voluntario(in p_atv_parametros VARCHAR(1000))
BEGIN
	DECLARE v_atv_username VARCHAR(20);
    declare v_atv_voltelefone char(11);
    declare v_atv_volcpf char(11);
    SET v_atv_username = f_extrair_parametros(p_atv_parametros, 1);
    SET v_atv_voltelefone = f_extrair_parametros(p_atv_parametros, 2);
    set v_atv_volcpf = f_buscar_cpf_voluntario(v_atv_username);
    if (f_buscar_parametros_nulos(p_atv_parametros,2) or f_buscar_caracteres_prejudiciais(p_atv_parametros,2)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_cpf_voluntario(v_atv_volcpf) is not true then
			select 'ERRO: O voluntário indicado não existe.' as erro;
		else
			if f_transformar_string_status((select volstatus from voluntario where volcpf=v_atv_volcpf)) = 0 then
                select 'ERRO: O voluntario indicado está inativo.' as erro;
			else
				if f_transformar_string_status((select volstatus from voluntario where volcpf=v_atv_volcpf)) = 1 then
					update voluntario set voltelefone=v_atv_voltelefone where volcpf=v_atv_volcpf;
				end if;
			end if;
		end if;
	end if;
END$$
DELIMITER ;

-- stored procedure para mudar cidade do voluntario
DELIMITER $$
CREATE Procedure sp_alterar_cidade_voluntario(in p_acv_parametros VARCHAR(1000))
BEGIN
	DECLARE v_acv_username VARCHAR(20);
    declare v_acv_volcidnome varchar(40);
    declare v_acv_volcpf char(11);
    declare v_acv_volcidcod int;
    SET v_acv_username = f_extrair_parametros(p_acv_parametros, 1);
    SET v_acv_volcidnome = f_extrair_parametros(p_acv_parametros, 2);
    set v_acv_volcpf = f_buscar_cpf_voluntario(v_acv_username);
    set v_acv_volcidcod = f_buscar_cidade_codigo(v_acv_volcidnome);
    if (f_buscar_parametros_nulos(p_acv_parametros,2) or f_buscar_caracteres_prejudiciais(p_acv_parametros,2)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_cpf_voluntario(v_acv_volcpf) is not true then
			select 'ERRO: O voluntário indicado não existe.' as erro;
		else
			if f_validar_cidade_codigo(v_acv_volcidcod) is null then
				select 'ERRO: A Cidade indicada não existe' as erro;
            else
				if f_transformar_string_status((select volstatus from voluntario where volcpf=v_acv_volcpf)) = 0 then
					select 'ERRO: O voluntario indicado está inativo.' as erro;
				else
					if f_transformar_string_status((select volstatus from voluntario where volcpf=v_acv_volcpf)) = 1 then
						update voluntario set volcidcod=v_acv_volcidcod where volcpf=v_acv_volcpf;
					end if;
				end if;
			end if;
		end if;
	end if;
END$$
DELIMITER ;


-- stored procedure para adicionar um voluntário a um projeto
DELIMITER $$
CREATE Procedure sp_adicionar_voluntario_projeto(in p_avp_parametros VARCHAR(1000))
BEGIN
	DECLARE v_avp_ususername VARCHAR(20);
    declare v_avp_volcpf char(11);
    DECLARE v_avp_projtitulo VARCHAR(500);
    declare v_avp_projid int default 0;
    SET v_avp_ususername = f_extrair_parametros(p_avp_parametros, 1);
    SET v_avp_projtitulo = f_extrair_parametros(p_avp_parametros, 2);
    set v_avp_volcpf = f_buscar_cpf_voluntario(v_avp_ususername);
    set v_avp_projid = f_buscar_id_projeto(v_avp_projtitulo);
    if (f_buscar_parametros_nulos(p_avp_parametros,1) or f_buscar_caracteres_prejudiciais(p_avp_parametros,1)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_id_projeto(v_avp_projid) is not true then
			select 'ERRO: O projeto indicado não existe.' as erro;
		else
			if f_transformar_string_status((select projstatus from projetosocial where projid=v_avp_projid)) = 0 then
                select 'ERRO: O projeto indicado está inativo.' as erro;
			else
				if f_transformar_string_status((select projstatus from projetosocial where projid=v_avp_projid)) = 1 then
					if f_validar_cpf_voluntario(v_avp_volcpf) is not true then
						select 'ERRO: O voluntário indicado não existe.' as erro;
					else
						if f_transformar_string_status((select volstatus from voluntario where volcpf=v_avp_volcpf)) = 0 then
							select 'ERRO: O voluntario indicado está inativo.' as erro;
						else
							if f_transformar_string_status((select volstatus from voluntario where volcpf=v_avp_volcpf)) = 1 then
								if f_validar_voluntario_projeto(v_avp_volcpf,v_avp_projid) then
									select 'ERRO: O voluntário já esta registrado nesse projeto' as erro;
                                else
									insert into voluntarioprojeto values(v_avp_projid,v_avp_volcpf);
                                    select 'Voluntário registrado no projeto!' as resposta;
                                end if;
							end if;
						end if;
					end if;
				end if;
			end if;
		end if;
	end if;
END$$
DELIMITER ;

-- procedure para ver voluntarios ligados a um projeto
DELIMITER $$
CREATE Procedure sp_voluntarios_projeto(in p_vp_parametros VARCHAR(1000))
BEGIN
	DECLARE v_vp_projtitulo VARCHAR(500);
    declare v_vp_projid int default 0;
    SET v_vp_projtitulo = f_extrair_parametros(p_vp_parametros, 1);
    set v_vp_projid = f_buscar_id_projeto(v_vp_projtitulo);
    if (f_buscar_parametros_nulos(p_vp_parametros,1) or f_buscar_caracteres_prejudiciais(p_vp_parametros,1)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_id_projeto(v_vp_projid) is not true then
			select 'ERRO: O projeto indicado não existe.' as erro;
		else
			if f_transformar_string_status((select projstatus from projetosocial where projid=v_vp_projid)) = 0 then
                select 'ERRO: O projeto indicado está inativo.' as erro;
			else
				if f_transformar_string_status((select projstatus from projetosocial where projid=v_vp_projid)) = 1 then
					if f_voluntarios_projeto(v_vp_projid) is true then
						select ususername as 'username'
						from usuario
						inner join voluntario on uscodigo=voluscod
						inner join voluntarioprojeto on volcpf=volprojcpf
						inner join projetosocial on projid=volprojid
						where projid=v_vp_projid
						group by ususername;
				else
					select 'ERRO: Não há nenhum voluntário cadastrado nesse projeto.' as erro;
                end if;
				end if;
			end if;
		end if;
	end if;
END$$
DELIMITER ;

-- stored procedure para buscar os títulos projetos ligados a um voluntário - em desenvolvimento
DELIMITER $$
CREATE Procedure sp_projetos_voluntario(in p_pv_parametros VARCHAR(1000))
BEGIN
	DECLARE v_pv_username VARCHAR(20);
    declare v_pv_volcpf char(11);
    SET v_pv_username = f_extrair_parametros(p_pv_parametros, 1);
    set v_pv_volcpf = f_buscar_cpf_voluntario(v_pv_username);
    if (f_buscar_parametros_nulos(p_pv_parametros,1) or f_buscar_caracteres_prejudiciais(p_pv_parametros,1)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_cpf_voluntario(v_pv_volcpf) is not true then
			select 'ERRO: O voluntário indicado não existe.' as erro;
		else
			if f_transformar_string_status((select volstatus from voluntario where volcpf=v_pv_volcpf)) = 0 then
                select 'ERRO: O voluntario indicado está inativo.' as erro;
			else
				if f_transformar_string_status((select volstatus from voluntario where volcpf=v_pv_volcpf)) = 1 then
					if f_projetos_voluntario(v_pv_volcpf) is not true then
						select 'ERRO: O voluntario indicado não está participando de nenhum projeto.' as erro;
                    else
						select projtitulo as 'titulo' 
                        from voluntario
						inner join voluntarioprojeto on volcpf=volprojcpf
						inner join projetosocial on projid=volprojid
						where volcpf=v_pv_volcpf
						group by projtitulo;
                    end if;
				end if;
			end if;
		end if;
	end if;
END$$
DELIMITER ;

-- stored procedure para cadastrar habilidades de um voluntário
DELIMITER $$
CREATE Procedure sp_habilidades_voluntario(in p_hv_parametros VARCHAR(1000))
BEGIN
	DECLARE v_hv_username VARCHAR(20);
    DECLARE v_hv_habqtde int;
    declare v_hv_volcpf char(11);
    SET v_hv_username = f_extrair_parametros(p_hv_parametros, 1);
    SET v_hv_habqtde = f_extrair_parametros(p_hv_parametros, 2);
    set v_hv_volcpf = f_buscar_cpf_voluntario(v_hv_username);
    if (f_buscar_parametros_nulos(p_hv_parametros,(2+v_hv_habqtde)) or f_buscar_caracteres_prejudiciais(p_hv_parametros,(2+v_hv_habqtde))) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_cpf_voluntario(v_hv_volcpf) is not true then
			select 'ERRO: O voluntário indicado não existe.' as erro;
		else
			if f_transfomar_string_status((select volstatus from voluntario where volcpf=v_hv_volcpf)) = 0 then
                select 'ERRO: O voluntario indicado está inativo.' as erro;
			else
				if f_transformar_string_status((select volstatus from voluntario where volcpf=v_hv_volcpf)) = 1 then
					if f_definir_habilidades_voluntario(v_hv_volcpf, v_hv_habqtde, p_hv_parametros) is not true then
						select 'ERRO: Há um erro no cadastro das habilidades.' as erro;
                    else
						select 'Habilidades do voluntário cadastradas!' as resposta;
                    end if;
				end if;
			end if;
		end if;
	end if;
END$$
DELIMITER ;
-- stored procedure para cadastrar disponibilidade de voluntário
DELIMITER $$
CREATE Procedure sp_disponibilidade_voluntario(in p_dv_parametros VARCHAR(1000))
BEGIN
	DECLARE v_dv_username VARCHAR(20);
    Declare v_dv_dsnomeclatura varchar(15);
    DECLARE v_dv_voldsid int;
    declare v_dv_manha, v_dv_tarde, v_dv_noite int default 0;
    declare v_dv_volcpf char(11);
    SET v_dv_username = f_extrair_parametros(p_dv_parametros, 1);
    SET v_dv_dsnomeclatura = f_extrair_parametros(p_dv_parametros, 2);
    SET v_dv_manha = f_extrair_parametros(p_dv_parametros, 3);
    SET v_dv_tarde = f_extrair_parametros(p_dv_parametros, 4);
    SET v_dv_noite = f_extrair_parametros(p_dv_parametros, 5);
    set v_dv_voldsid = f_buscar_diasemana_id(v_dv_dsnomeclatura);
    set v_dv_volcpf = f_buscar_cpf_voluntario(v_dv_username);
    if ((f_buscar_parametros_nulos(p_dv_parametros,5) or f_buscar_caracteres_prejudiciais(p_dv_parametros,5)) or (v_dv_manha=0 and v_dv_tarde=0 and v_dv_noite=0)) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if f_validar_cpf_voluntario(v_dv_volcpf) is not true then
			select 'ERRO: O voluntário indicado não existe.' as erro;
		else
			if v_dv_voldsid is not true then
				select 'ERRO: O dia da semana indicado  não existe.' as erro;
            else
				if (select volstatus from voluntario where volcpf=v_dv_volcpf) = '0' then
					select 'ERRO: O voluntario indicado está inativo.' as erro;
				else
					if (select volstatus from voluntario where volcpf=v_dv_volcpf) = '1' then
						if v_dv_manha is true then
							insert into voluntariodiasemana(voldsid, voldscpf, voldsturid)
                            values (v_dv_voldsid, v_dv_volcpf, 1);
						end if;
                        if v_dv_tarde is true then
							insert into voluntariodiasemana(voldsid, voldscpf, voldsturid)
                            values (v_dv_voldsid, v_dv_volcpf, 2);
						end if;
                        if v_dv_noite is true then
							insert into voluntariodiasemana(voldsid, voldscpf, voldsturid)
                            values (v_dv_voldsid, v_dv_volcpf, 3);
						end if;
					end if;
				end if;
			end if;
		end if;
	end if;
END$$
DELIMITER ;
/*
drop procedure sp_disponibilidade_voluntario;
call sp_disponibilidade_voluntario('user123|Segunda-Feira|1|1|1|');
select * from voluntariodiasemana where voldscpf='12345767889';
select * from voluntario;
*/

-- stored procedure para consultar as habilidades cadastradas no banco
DELIMITER $$
CREATE PROCEDURE sp_colsultar_habilidades()
BEGIN
	select habnome from habilidade;
END$$
DELIMITER ;
select habnome from habilidade;

-- stored procedure de login por username e senha

-- stored procedure de login por e-mail e senha