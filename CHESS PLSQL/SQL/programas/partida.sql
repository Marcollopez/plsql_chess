DECLARE

idPartida tbl_partidas.id_partida%TYPE := '&idpartida';

BEGIN
dbms_output.put_line(chr(10) || '------------------------------------------------------------');
dbms_output.put_line('------------------- ESTADO DE LA PARTIDA -------------------');
dbms_output.put_line('------------------------------------------------------------');
dbms_output.put_line('----------------------- ESTADISTICAS -----------------------');

pr_mostrar_estad_partida(idPartida);

dbms_output.put_line('------------------------------------------------------------');
dbms_output.put_line('------------------ TABLERO DE LA PARTIDA -------------------');

pr_mostrar_tablero_partida(idPartida);

dbms_output.put_line('------------------------------------------------------------');
dbms_output.put_line('------------------------------------------------------------');

END;
/
