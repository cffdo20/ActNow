DELIMITER $$
CREATE FUNCTION extrairParametros(parametros VARCHAR(1000), numparametro INT) RETURNS VARCHAR(500)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE parametro VARCHAR(100);
    IF numparametro = 1 THEN
        SET parametro = LEFT(parametros, LOCATE(',', parametros) - 1);
    ELSE
        WHILE i <= numparametro DO
            IF i = numparametro THEN
                SET parametro = LEFT(parametros, LOCATE(',', parametros) - 1);
            ELSE
                SET parametros = SUBSTRING(parametros, LOCATE(',', parametros) + 1);
            END IF;
            SET i = i + 1;
        END WHILE;
    END IF;
    RETURN parametro;
END$$
DELIMITER ;

DELIMITER $$
CREATE Procedure criarProjeto(in parametros VARCHAR(1000))
BEGIN

	DECLARE projtitulo VARCHAR(500);
	DECLARE projdescricao VARCHAR(45);
	DECLARE projpublicoalvo VARCHAR(100);
	DECLARE projjustificativa VARCHAR(100);
	DECLARE projobjetivos VARCHAR(100);
	DECLARE projdatainicio VARCHAR(10);
	DECLARE projstatusvarchar VARCHAR(1);
    DECLARE projstatustinyint tinyint;
	DECLARE projuscod VARCHAR(2);
    
	SET projtitulo = extrairParametros(parametros, 1);
	SET projdescricao = extrairParametros(parametros, 2);
	SET projpublicoalvo = extrairParametros(parametros, 3);
	SET projjustificativa = extrairParametros(parametros, 4);
	SET projobjetivos = extrairParametros(parametros, 5);
	SET projdatainicio = cast(extrairParametros(parametros, 6) as date);
    set projstatusvarchar = extrairParametros(parametros, 7);
	if(projstatusvarchar='1') then
		set projstatustinyint = 1;
    else
		set projstatustinyint = 0;
    end if;
	SET projuscod = cast(extrairParametros(parametros, 8) as unsigned int);
    
    insert into projetosocial(projtitulo,projdescricao,projpublicoalvo,projjustificativa,projobjetivos,projdatainicio,projdatafinal,projstatus,projuscod) 
    values(projtitulo,projdescricao,projpublicoalvo,projjustificativa,projobjetivos,projdatainicio,NULL,projstatustinyint,projuscod);
END$$
DELIMITER ;
