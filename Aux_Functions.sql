use actnow24;
set global log_bin_trust_function_creators=1;
-- função para extrair parametros de uma string

DELIMITER $$
CREATE FUNCTION f_extrair_parametros(p_expr_parametros VARCHAR(1000), p_expr_numparametro INT) RETURNS VARCHAR(500)
BEGIN
    DECLARE v_expr_i INT DEFAULT 1;
    DECLARE v_expr_parametro VARCHAR(100);
    IF p_expr_numparametro = 1 THEN
        SET v_expr_parametro = LEFT(p_expr_parametros, LOCATE('|', p_expr_parametros) - 1);
    ELSE
        WHILE v_expr_i <= p_expr_numparametro DO
            IF v_expr_i = p_expr_numparametro THEN
                SET v_expr_parametro = LEFT(p_expr_parametros, LOCATE('|', p_expr_parametros) - 1);
            ELSE
                SET p_expr_parametros = SUBSTRING(p_expr_parametros, LOCATE('|', p_expr_parametros) + 1);
            END IF;
            SET v_expr_i = v_expr_i + 1;
        END WHILE;
    END IF;
    RETURN v_expr_parametro;
END$$
DELIMITER ;

-- função para extrair parametros de uma string

DELIMITER $$
CREATE FUNCTION f_extrair_parametros_altered(p_expr_parametros VARCHAR(1000), p_expr_numparametro INT) RETURNS VARCHAR(500)
BEGIN
    DECLARE v_expr_i INT DEFAULT 1;
    DECLARE v_expr_parametro VARCHAR(100);
    IF p_expr_numparametro = 1 THEN
        SET v_expr_parametro = LEFT(p_expr_parametros, LOCATE(';', p_expr_parametros) - 1);
    ELSE
        WHILE v_expr_i <= p_expr_numparametro DO
            IF v_expr_i = p_expr_numparametro THEN
                SET v_expr_parametro = LEFT(p_expr_parametros, LOCATE(';', p_expr_parametros) - 1);
            ELSE
                SET p_expr_parametros = SUBSTRING(p_expr_parametros, LOCATE(';', p_expr_parametros) + 1);
            END IF;
            SET v_expr_i = v_expr_i + 1;
        END WHILE;
    END IF;
    RETURN v_expr_parametro;
END$$
DELIMITER ;

-- Função para formatar data
DELIMITER $$
CREATE FUNCTION f_formata_data(p_data date) RETURNS varchar(10)
BEGIN
	declare v_data_resultado varchar(10);
    set v_data_resultado = concat(reverse(left(reverse(p_data), locate('-', reverse(p_data))-1)),'/', left(right(p_data, (length(p_data)-locate('-', p_data))), locate('-', right(p_data, (length(p_data)-locate('-', p_data))))-1),'/',left(p_data, locate('-', p_data)-1));
    return v_data_resultado;
END$$
DELIMITER ;
-- select f_formata_data(projdatainicio) from projetosocial;
-- Função para verificar parâmetros nulos.
DELIMITER $$
CREATE FUNCTION f_buscar_parametros_nulos(p_parametros varchar(1000), p_qt_parametros int) RETURNS boolean
BEGIN
	declare v_resultado boolean default false;
    declare v_cont int default 1;
    declare v_conteudo_parametro varchar(500);
    while v_cont<=p_qt_parametros do
		set v_conteudo_parametro = f_extrair_parametros(p_parametros,v_cont);
        if v_conteudo_parametro in('',null,'null','Null','NULL') then
			set v_resultado = true;
        end if;
        set v_cont=v_cont+1;
	end while;
    return v_resultado;
END$$
DELIMITER ;

-- select f_buscar_parametros_nulos(',',1);
DELIMITER $$
CREATE FUNCTION f_contar_parametros(p_parametros VARCHAR(1000)) RETURNS INT
BEGIN
    DECLARE v_cont INT DEFAULT 0;
    DECLARE v_posicao INT DEFAULT 1;

    -- Verifica se a string de parâmetros é nula ou vazia
    IF p_parametros IS NULL OR p_parametros = '' THEN
        RETURN 0;
    END IF;

    -- Conta o número de divisores "|" na string
    WHILE v_posicao > 0 DO
        SET v_cont = v_cont + 1;
        SET v_posicao = LOCATE('|', p_parametros, v_posicao + 1);
    END WHILE;

    RETURN v_cont-1;
