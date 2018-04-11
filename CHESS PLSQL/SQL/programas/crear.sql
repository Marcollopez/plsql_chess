DECLARE
identiJugadorUno tbl_jugadores.identificacion%TYPE := '&jugadorUno';
identijugadorDos tbl_jugadores.identificacion%TYPE := '&jugadorDos';

idJugadorUno tbl_jugadores.id_jugador%TYPE;
idJugadorDos  tbl_jugadores.id_jugador%TYPE;

nombreJugadorUno tbl_jugadores.nombre%TYPE;
nombreJugadorDos tbl_jugadores.nombre%TYPE;

idPiezaTemp tbl_piezas.id_pieza%TYPE;

idPartida tbl_partidas.id_partida%TYPE;

CURSOR verificar_jugador(pidentifiJugador VARCHAR2) IS
SELECT id_jugador, nombre
FROM tbl_jugadores
WHERE identificacion = pidentifiJugador;

CURSOR info_tipo_piezas(ptipo VARCHAR2) IS
SELECT id_pieza
FROM tbl_piezas
WHERE tipo = ptipo;

BEGIN

OPEN verificar_jugador(identiJugadorUno);
FETCH verificar_jugador INTO idJugadorUno, nombreJugadorUno;
CLOSE verificar_jugador;

IF idJugadorUno <> 0 THEN

OPEN verificar_jugador(identijugadorDos);
FETCH verificar_jugador INTO idJugadorDos, nombreJugadorDos;
CLOSE verificar_jugador;

IF idJugadorDos <> 0 THEN

OPEN info_tipo_piezas('blanca');
LOOP
FETCH info_tipo_piezas INTO idPiezaTemp;
EXIT WHEN info_tipo_piezas%NOTFOUND;

INSERT INTO tbl_jugadores_piezas (id_jugador, id_pieza, mueve)
VALUES (idJugadorUno, idPiezaTemp, 1);
END LOOP;
CLOSE info_tipo_piezas;

OPEN info_tipo_piezas('negra');
LOOP
FETCH info_tipo_piezas INTO idPiezaTemp;
EXIT WHEN info_tipo_piezas%NOTFOUND;

INSERT INTO tbl_jugadores_piezas (id_jugador, id_pieza, mueve)
VALUES (idJugadorDos, idPiezaTemp, 0);
END LOOP;
CLOSE info_tipo_piezas;

idPartida := incrementar_id_partida.NEXTVAL;

INSERT INTO tbl_partidas (id_partida, id_jugador_blancas, id_jugador_negras, jugador_ganador, movimientos_blanca, movimientos_negra)
VALUES (idPartida, idJugadorUno, idJugadorDos, 0, '', '');

INSERT INTO tbl_informacion_partidas (id_jugador, id_partida, resultado_partida)
VALUES (idJugadorUno, idPartida, 'en juego');

INSERT INTO tbl_informacion_partidas (id_jugador, id_partida, resultado_partida)
VALUES (idJugadorDos, idPartida, 'en juego');

UPDATE tbl_jugadores
SET tipo_pieza = 'Blancas'
WHERE id_jugador = idJugadorUno;

UPDATE tbl_jugadores
SET tipo_pieza = 'Negras'
WHERE id_jugador = idJugadorDos;

dbms_output.put_line(chr(10) || chr(10) || '****************************************************');
dbms_output.put_line('****************** PARTIDA CREADA ******************');
dbms_output.put_line('****************************************************');

pr_mostrar_jug_mueve;
pr_mostrar_tablero;

ELSE
dbms_output.put_line(chr(10) || chr(10) || '*****************************************************************');
dbms_output.put_line('******************** USUARIO NO ENCONTTRADO *********************');
dbms_output.put_line('--> EL NUMERO DE IDENTIFICACION: ' ||  identiJugadorUno || ' NO FUE ENCONTRADO');
dbms_output.put_line('*****************************************************************' || chr(10));

END IF;

ELSE

dbms_output.put_line(chr(10) || chr(10) || '*****************************************************************');
dbms_output.put_line('******************** USUARIO NO ENCONTTRADO *********************');
dbms_output.put_line('--> EL NUMERO DE IDENTIFICACION: ' ||  identijugadorDos || ' NO FUE ENCONTRADO');
dbms_output.put_line('*****************************************************************' || chr(10));

END IF;
END;
/
