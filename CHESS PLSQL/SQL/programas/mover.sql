DECLARE

coordenadaInicio tbl_piezas.coordenada%TYPE := '&coordenadaInicio';
coordenadaDestino tbl_piezas.coordenada%TYPE := '&coordenadadestino';

estado VARCHAR(10);

continuar NUMBER(1);

BEGIN

estado := 'jq';

IF coordenadaInicio = estado OR coordenadaDestino = estado  THEN

pr_terminar_partida;

dbms_output.put_line('****** JAQUE MATE ******' || chr(10));

ELSE

   continuar := fn_mover(coordenadaInicio, coordenadaDestino);

   pr_mostrar_tablero;

   CASE continuar

   WHEN 1 THEN

   dbms_output.put_line(chr(10) || 'Movimiento de pieza EXITOSO!!' || chr(10) || 'Coordenadas: ' || coordenadaInicio || ' - ' || coordenadaDestino);

   WHEN 2 THEN

   dbms_output.put_line(chr(10) || 'La pieza del enemigo ha sido DESTRUIDA!!' || chr(10));

   WHEN 9 THEN

   dbms_output.put_line(chr(10) || 'Movimiento de pieza INVALIDO!!' || chr(10));

   WHEN 8 THEN

dbms_output.put_line(chr(10) || '***************************************************************');
dbms_output.put_line('********************** ERROR DE CONTENIDO *********************');
dbms_output.put_line('** POSIBLES ERRORES:  *****************************************');
dbms_output.put_line('** 1.EN LA COORDENADA INICIAL NO HAY PIEZA ********************');
dbms_output.put_line('** 2.LA PIEZA SELECCIONADA NO PERTENECE AL JUGADOR QUE MUEVE **');
dbms_output.put_line('** 3.EN LA COORDENADA FINAL HAY UNA PIEZA PROPIA **************');
dbms_output.put_line('***************************************************************');

   WHEN 7 THEN

dbms_output.put_line(chr(10) || '***********************************************');
dbms_output.put_line('** COORDENADAS INVALIDAS **');
dbms_output.put_line('***********************************************');

   WHEN 6 THEN

dbms_output.put_line(chr(10) || '***********************************************');
dbms_output.put_line('** ALGO SALIO MAL Y NO TENGO IDEA DE QUE JAJAJA :) **');
dbms_output.put_line('***********************************************');

   END CASE;

pr_mostrar_jug_mueve;

END IF;
END;
/
