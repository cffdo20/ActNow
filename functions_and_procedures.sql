use actnow2024;
DELIMITER $$
CREATE FUNCTION fun_extrair_parametros(fun_expr_parametros VARCHAR(1000), fun_expr_numparametro INT) RETURNS VARCHAR(500)
BEGIN
    DECLARE v_expr_i INT DEFAULT 1;
    DECLARE v_expr_parametro VARCHAR(100);
    IF v_expr_numparametro = 1 THEN
        SET v_expr_parametro = LEFT(v_expr_parametros, LOCATE(',', v_expr_parametros) - 1);
    ELSE
        WHILE v_expr_i <= v_expr_numparametro DO
            IF v_expr_i = v_expr_numparametro THEN
                SET v_expr_parametro = LEFT(v_expr_parametros, LOCATE(',', v_expr_parametros) - 1);
            ELSE
                SET v_expr_parametros = SUBSTRING(v_expr_parametros, LOCATE(',', v_expr_parametros) + 1);
            END IF;
            SET v_expr_i = v_expr_i + 1;
        END WHILE;
    END IF;
    RETURN v_expr_parametro;
END$$
DELIMITER ;

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
    
	SET v_crpj_projtitulo = fun_extrair_parametros(p_crpj_parametros, 1);
	SET v_crpj_projdescricao = fun_extrair_parametros(p_crpj_parametros, 2);
	SET v_crpj_projpublicoalvo = fun_extrair_parametros(p_crpj_parametros, 3);
	SET v_crpj_projjustificativa = fun_extrair_parametros(p_crpj_parametros, 4);
	SET v_crpj_projobjetivos = fun_extrair_parametros(p_crpj_parametros, 5);
	SET v_crpj_projdatainicio = cast(fun_extrair_parametros(p_crpj_parametros, 6) as date);
    set v_crpj_projstatusvarchar = fun_extrair_parametros(p_crpj_parametros, 7);
	if(v_crpj_projstatusvarchar='1') then
		set v_crpj_projstatustinyint = 1;
    else
		set v_crpj_projstatustinyint = 0;
    end if;
	SET v_crpj_projuscod = cast(fun_extrair_parametros(p_crpj_parametros, 8) as unsigned int);
    
    insert into projetosocial(projtitulo,projdescricao,projpublicoalvo,projjustificativa,projobjetivos,projdatainicio,projdatafinal,projstatus,projuscod) 
    values(v_crpj_projtitulo,v_crpj_projdescricao,v_crpj_projpublicoalvo,v_crpj_projjustificativa,v_crpj_projobjetivos,v_crpj_projdatainicio,NULL,v_crpj_projstatustinyint,v_crpj_projuscod);
	select 'Projeto criado no banco de dados' as resposta;
END$$
DELIMITER ;

call sp_criar_projeto('Teste,teste,teste,teste,teste,2024-01-02,1,1,');

select * from projetosocial;

DELIMITER $$
CREATE Procedure sp_definir_Atividade(in p_dfat_parametros VARCHAR(1000))
BEGIN

	DECLARE v_dfat_attitulo VARCHAR(100);
	DECLARE v_dfat_atdescricao VARCHAR(200);
	DECLARE v_dfat_atdataentrega VARCHAR(10);
	DECLARE v_dfat_atstatus VARCHAR(1);
    DECLARE v_dfat_atprojid int unsigned;
    DECLARE v_dfat_atstatustinyint tinyint(1) unsigned;
    
	SET v_dfat_attitulo = fun_extrair_parametros(p_dfat_parametros, 1);
	SET v_dfat_atdescricao = fun_extrair_parametros(p_dfat_parametros, 2);
	SET v_dfat_atdataentrega = fun_extrair_parametros(p_dfat_parametros, 3);
	SET v_dfat_atstatus = fun_extrair_parametros(p_dfat_parametros, 4);
	SET v_dfat_atprojid = cast(fun_extrair_parametros(p_dfat_parametros, 5) as unsigned int);
	if(v_dfat_atstatus='1') then
		set v_dfat_atstatustinyint = 1;
    else
		set v_dfat_atstatustinyint = 0;
    end if;
    
    insert into atividade(attitulo,atdescricao,atdataentrega,atstatus,atprojid) 
    values(v_dfat_attitulo,v_dfat_atdescricao,v_dfat_atdataentrega,v_dfat_atstatustinyint,v_dfat_atprojid);
    select 'Atividade criada no banco de dados' as resposta;
END$$
DELIMITER ;

call sp_definir_Atividade('teste,teste,2024-07-02,1,1,');

select * from atividade;

