use actnow2024;
set global log_bin_trust_function_creators=1;

/* 
A fazer:
- Terminar de criar as funções;
- Implementar o uso das funções utilizáveis nas SPs existentes;
- Gerar validações nas SPs exitentes:
	-Validar títulos de projetos;
    -Validar data de inicio do projeto;
    -Validar datas;
    -Validar código do usuário do projeto;
    -Validar criação de projeto;
    -Validar data de entrega de atividade;
    -Validar id do projeto na atividade;
    -Validar definição de atividade;
    -Validar alteraçõa na data de entrega da atividade;
    -Validar alteração no status da atividade;
    -Validar alteração na descrição da atividade;
- Terminar de criar as SPs necessárias par a sprint atual;
*/

-- FUNÇÕES -------------------------------------------------

-- função para extrair parametros de uma string

DELIMITER $$
CREATE FUNCTION f_extrair_parametros(p_expr_parametros VARCHAR(1000), p_expr_numparametro INT) RETURNS VARCHAR(500)
BEGIN
    DECLARE v_expr_i INT DEFAULT 1;
    DECLARE v_expr_parametro VARCHAR(100);
    IF p_expr_numparametro = 1 THEN
        SET v_expr_parametro = LEFT(p_expr_parametros, LOCATE(',', p_expr_parametros) - 1);
    ELSE
        WHILE v_expr_i <= p_expr_numparametro DO
            IF v_expr_i = p_expr_numparametro THEN
                SET v_expr_parametro = LEFT(p_expr_parametros, LOCATE(',', p_expr_parametros) - 1);
            ELSE
                SET p_expr_parametros = SUBSTRING(p_expr_parametros, LOCATE(',', p_expr_parametros) + 1);
            END IF;
            SET v_expr_i = v_expr_i + 1;
        END WHILE;
    END IF;
    RETURN v_expr_parametro;
END$$
DELIMITER ;

-- Função para validar string de status.
DELIMITER $$
CREATE FUNCTION f_validar_string_status(p_vss_atstatus VARCHAR(1)) RETURNS boolean
BEGIN
    RETURN p_vss_atstatus in ('1','0');
END$$
DELIMITER ;

select f_validar_string_status('1');

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

select f_transformar_string_status('1');

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

select f_gerar_status_string(1);

-- Função para buscar codigo do usuário pelo username
DELIMITER $$
CREATE FUNCTION f_buscar_codigo_usuario(p_bcu_ususername varchar(20)) RETURNS int(11)
BEGIN
    DECLARE v_bcu_codigo_usuario int default 0;
    
    set v_bcu_codigo_usuario= (select uscodigo
		from usuario
        where ususername=p_bcu_ususername);
    
    RETURN v_bcu_codigo_usuario;
END$$
DELIMITER ;

select f_buscar_codigo_usuario('user123');

-- Função para validar o usuário pelo código
DELIMITER $$
CREATE FUNCTION f_validar_codigo_usuario(p_vcu_uscodigo int) RETURNS boolean
BEGIN
    DECLARE v_vcu_status_usuario boolean default false;
    
    set v_vcu_status_usuario= (select count(*)
		from usuario
        where uscodigo=p_vcu_uscodigo);
    
    RETURN v_vcu_status_usuario;
END$$
DELIMITER ;

select f_validar_codigo_usuario(1);

-- funcção para contar projetos por usuário

DELIMITER $$
CREATE FUNCTION f_contar_projeto_usuario(p_cpu_uscodigo int) RETURNS tinyint
BEGIN
    DECLARE v_cpu_qt_projeto tinyint default 0;
    set v_cpu_qt_projeto=(select count(*)
							from projetosocial
							where projuscod=p_cpu_uscodigo);
    
	return v_cpu_qt_projeto;
END$$
DELIMITER ;

select f_contar_projeto_usuario(1);

-- Função para pesquisar ID do projeto pelo código do usuário.
DELIMITER $$
CREATE FUNCTION f_buscar_projeto_codigo_usuario(p_bpu_uscodigo int) RETURNS varchar(10)
BEGIN
    DECLARE v_bpu_string_projeto varchar(10) default '';
    declare v_cont, v_qt_proj_usuario tinyint default 1;
    DECLARE v_done INT DEFAULT FALSE;
	DECLARE v_linha INT;
    DECLARE v_cursor CURSOR FOR 
		SELECT projid FROM (select projid
							from projetosocial
							where projuscod=p_bpu_uscodigo) as v_consulta;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
    set v_qt_proj_usuario=f_contar_projeto_usuario(p_bpu_uscodigo);
    if v_qt_proj_usuario>1 then
        while v_cont<=v_qt_proj_usuario do
			OPEN v_cursor;
			l_constuir_string: LOOP
				FETCH v_cursor INTO v_linha;
				IF v_done THEN
					LEAVE l_constuir_string;
				else
					if v_cont=2 then
						set v_bpu_string_projeto=concat(v_bpu_string_projeto,',',v_linha);
					else
						set v_bpu_string_projeto=concat(v_bpu_string_projeto,',',v_linha);
						set v_bpu_string_projeto=substring(v_bpu_string_projeto,2);
					end if;
                    SET v_cont = v_cont + 1;
				END IF;
			END LOOP;
			CLOSE v_cursor;
        end while;
	else 
		if v_qt_proj_usuario=1 then
			set v_bpu_string_projeto = convert((select projid
									from projetosocial
									where projuscod=p_bpu_uscodigo), char);
		else
			if v_qt_proj_usuario<1 then
                set v_bpu_string_projeto='0';
			end if;
        end if;
	end if;
    RETURN v_bpu_string_projeto;