END$$
DELIMITER ;
-- select f_contar_parametros('teste|teste|teste|teste|teste|teste|teste|');
-- Função para concatenar parametros
DELIMITER $$
CREATE FUNCTION f_concatenar_parametros(p_parametros varchar(1000), p_qt_parametros int) RETURNS varchar(1000)
BEGIN
    declare v_cont int default 1;
    declare v_conteudo_parametro varchar(500);
    declare v_resultado varchar(1000) default '';
    while v_cont<=p_qt_parametros do
		set v_conteudo_parametro = f_extrair_parametros(p_parametros,v_cont);
		if v_cont=p_qt_parametros-1 then
			set v_resultado=concat(v_resultado,v_conteudo_parametro,'|');
		else
			set v_resultado=concat(v_resultado,v_conteudo_parametro,'|');
        end if;
        set v_cont=v_cont+1;
	end while;
    return v_resultado;
END$$
DELIMITER ;
-- select f_concatenar_parametros('teste|teste|teste|',2);

-- Função para verificar se um usuário possui uma habilidade requisitada
DELIMITER $$
CREATE FUNCTION f_verificar_habilidade_username(p_vhu_ususername varchar(20), p_vhu_id_habilidade int) RETURNS boolean
BEGIN
    declare v_vhu_resultado boolean default false;
    set v_vhu_resultado= (select count(*)
						from usuario
						join voluntario on uscodigo=voluscod
						join voluntariohabilidade on volhabcpf=volcpf
						join habilidade on  volhabid = habid
                        where ususername=p_vhu_ususername and habid=p_vhu_id_habilidade and usstatus=1);
    return v_vhu_resultado;
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
		if f_verificar_habilidade_username(p_vhsu_ususername,v_vhsu_conteudo_parametro_id) then
			set v_vhsu_resultado=v_vhsu_resultado+1;
        end if;
        set v_vhsu_cont_habilidades=v_vhsu_cont_habilidades+1;
        set v_vhsu_cont=v_vhsu_cont+1;
	end while;
    return v_vhsu_resultado;
END$$
DELIMITER ;

-- função para validar email
DELIMITER $$
CREATE FUNCTION f_validar_email(p_email VARCHAR(80))
RETURNS BOOLEAN
BEGIN
    DECLARE v_email_regex VARCHAR(255);
    SET v_email_regex = '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';

    IF p_email REGEXP v_email_regex THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END; $$
DELIMITER ;
-- drop function f_validar_email;
-- SELECT f_validar_email((select usemail from usuario where uscodigo=1)) AS e_mail_valido;

-- Verifica se o parâmetro contém algum caractere prejudicial
DELIMITER $$
CREATE FUNCTION f_buscar_caracteres_prejudiciais(p_parametros VARCHAR(1000), p_qt_parametros INT) RETURNS BOOLEAN
BEGIN
    DECLARE v_resultado BOOLEAN DEFAULT FALSE;
    DECLARE v_cont INT DEFAULT 1;
    DECLARE v_conteudo_parametro VARCHAR(500);
    DECLARE v_caracteres_prejudiciais VARCHAR(100) DEFAULT '\'\'";--|\\`&<>()=%+';
    
    WHILE v_cont <= p_qt_parametros DO
        SET v_conteudo_parametro = f_extrair_parametros(p_parametros, v_cont);
        
        -- Verifica se o parâmetro contém algum caractere prejudicial
        IF v_conteudo_parametro REGEXP CONCAT('[', v_caracteres_prejudiciais, ']') THEN
            SET v_resultado = TRUE;
        END IF;
        SET v_cont = v_cont + 1;
    END WHILE;
    RETURN v_resultado;
END$$
DELIMITER ;