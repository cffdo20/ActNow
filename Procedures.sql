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
	DECLARE v_crpj_projuscod VARCHAR(2);
    
	SET v_crpj_projtitulo = f_extrair_parametros(p_crpj_parametros, 1);
	SET v_crpj_projdescricao = f_extrair_parametros(p_crpj_parametros, 2);
	SET v_crpj_projpublicoalvo = f_extrair_parametros(p_crpj_parametros, 3);
	SET v_crpj_projjustificativa = f_extrair_parametros(p_crpj_parametros, 4);
	SET v_crpj_projobjetivos = f_extrair_parametros(p_crpj_parametros, 5);
	SET v_crpj_projdatainicio = cast(f_extrair_parametros(p_crpj_parametros, 6) as date);
    set v_crpj_projstatusvarchar = f_extrair_parametros(p_crpj_parametros, 7);
	SET v_crpj_projuscod = cast(f_extrair_parametros(p_crpj_parametros, 8) as unsigned int);
    if f_buscar_parametros_nulos(p_crpj_parametros,8) then
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
    DECLARE v_dfat_atprojid int unsigned;
    DECLARE v_dfat_atstatustinyint tinyint(1) unsigned;
    
	SET v_dfat_attitulo = f_extrair_parametros(p_dfat_parametros, 1);
	SET v_dfat_atdescricao = f_extrair_parametros(p_dfat_parametros, 2);
	SET v_dfat_atdataentrega = cast(f_extrair_parametros(p_dfat_parametros, 3) as date);
	SET v_dfat_atstatus = f_extrair_parametros(p_dfat_parametros, 4);
	SET v_dfat_atprojid = cast(f_extrair_parametros(p_dfat_parametros, 5) as unsigned int);
    if f_buscar_parametros_nulos(p_dfat_parametros,5) then
		select 'ERRO: Preencha todas as informações necessárias corretamente.' as erro;
	else
		if not f_validar_string_status(v_dfat_atstatus) then
			select 'ERRO: O status informado para a atividade é inválido.' as erro;
		else 
			set v_dfat_atstatustinyint = f_transformar_string_status(v_dfat_atstatus);
			if not f_validar_id_projeto(v_dfat_atprojid) then
				select 'ERRO: O projeto indicado não existe.' as erro;
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
END$$
DELIMITER ;


-- Stored procedure para alterar a data de uma atividade

DELIMITER $$
CREATE Procedure sp_alterar_data_atividade(in p_adta_parametros VARCHAR(1000))
BEGIN

	DECLARE v_adta_atid int unsigned;
	DECLARE v_adta_atdataentrega date;
    
    SET v_adta_atid = cast(f_extrair_parametros(p_adta_parametros, 1) as unsigned int);
	SET v_adta_atdataentrega = cast(f_extrair_parametros(p_adta_parametros, 2) as date);
    if f_buscar_parametros_nulos(p_adta_parametros,2) then
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

	DECLARE v_asta_atid int unsigned;
	DECLARE v_asta_atstatus VARCHAR(1);
    DECLARE v_asta_atstatustinyint tinyint(1) unsigned;
    
    SET v_asta_atid = cast(f_extrair_parametros(p_asta_parametros, 1) as unsigned int);
	SET v_asta_atstatus = f_extrair_parametros(p_asta_parametros, 2);
    if f_buscar_parametros_nulos(p_asta_parametros,2) then
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

	DECLARE v_adesa_atid int unsigned;
	DECLARE v_adesa_atdescricao VARCHAR(200);
    
    SET v_adesa_atid = cast(f_extrair_parametros(p_adesa_parametros, 1) as unsigned int);
	SET v_adesa_atdescricao = f_extrair_parametros(p_adesa_parametros, 2);
    if f_buscar_parametros_nulos(p_adesa_parametros,2) then
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
    if f_buscar_parametros_nulos(p_cap_parametros,1) then
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

-- Stored procedure para validar usuário pelo username e senha.
-- Stored procedures para consultar informações de usuário pelo username.

-- Stored procedure para consultar informações de projeto pelo título do projeto.
DELIMITER $$
CREATE Procedure sp_consultar_projeto(in p_cp_parametros VARCHAR(1000))
BEGIN
	DECLARE v_cp_projtitulo VARCHAR(500);
    declare v_cp_projid int default 0;
    declare v_cp_ususername varchar(20);
    SET v_cp_projtitulo = f_extrair_parametros(p_cp_parametros, 1);
    set v_cp_projid = f_buscar_id_projeto(v_cp_projtitulo);
    if f_buscar_parametros_nulos(p_cp_parametros,1) then
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
					select projtitulo 'titulo',projdescricao 'descricao',projpublicoalvo 'publico',projjustificativa 'justificativa',projobjetivos 'objetivos',f_formata_data(projdatainicio) 'inicio',f_gerar_status_string(f_transformar_string_status(projstatus)) 'status',f_buscar_username(projuscod) 'criador' from projetosocial where projid=v_cp_projid;
				end if;
			end if;
		end if;
	end if;
END$$
DELIMITER ;
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
    if f_buscar_parametros_nulos(p_cv_parametros,1) then
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
				where voluscod = v_cv_uscodigo;
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
    
    if f_buscar_parametros_nulos(p_fv_parametros,5) then
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
    if f_buscar_parametros_nulos(p_cpu_parametros,1) then
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
				where projuscod=v_cpu_uscodigo;
			end if;
		end if;
    end if;
END$$
DELIMITER ;
-- Procedure para alterar a descrição de um projeto
DELIMITER $$
CREATE Procedure sp_alterar_descricao_projeto(in p_adp_parametros VARCHAR(1000))
BEGIN
	DECLARE v_adp_projtitulo, v_adp_projdescricao VARCHAR(500);
    declare v_adp_projid int default 0;
    SET v_adp_projtitulo = f_extrair_parametros(p_adp_parametros, 1);
    SET v_adp_projdescricao = f_extrair_parametros(p_adp_parametros, 2);
    set v_adp_projid = f_buscar_id_projeto(v_adp_projtitulo);
    if f_buscar_parametros_nulos(p_adp_parametros,2) then
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
    if f_buscar_parametros_nulos(p_app_parametros,2) then
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
    if f_buscar_parametros_nulos(p_ajp_parametros,2) then
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
    if f_buscar_parametros_nulos(p_aop_parametros,2) then
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
    if f_buscar_parametros_nulos(p_ip_parametros,1) then
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