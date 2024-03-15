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
select f_contar_parametros('teste|teste|teste|teste|teste|teste|teste|');
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
select f_concatenar_parametros('teste|teste|teste|',2);
