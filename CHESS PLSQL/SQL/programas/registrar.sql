DECLARE
nombreJugador tbl_jugadores.nombre%TYPE := '&nombrejugador';
identifiJugador tbl_jugadores.identificacion%TYPE := '&idenftificacionjugador';
verifiJugador tbl_jugadores.identificacion%TYPE := '';

CURSOR verificar_existe_jugador(pidentificacion VARCHAR2) IS
SELECT identificacion
FROM tbl_jugadores
WHERE identificacion = pidentificacion;

BEGIN
OPEN verificar_existe_jugador(identifiJugador);
FETCH verificar_existe_jugador INTO verifiJugador;

dbms_output.put_line(verifiJugador);

IF verificar_existe_jugador%NOTFOUND THEN

INSERT INTO tbl_jugadores (id_jugador, identificacion, nombre, tipo_pieza, cant_partidas_ganadas, cant_partidas_perdidas)
VALUES (incrementar_id_jugador.NEXTVAL, identifiJugador, nombreJugador, '', 0, 0);

dbms_output.put_line(chr(10) || chr(10) || '******************************');
dbms_output.put_line('** USUARIO CREADO CON EXITO **');
dbms_output.put_line('******************************' || chr(10));
dbms_output.put_line('NOMBRE: ' || nombrejugador || ' - IDENTIFICACION: ' || identifiJugador || chr(10));

ELSE
dbms_output.put_line(chr(10) || chr(10) || '************************************************');
dbms_output.put_line('************ USUARIO YA EXISTENTE **************');
dbms_output.put_line('** POR FAVOR INGRESE UNA IDENTIFICACION NUEVA **');
dbms_output.put_line('************************************************' || chr(10));

END IF;
CLOSE verificar_existe_jugador;
END;
/