END$$
DELIMITER ;


select f_buscar_projeto_codigo_usuario(1);

-- Função para validar projeto pelo ID.
-- Função para validar datas;
-- Função para validar atividade pelo ID.
-- Função para validar data de entrega da atividade.
-- Função para encontrar ID do projeto pelo Título do Projeto.
-- Função para encontrar IDs de atividades de um projeto.


-- STORED PROCEDURES -----------------------------

-- Stored procedure para criar um projeto
DELIMITER $$
CREATE Procedure sp_criar_projeto(in p_crpj_parametros VARCHAR(1000))
BEGIN

	DECLARE v_crpj_projtitulo VARCHAR(500);
	DECLARE v_crpj_projdescricao VARCHAR(45);
	DECLARE v_crpj_projpublicoalvo VARCHAR(100);
	DECLARE v_crpj_projjustificativa VARCHAR(100);
	DECLARE v_crpj_projobjetivos VARCHAR(100);
	DECLARE v_crpj_projdatainicio VARCHAR(10);
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
    if !f_validar_string_status then
		select 'ERRO: O status informado para o projeto é inválido' as erro;
    else
		set v_crpj_projstatustinyint = f_transformar_string_status(v_crpj_projstatusvarchar);
	end if;
	SET v_crpj_projuscod = cast(f_extrair_parametros(p_crpj_parametros, 8) as unsigned int);
    
    insert into projetosocial(projtitulo,projdescricao,projpublicoalvo,projjustificativa,projobjetivos,projdatainicio,projdatafinal,projstatus,projuscod) 
    values(v_crpj_projtitulo,v_crpj_projdescricao,v_crpj_projpublicoalvo,v_crpj_projjustificativa,v_crpj_projobjetivos,v_crpj_projdatainicio,NULL,v_crpj_projstatustinyint,v_crpj_projuscod);
	select 'Projeto criado no banco de dados' as resposta;
END$$
DELIMITER ;

call sp_criar_projeto('Teste,teste,teste,teste,teste,2024-01-02,1,1,');

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
    if !f_validar_string_status(v_dfat_atstatus) then
		select 'ERRO: O status informado para a atividade é inválido' as erro;
    else 
		set v_dfat_atstatustinyint = v_crpj_projstatusvarchar(v_dfat_atstatus);
    end if;
    insert into atividade(attitulo,atdescricao,atdataentrega,atstatus,atprojid) 
    values(v_dfat_attitulo,v_dfat_atdescricao,v_dfat_atdataentrega,v_dfat_atstatustinyint,v_dfat_atprojid);
    select 'Atividade criada no banco de dados' as resposta;
END$$
DELIMITER ;

call sp_definir_Atividade('teste,teste,2024-07-02,1,1,');


-- Stored procedure para alterar a data de uma atividade

DELIMITER $$
CREATE Procedure sp_alterar_data_atividade(in p_adta_parametros VARCHAR(1000))
BEGIN

	DECLARE v_adta_atid int unsigned;
	DECLARE v_adta_atdataentrega date;
    
    SET v_adta_atid = cast(f_extrair_parametros(p_adta_parametros, 1) as unsigned int);
	SET v_adta_atdataentrega = cast(f_extrair_parametros(p_adta_parametros, 2) as date);
    
    update atividade set atdataentrega=v_adta_atdataentrega where atid=v_adta_atid;
SELECT 'Data da atividade alterada no banco de dados' AS resposta;
END$$
DELIMITER ;

call sp_alterar_data_atividade('1,2024-11-25,');

select * from atividade

-- Stored procedure para alterar o status de uma atividade

DELIMITER $$
CREATE Procedure sp_alterar_status_atividade(in p_asta_parametros VARCHAR(1000))
BEGIN

	DECLARE v_asta_atid int unsigned;
	DECLARE v_asta_atstatus VARCHAR(1);
    DECLARE v_asta_atstatustinyint tinyint(1) unsigned;
    
    SET v_asta_atid = cast(f_extrair_parametros(p_asta_parametros, 1) as unsigned int);
	SET v_asta_atstatus = f_extrair_parametros(p_asta_parametros, 2);
	if(v_asta_atstatus='1') then
		set v_asta_atstatustinyint = 1;
    else
		set v_asta_atstatustinyint = 0;
    end if;
    
    update atividade set atstatus=v_asta_atstatustinyint where atid=v_asta_atid;
SELECT 'Status da atividade alterada no banco de dados' AS resposta;
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
    
    update atividade set atdescricao=v_adesa_atdescricao where atid=v_adesa_atid;
SELECT 'Descrição da atividade alterada no banco de dados' AS resposta;
END$$
DELIMITER ;

-- Stored procedure pra calendário de atividades pelo Título do Projeto.
-- Stored procedure para validar usuário pelo username.
-- Stored procedures para consultar informações de usuário pelo username.
-- Stored procedure para consultar informações de projeto pelo título do projeto.