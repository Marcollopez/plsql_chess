DECLARE
identifiJugador tbl_jugadores.identificacion%TYPE := '&idenftificacionjugador';
verifiJugador tbl_jugadores.identificacion%TYPE := '';

idJugador tbl_jugadores.id_jugador%TYPE;
idPartida tbl_partidas.id_partida%TYPE;
resultPartida tbl_informacion_partidas.resultado_partida%TYPE;

idJugBlancas tbl_jugadores.id_jugador%TYPE;
idJugNegras tbl_jugadores.id_jugador%TYPE;

nombreJugador tbl_jugadores.nombre%TYPE;
nomJugBlancas tbl_jugadores.nombre%TYPE;
nomJugNegras tbl_jugadores.nombre%TYPE;

cantGanadas tbl_jugadores.cant_partidas_ganadas%TYPE;
cantPerdidas tbl_jugadores.cant_partidas_perdidas%TYPE;

cantPartidas NUMBER(5);
porcentGanadas FLOAT(5);
porcentPerdidas FLOAT(5);

CURSOR verificar_existe_jugador(pidentificacion VARCHAR2) IS
SELECT identificacion
FROM tbl_jugadores
WHERE identificacion = pidentificacion;

CURSOR info_partidas(pidJugador NUMBER) IS
SELECT id_partida, resultado_partida
FROM tbl_informacion_partidas
WHERE id_jugador = pidJugador;

CURSOR info_partidas_vs(pidPartida NUMBER) IS
SELECT id_jugador_blancas, id_jugador_negras
FROM tbl_partidas
WHERE id_partida = pidPartida;

BEGIN
OPEN verificar_existe_jugador(identifiJugador);
FETCH verificar_existe_jugador INTO verifiJugador;

dbms_output.put_line(verifiJugador);

IF verificar_existe_jugador%NOTFOUND THEN

dbms_output.put_line(chr(10) || chr(10) || '************************************************');
dbms_output.put_line('************ JUGADOR NO EXISTENTE **************');
dbms_output.put_line('***** POR FAVOR INGRESE UNA IDENTIFICACION *****');
dbms_output.put_line('************************************************' || chr(10));

ELSE

SELECT id_jugador, nombre, cant_partidas_ganadas, cant_partidas_perdidas
INTO idJugador, nombreJugador, cantGanadas, cantPerdidas
FROM tbl_jugadores
WHERE identificacion = identifiJugador;

cantPartidas := cantGanadas + cantPerdidas;

porcentGanadas := cantGanadas / cantPartidas * 100;
porcentPerdidas := cantPerdidas / cantPartidas * 100;

dbms_output.put_line(chr(10) || '------------------------------------------------------------');
dbms_output.put_line('----------------- ESTADISTICAS DEL JUGADOR -----------------');

dbms_output.put_line('------------------------------------------------------------' || chr(10));
dbms_output.put_line('Nombre del Jugador --> ' || nombreJugador || chr(10) || 'Identificacion     --> ' || identifiJugador);
dbms_output.put_line(chr(10) || 'Partidas ganadas: ' || cantGanadas);
dbms_output.put_line('Partidas perdidas: ' || cantPerdidas || chr(10));
dbms_output.put_line('Porcentaje de victoria: ' || porcentGanadas || '%');
dbms_output.put_line('Porcentaje de derrota: ' || porcentPerdidas || '%' || chr(10));

dbms_output.put_line('------------------------------------------------------------');
dbms_output.put_line('------------- INFORMACION DE PARTIDAS JUGADAS --------------');
dbms_output.put_line('------------------------------------------------------------' || chr(10));

OPEN info_partidas(idJugador);
LOOP
FETCH info_partidas INTO idPartida, resultPartida;
EXIT WHEN info_partidas%NOTFOUND;

OPEN info_partidas_vs(idPartida);

FETCH info_partidas_vs INTO idJugBlancas, idJugNegras;

SELECT nombre
INTO nomJugBlancas
FROM tbl_jugadores
WHERE id_jugador = idJugBlancas;

SELECT nombre
INTO nomJugNegras
FROM tbl_jugadores
WHERE id_jugador = idJugNegras;

dbms_output.put_line('Identificacion de la partida: ' || idPartida);
dbms_output.put_line('Resultado de la partida: ' || resultPartida);
dbms_output.put_line('Enfrentamiento');
dbms_output.put_line('Blancas --> ' || nomJugBlancas || ' vs ' || nomJugNegras || ' <-- Negras ' || chr(10));

CLOSE info_partidas_vs;
END LOOP;

CLOSE info_partidas;

END IF;
CLOSE verificar_existe_jugador;

dbms_output.put_line('------------------------------------------------------------');
END;
/
