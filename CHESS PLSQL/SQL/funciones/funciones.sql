CREATE OR REPLACE FUNCTION fn_validar_coordenadas(coorInicio VARCHAR2, coorFin VARCHAR2) RETURN NUMBER IS

	numReturn NUMBER(1) := 1;
	coordenada VARCHAR2(2);
	letraCoordenada CHAR(1);

BEGIN

	FOR i IN 1..2 LOOP

		IF i = 1 THEN

			coordenada := coorInicio;

		ELSE

			coordenada := coorFin;

		END IF;


		FOR j IN 1..LENGTH(coordenada) LOOP

			letraCoordenada := SUBSTR(coordenada, j, 1);
			
			IF j = 1 THEN

				letraCoordenada := UPPER(letraCoordenada);

				IF numReturn = 1 AND letraCoordenada = 'A' OR letraCoordenada = 'B' OR letraCoordenada = 'C' OR letraCoordenada = 'D' 
				OR letraCoordenada = 'E' OR letraCoordenada = 'F' OR letraCoordenada = 'G' OR letraCoordenada = 'H' THEN

					numReturn := 1;

				ELSE

					numReturn := 0;

				END IF;

			ELSE

				IF numReturn = 1 AND letraCoordenada = '1' OR letraCoordenada = '2' OR letraCoordenada = '3' OR letraCoordenada = '4' OR
				letraCoordenada = '5' OR letraCoordenada = '6' OR letraCoordenada = '7' OR letraCoordenada = '8' THEN

					numReturn := 1;

				ELSE

					numReturn := 0;

				END IF;

			END IF;

		END LOOP;

	END LOOP;

	RETURN numReturn;

END fn_validar_coordenadas;
/

CREATE OR REPLACE FUNCTION fn_cambiar_a_minuscula(coor VARCHAR2) RETURN VARCHAR2 IS

	letra CHAR(1);
	coorReturn VARCHAR2(2);

BEGIN

	FOR i IN 1..LENGTH(coor) LOOP

		letra := SUBSTR(coor, i, 1);

		IF i = 1 THEN

			letra := LOWER(letra);

			coorReturn := letra;

		ELSE

			coorReturn := coorReturn || letra;

		END IF;

	END LOOP;

	RETURN coorReturn;

END fn_cambiar_a_minuscula;
/

CREATE OR REPLACE FUNCTION fn_val_cont_coordenadas(coorInicio VARCHAR2, coorFin VARCHAR2, colorMueve VARCHAR2) RETURN NUMBER IS
	numReturn NUMBER := 1;
	idPiezaTabPie tbl_tableros_piezas.pieza_coordenada%TYPE;

	colorMueveTemp VARCHAR2(10);

	letra CHAR(1);

BEGIN

	SELECT id_pieza
	INTO idPiezaTabPie
	FROM tbl_tableros_piezas
	WHERE coordenada = coorInicio;

	IF idPiezaTabPie <> '00' THEN

		SELECT tipo
		INTO colorMueveTemp
		FROM tbl_piezas
		WHERE id_pieza = idPiezaTabPie;

		IF colorMueve = colorMueveTemp THEN

			numReturn := 1;

		ELSE

			numReturn := 0;

		END IF;

	ELSE

		numReturn := 0;

	END IF;

	IF numReturn = 1 THEN

		SELECT id_pieza
		INTO idPiezaTabPie
		FROM tbl_tableros_piezas
		WHERE coordenada = coorFin;

		IF idPiezaTabPie = '00' THEN

			numReturn := 1;

		ELSE

			SELECT tipo
			INTO colorMueveTemp
			FROM tbl_piezas
			WHERE id_pieza = idPiezaTabPie;

			IF colorMueve <> colorMueveTemp THEN

				numReturn := 1;

			ELSE

				numReturn := 0;

			END IF;
		END IF;		
	END IF;

	RETURN numReturn;

END fn_val_cont_coordenadas;
/

CREATE OR REPLACE FUNCTION fn_ret_nom_pieza_coor(coor VARCHAR2) RETURN VARCHAR2 IS

	nombrePieza tbl_piezas.nombre%TYPE;

BEGIN

	SELECT nombre 
	INTO nombrePieza
	FROM tbl_piezas
	WHERE coordenada = coor;

	RETURN nombrePieza;

END;
/

CREATE OR REPLACE FUNCTION fn_verifi_movimiento(coorFin VARCHAR2) RETURN VARCHAR2 IS

	idPiezaTabPie tbl_tableros_piezas.pieza_coordenada%TYPE;
	accion VARCHAR2(5);

BEGIN

	SELECT id_pieza
	INTO idPiezaTabPie
	FROM tbl_tableros_piezas
	WHERE coordenada = coorFin;

	IF idPiezaTabPie = '00' THEN

		accion := 'mover';

	ELSE
	
		accion := 'comer';

	END IF;

	RETURN accion;
END fn_verifi_movimiento;
/

CREATE OR REPLACE FUNCTION fn_verifi_trayec_mov_peon(coorInicio VARCHAR2, coorFin VARCHAR2, tipoPieza VARCHAR2) RETURN NUMBER IS

	result NUMBER(1) := 0;

	ejeYInicio CHAR(1);
	ejeXInicio NUMBER(1);

	ejeYFin CHAR(1);
	ejeXFin NUMBER(1); 

BEGIN

	ejeYInicio := SUBSTR(coorInicio, 1, 1);
	ejeYInicio := UPPER(ejeYInicio);
	ejeXInicio := SUBSTR(coorInicio, 2, 1);

	ejeYFin := SUBSTR(coorFin, 1, 1);
	ejeYFin := UPPER(ejeYFin);
	ejeXFin := SUBSTR(coorFin, 2, 1);
	
	IF ejeYInicio = ejeYFin THEN

		IF tipoPieza = 'blanca' THEN	

			IF ejeXInicio = (ejeXFin - 1) THEN

				result := 1;

			ELSE

				IF ejeXInicio = 2 AND ejeXFin = 4 THEN

					result := 1;

				END IF;
			END IF;

		ELSE

			IF ejeXInicio = (ejeXFin + 1) THEN

				result := 1;

			ELSE

				IF ejeXInicio = 7 AND ejeXFin = 5 THEN

					result := 1;

				END IF;
			END IF;
		END IF;
	END IF;

	RETURN result;

END fn_verifi_trayec_mov_peon;
/

CREATE OR REPLACE FUNCTION fn_verifi_trayec_com_peon(coorInicio VARCHAR2, coorFin VARCHAR2, tipoPieza VARCHAR2) RETURN NUMBER IS

	result NUMBER(1) := 0;
	continuar NUMBER(1) := 0;

	ejeYInicio CHAR(1);
	ejeXInicio NUMBER(1);

	ejeYFin CHAR(1);
	ejeXFin NUMBER(1); 

BEGIN

	ejeYInicio := SUBSTR(coorInicio, 1, 1);
	ejeYInicio := UPPER(ejeYInicio);
	ejeXInicio := SUBSTR(coorInicio, 2, 1);

	ejeYFin := SUBSTR(coorFin, 1, 1);
	ejeYFin := UPPER(ejeYFin);
	ejeXFin := SUBSTR(coorFin, 2, 1);
	
	IF ejeYInicio <> ejeYFin THEN

		CASE ejeYInicio

			WHEN 'A' THEN

				IF ejeYFin = 'B' THEN

					continuar := 1;

				END IF;

			WHEN 'B' THEN

				IF ejeYFin = 'A' OR ejeYFin = 'C' THEN

					continuar := 1;

				END IF;

			WHEN 'C' THEN

				IF ejeYFin = 'B' OR ejeYFin = 'D' THEN

					continuar := 1;

				END IF;

			WHEN 'D' THEN

				IF ejeYFin = 'C' OR ejeYFin = 'E' THEN

					continuar := 1;

				END IF;

			WHEN 'E' THEN

				IF ejeYFin = 'D' OR ejeYFin = 'F' THEN

					continuar := 1;

				END IF;

			WHEN 'F' THEN

				IF ejeYFin = 'E' OR ejeYFin = 'G' THEN

					continuar := 1;

				END IF;

			WHEN 'G' THEN

				IF ejeYFin = 'F' OR ejeYFin = 'H' THEN

					continuar := 1;

				END IF;

			WHEN 'H' THEN
				
				IF ejeYFin = 'G' THEN

					continuar := 1;

				END IF;

		END CASE;

		IF continuar = 1 THEN

			IF tipoPieza = 'blanca' THEN	

				IF ejeXInicio = (ejeXFin - 1) THEN

					result := 1;

				END IF;

			ELSE

				IF ejeXInicio = (ejeXFin + 1) THEN

					result := 1;

				END IF;
				
			END IF;

		END IF;

	END IF;

	RETURN result;

END fn_verifi_trayec_com_peon;
/

CREATE OR REPLACE FUNCTION fn_tipo_pieza_mueve(idJugadorMueve NUMBER) RETURN VARCHAR2 IS

	colorPiezaJug VARCHAR2(10);

BEGIN

	SELECT tipo_pieza
	INTO colorPiezaJug
	FROM tbl_jugadores
	WHERE id_jugador = idJugadorMueve;

	IF colorPiezaJug = 'Blancas' THEN

		colorPiezaJug := 'blanca';

	ELSE

		colorPiezaJug := 'negra';

	END IF;

	RETURN colorPiezaJug;

END fn_tipo_pieza_mueve;
/

CREATE OR REPLACE FUNCTION fn_jug_mueve RETURN NUMBER IS

	idJugMueve tbl_jugadores_piezas.id_jugador%TYPE;

BEGIN

	SELECT DISTINCT(id_jugador)
	INTO idJugMueve
	FROM tbl_jugadores_piezas
	WHERE mueve = 1;

	RETURN idJugMueve;

END fn_jug_mueve;
/

CREATE OR REPLACE FUNCTION fn_jug_no_mueve RETURN NUMBER IS

	idJugNoMueve tbl_jugadores_piezas.id_jugador%TYPE;

BEGIN

	SELECT DISTINCT(id_jugador)
	INTO idJugNoMueve
	FROM tbl_jugadores_piezas
	WHERE mueve = 0;

	RETURN idJugNoMueve;

END fn_jug_no_mueve;
/

CREATE OR REPLACE FUNCTION fn_verifi_trayec_vertical(ejeYInicio CHAR, ejeXInicio NUMBER, ejeXFin NUMBER) RETURN NUMBER IS

	result NUMBER(1) := 1;

	coorTemp VARCHAR2(2);

	idPiezaTemp tbl_tableros_piezas.id_pieza%TYPE;

	CURSOR verifi_cont_coor(coor VARCHAR2) IS
		SELECT id_pieza
		FROM tbl_tableros_piezas
		WHERE coordenada = coor;

BEGIN

	IF ejeXInicio < ejeXFin THEN

		FOR i IN (ejeXInicio + 1)..ejeXFin LOOP

			IF i <> ejeXFin THEN

				coorTemp := ejeYInicio || TO_CHAR(i);

				OPEN verifi_cont_coor(coorTemp);
					FETCH verifi_cont_coor INTO idPiezaTemp;

					IF idPiezaTemp <> '00' THEN

						result := 0;

					END IF;

				CLOSE verifi_cont_coor;

				EXIT WHEN result = 0;

			END IF;

		END LOOP;

	END IF;

	IF ejeXInicio > ejeXFin THEN

		FOR i IN ejeXFin..(ejeXInicio - 1) LOOP

			IF i <> ejeXFin THEN

				coorTemp := ejeYInicio || TO_CHAR(i);

				OPEN verifi_cont_coor(coorTemp);
					FETCH verifi_cont_coor INTO idPiezaTemp;

					IF idPiezaTemp <> '00' THEN

						result := 0;

					END IF;

				CLOSE verifi_cont_coor;

				EXIT WHEN result = 0;

			END IF;

		END LOOP;

	END IF;	

	RETURN result;

END fn_verifi_trayec_vertical;
/

CREATE OR REPLACE FUNCTION fn_verifi_trayec_horizontal(ejeYInicio CHAR, ejeYFin CHAR, ejeXInicio NUMBER) RETURN NUMBER IS

	result NUMBER(1) := 1;

BEGIN

	CASE ejeYInicio

		WHEN 'a' THEN

			CASE ejeYFin

				WHEN 'c' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'b');

				WHEN 'd' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'b');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'c');

					END IF;

				WHEN 'e' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'b');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'c');

						IF result <> 0 THEN
							result := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

						END IF;
					END IF;

				WHEN 'f' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'b');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'c');

						IF result <> 0 THEN
							result := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

							IF result <> 0 THEN
								result := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

							END IF;
						END IF;
					END IF;

				WHEN 'g' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'b');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'c');

						IF result <> 0 THEN
							result := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

							IF result <> 0 THEN
								result := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

								IF result <> 0 THEN
									result := fn_verifi_coor_x_por_y(ejeXInicio, 'f');

								END IF;
							END IF;
						END IF;
					END IF;
					
				WHEN 'h' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'b');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'c');

						IF result <> 0 THEN
							result := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

							IF result <> 0 THEN
								result := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

								IF result <> 0 THEN
									result := fn_verifi_coor_x_por_y(ejeXInicio, 'f');

									IF result <> 0 THEN
										result := fn_verifi_coor_x_por_y(ejeXInicio, 'g');

									END IF;
								END IF;
							END IF;
						END IF;
					END IF;

				ELSE

					result := 1;

			END CASE;

		WHEN 'b' THEN

			CASE ejeYFin

				WHEN 'd' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'c');

				WHEN 'e' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'c');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

					END IF;

				WHEN 'f' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'c');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

						IF result <> 0 THEN
							result := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

						END IF;
					END IF;


				WHEN 'g' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'c');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

						IF result <> 0 THEN
							result := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

							IF result <> 0 THEN
								result := fn_verifi_coor_x_por_y(ejeXInicio, 'f');

							END IF;
						END IF;
					END IF;

				WHEN 'h' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'c');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

						IF result <> 0 THEN
							result := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

							IF result <> 0 THEN
								result := fn_verifi_coor_x_por_y(ejeXInicio, 'f');

								IF result <> 0 THEN
									result := fn_verifi_coor_x_por_y(ejeXInicio, 'g');

								END IF;
							END IF;
						END IF;
					END IF;

				ELSE

					result := 1;

			END CASE;

		WHEN 'c' THEN

			CASE ejeYFin
				WHEN 'a' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'b');

				WHEN 'e' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

				WHEN 'f' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

					END IF;

				WHEN 'g' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

						IF result <> 0 THEN
							result := fn_verifi_coor_x_por_y(ejeXInicio, 'f');

						END IF;
					END IF;

				WHEN 'h' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

						IF result <> 0 THEN
							result := fn_verifi_coor_x_por_y(ejeXInicio, 'f');

							IF result <> 0 THEN
								result := fn_verifi_coor_x_por_y(ejeXInicio, 'g');

							END IF;
						END IF;
					END IF;

				ELSE

					result := 1;

			END CASE;

		WHEN 'd' THEN

			CASE ejeYFin

				WHEN 'a' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'b');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'c');

					END IF;

				WHEN 'b' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'c');

				WHEN 'f' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

				WHEN 'g' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'f');

					END IF;

				WHEN 'h' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'f');

						IF result <> 0 THEN
							result := fn_verifi_coor_x_por_y(ejeXInicio, 'g');

						END IF;
					END IF;

				ELSE

					result := 1;

			END CASE;

		WHEN 'e' THEN

			CASE ejeYFin

				WHEN 'a' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'b');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'c');

						IF result <> 0 THEN
							result := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

						END IF;
					END IF;

				WHEN 'b' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'c');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

					END IF;

				WHEN 'c' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

				WHEN 'g' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'f');

				WHEN 'h' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'f');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'g');

					END IF;

				ELSE

					result := 1;

			END CASE;

		WHEN 'f' THEN

			CASE ejeYFin

				WHEN 'a' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'b');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'c');

						IF result <> 0 THEN
							result := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

							IF result <> 0 THEN
								result := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

							END IF;
						END IF;
					END IF;

				WHEN 'b' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'c');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

						IF result <> 0 THEN
							result := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

						END IF;
					END IF;						

				WHEN 'c' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

					END IF;

				WHEN 'd' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'e');
				
				WHEN 'h' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'g');

				ELSE

					result := 1;

			END CASE;

		WHEN 'g' THEN

			CASE ejeYFin

				WHEN 'a' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'b');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'c');

						IF result <> 0 THEN
							result := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

							IF result <> 0 THEN
								result := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

								IF result <> 0 THEN
									result := fn_verifi_coor_x_por_y(ejeXInicio, 'f');

								END IF;
							END IF;
						END IF;
					END IF;

				WHEN 'b' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'c');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

						IF result <> 0 THEN
							result := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

							IF result <> 0 THEN
								result := fn_verifi_coor_x_por_y(ejeXInicio, 'f');

							END IF;
						END IF;
					END IF;

				WHEN 'c' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

						IF result <> 0 THEN
							result := fn_verifi_coor_x_por_y(ejeXInicio, 'f');

						END IF;
					END IF;	

				WHEN 'd' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'f');

					END IF;

				WHEN 'e' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'f');

				ELSE

					result := 1;
					
			END CASE;

		WHEN 'h' THEN

			CASE ejeYFin

				WHEN 'a' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'b');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'c');

						IF result <> 0 THEN
							result := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

							IF result <> 0 THEN
								result := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

								IF result <> 0 THEN
									result := fn_verifi_coor_x_por_y(ejeXInicio, 'f');

									IF result <> 0 THEN
										result := fn_verifi_coor_x_por_y(ejeXInicio, 'g');

									END IF;
								END IF;
							END IF;
						END IF;
					END IF;

				WHEN 'b' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'c');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

						IF result <> 0 THEN
							result := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

							IF result <> 0 THEN
								result := fn_verifi_coor_x_por_y(ejeXInicio, 'f');

								IF result <> 0 THEN
									result := fn_verifi_coor_x_por_y(ejeXInicio, 'g');

								END IF;
							END IF;
						END IF;
					END IF;

				WHEN 'c' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

						IF result <> 0 THEN
							result := fn_verifi_coor_x_por_y(ejeXInicio, 'f');

							IF result <> 0 THEN
								result := fn_verifi_coor_x_por_y(ejeXInicio, 'g');

							END IF;
						END IF;
					END IF;

				WHEN 'd' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'f');

						IF result <> 0 THEN
							result := fn_verifi_coor_x_por_y(ejeXInicio, 'g');

						END IF;
					END IF;	

				WHEN 'e' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'f');

					IF result <> 0 THEN
						result := fn_verifi_coor_x_por_y(ejeXInicio, 'g');

					END IF;

				WHEN 'f' THEN

					result := fn_verifi_coor_x_por_y(ejeXInicio, 'g');

				ELSE

				result := 1;

			END CASE;

		ELSE

		result := 1;

	END CASE;

	RETURN result;

END fn_verifi_trayec_horizontal;
/

CREATE OR REPLACE FUNCTION fn_verifi_coor_x_por_y(coorX NUMBER, coorY CHAR) RETURN NUMBER IS

	coor VARCHAR2(2);
	idPieza tbl_tableros_piezas.id_pieza%TYPE;

	result NUMBER := 0;

BEGIN

	coor := coorY || TO_CHAR(coorX);

	SELECT id_pieza
	INTO idPieza
	FROM tbl_tableros_piezas
	WHERE coordenada = coor;

	IF idPieza = '00' THEN

		result := 1;

	END IF;

	RETURN result;

END fn_verifi_coor_x_por_y;
/

CREATE OR REPLACE FUNCTION fn_verifi_trayec_mov_torre(coorInicio VARCHAR2, coorFin VARCHAR2) RETURN NUMBER IS

	result NUMBER(1) := 0;

	ejeYInicio CHAR(1);
	ejeYFin CHAR(1);

	ejeXFin NUMBER(1); 
	ejeXInicio NUMBER(1);

BEGIN

	ejeYInicio := SUBSTR(coorInicio, 1, 1);
	ejeYFin := SUBSTR(coorFin, 1, 1);
	ejeYInicio := LOWER(ejeYInicio);
	ejeYFin := LOWER(ejeYFin);

	ejeXInicio := SUBSTR(coorInicio, 2, 1);
	ejeXFin := SUBSTR(coorFin, 2, 1);
	
	IF ejeYInicio = ejeYFin OR ejeXInicio = ejeXFin THEN

		IF ejeXInicio > ejeXFin OR ejeXInicio < ejeXFin THEN

			result := fn_verifi_trayec_vertical(ejeYInicio, ejeXInicio, ejeXFin);

		END IF;

		IF ejeXInicio = ejeXFin THEN

			result := fn_verifi_trayec_horizontal(ejeYInicio, ejeYFin, ejeXInicio);

		END IF;

	END IF;

	RETURN result;

END fn_verifi_trayec_mov_torre;
/

CREATE OR REPLACE FUNCTION fn_verifi_trayec_y_pos_caballo(ejeXInicio NUMBER, ejeXFin NUMBER, ejeYInicio CHAR) RETURN NUMBER IS

	continuar NUMBER(1);
	result NUMBER(1) := 1;
	cantPiezas NUMBER(1) := 0;

BEGIN

	IF ejeXInicio < ejeXFin THEN

		FOR i IN (ejeXInicio + 1)..ejeXFin LOOP

			continuar := fn_verifi_coor_x_por_y(i, ejeYInicio);

			IF continuar = 0 THEN

				cantPiezas := cantPiezas + 1;

			END IF;

			IF i = ejeXFin AND cantPiezas = 2 THEN

				result := 0;

			END IF;

		END LOOP;

	END IF;

	IF ejeXInicio > ejeXFin THEN

		FOR i IN ejeXFin..(ejeXInicio - 1) LOOP

			continuar := fn_verifi_coor_x_por_y(i, ejeYInicio);

			IF continuar = 0 THEN

				cantPiezas := cantPiezas + 1;

			END IF;

			IF i = (ejeXInicio - 1) AND cantPiezas = 2 THEN

				result := 0;

			END IF;

		END LOOP;

	END IF;	

	RETURN result;

END fn_verifi_trayec_y_pos_caballo;
/

CREATE OR REPLACE FUNCTION fn_verifi_trayec_x_pos_caballo(ejeXInicio NUMBER, ejeYInicio CHAR, ejeYFin CHAR) RETURN NUMBER IS

	result NUMBER(1) := 0;
	continuar NUMBER(1);

	cantPiezas NUMBER(1) := 0;

BEGIN

	CASE ejeYInicio

		WHEN 'a' THEN

			continuar := fn_verifi_coor_x_por_y(ejeXInicio, 'b');

			IF continuar = 1 THEN

				result := 1;

			ELSE

				continuar := fn_verifi_coor_x_por_y(ejeXInicio, 'c');

				IF continuar = 1 THEN

					result := 1;

				END IF;

			END IF;

		WHEN 'b' THEN

			continuar := fn_verifi_coor_x_por_y(ejeXInicio, 'c');

			IF continuar = 1 THEN

				result := 1;

			ELSE

				continuar := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

				IF continuar = 1 THEN

					result := 1;

				END IF;

			END IF;

		WHEN 'c' THEN

			IF ejeYFin = 'a' THEN

				continuar := fn_verifi_coor_x_por_y(ejeXInicio, 'a');

				IF continuar = 1 THEN

					result := 1;

				ELSE

					continuar := fn_verifi_coor_x_por_y(ejeXInicio, 'b');

					IF continuar = 1 THEN

						result := 1;

					END IF;

				END IF;

			END IF;

			IF ejeYFin = 'e' THEN

				continuar := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

				IF continuar = 1 THEN

					result := 1;

				ELSE

					continuar := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

					IF continuar = 1 THEN

						result := 1;

					END IF;

				END IF;

			END IF;


		WHEN 'd' THEN

			IF ejeYFin = 'b' THEN

				continuar := fn_verifi_coor_x_por_y(ejeXInicio, 'b');

				IF continuar = 1 THEN

					result := 1;

				ELSE

					continuar := fn_verifi_coor_x_por_y(ejeXInicio, 'c');

					IF continuar = 1 THEN

						result := 1;

					END IF;

				END IF;

			END IF;

			IF ejeYFin = 'f' THEN

				continuar := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

				IF continuar = 1 THEN

					result := 1;

				ELSE

					continuar := fn_verifi_coor_x_por_y(ejeXInicio, 'f');

					IF continuar = 1 THEN

						result := 1;

					END IF;

				END IF;

			END IF;

		WHEN 'e' THEN

			IF ejeYFin = 'c' THEN

				continuar := fn_verifi_coor_x_por_y(ejeXInicio, 'c');

				IF continuar = 1 THEN

					result := 1;

				ELSE

					continuar := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

					IF continuar = 1 THEN

						result := 1;

					END IF;

				END IF;

			END IF;

			IF ejeYFin = 'g' THEN

				continuar := fn_verifi_coor_x_por_y(ejeXInicio, 'f');

				IF continuar = 1 THEN

					result := 1;

				ELSE

					continuar := fn_verifi_coor_x_por_y(ejeXInicio, 'g');

					IF continuar = 1 THEN

						result := 1;

					END IF;

				END IF;

			END IF;

		WHEN 'f' THEN

			IF ejeYFin = 'd' THEN

				continuar := fn_verifi_coor_x_por_y(ejeXInicio, 'd');

				IF continuar = 1 THEN

					result := 1;

				ELSE

					continuar := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

					IF continuar = 1 THEN

						result := 1;

					END IF;

				END IF;

			END IF;

			IF ejeYFin = 'h' THEN

				continuar := fn_verifi_coor_x_por_y(ejeXInicio, 'h');

				IF continuar = 1 THEN

					result := 1;

				ELSE

					continuar := fn_verifi_coor_x_por_y(ejeXInicio, 'g');

					IF continuar = 1 THEN

						result := 1;

					END IF;

				END IF;

			END IF;

		WHEN 'g' THEN

			continuar := fn_verifi_coor_x_por_y(ejeXInicio, 'e');

			IF continuar = 1 THEN

				result := 1;

			ELSE

				continuar := fn_verifi_coor_x_por_y(ejeXInicio, 'f');

				IF continuar = 1 THEN

					result := 1;

				END IF;

			END IF;

		WHEN 'h' THEN

			continuar := fn_verifi_coor_x_por_y(ejeXInicio, 'f');

			IF continuar = 1 THEN

				result := 1;

			ELSE

				continuar := fn_verifi_coor_x_por_y(ejeXInicio, 'g');

				IF continuar = 1 THEN

					result := 1;

				END IF;

			END IF;

		ELSE

		result := 1;

	END CASE;

	RETURN result;

END fn_verifi_trayec_x_pos_caballo;
/

CREATE OR REPLACE FUNCTION fn_verifi_trayec_mov_caballo(coorInicio VARCHAR2, coorFin VARCHAR2) RETURN NUMBER IS

	result NUMBER(1) := 0;
	continuar NUMBER(1) := 0;

	ejeYInicio CHAR(1);
	ejeYFin CHAR(1);

	ejeXFin NUMBER(1); 
	ejeXInicio NUMBER(1);

BEGIN

	ejeYInicio := SUBSTR(coorInicio, 1, 1);
	ejeYFin := SUBSTR(coorFin, 1, 1);
	ejeYInicio := LOWER(ejeYInicio);
	ejeYFin := LOWER(ejeYFin);

	ejeXInicio := SUBSTR(coorInicio, 2, 1);
	ejeXFin := SUBSTR(coorFin, 2, 1);

	IF ejeYInicio <> ejeYFin OR ejeXInicio <> ejeXFin THEN

		IF ejeXInicio = (ejeXFin - 2) OR ejeXInicio = (ejeXFin + 2) THEN

			continuar := fn_verifi_trayec_y_pos_caballo(ejeXInicio, ejeXFin, ejeYInicio);

			IF continuar = 1 THEN

				CASE ejeYInicio

					WHEN 'a' THEN

						IF ejeYFin = 'b' THEN

							result := 1;

						END IF;

					WHEN 'b' THEN

						IF ejeYFin = 'a' OR ejeYFin = 'c' THEN

							result := 1;

						END IF;

					WHEN 'c' THEN

						IF ejeYFin = 'b' OR ejeYFin = 'd' THEN

							result := 1;

						END IF;

					WHEN 'd' THEN

						IF ejeYFin = 'c' OR ejeYFin = 'e' THEN

							result := 1;

						END IF;

					WHEN 'e' THEN

						IF ejeYFin = 'd' OR ejeYFin = 'f' THEN

							result := 1;

						END IF;

					WHEN 'f' THEN

						IF ejeYFin = 'e' OR ejeYFin = 'g' THEN

							result := 1;

						END IF;

					WHEN 'g' THEN

						IF ejeYFin = 'f' OR ejeYFin = 'h' THEN

							result := 1;

						END IF;

					WHEN 'h' THEN

						IF ejeYFin = 'g' THEN

							result := 1;

						END IF;

					ELSE

					result := 1;

				END CASE;

			END IF;

		END IF;	

		IF ejeXInicio = (ejeXFin - 1) OR ejeXInicio = (ejeXFin + 1) THEN

			continuar := fn_verifi_trayec_x_pos_caballo(ejeXInicio, ejeYInicio, ejeYFin);

			IF continuar = 1 THEN

				CASE ejeYInicio

					WHEN 'a' THEN

						IF ejeYFin = 'c' THEN

							result := 1;

						END IF;

					WHEN 'b' THEN

						IF ejeYFin = 'd' THEN

							result := 1;

						END IF;

					WHEN 'c' THEN

						IF ejeYFin = 'e' OR ejeYFin = 'a' THEN

							result := 1;

						END IF;

					WHEN 'd' THEN

						IF ejeYFin = 'b' OR ejeYFin = 'f' THEN

							result := 1;

						END IF;

					WHEN 'e' THEN

						IF ejeYFin = 'c' OR ejeYFin = 'g' THEN

							result := 1;

						END IF;

					WHEN 'f' THEN

						IF ejeYFin = 'd' OR ejeYFin = 'h' THEN

							result := 1;

						END IF;

					WHEN 'g' THEN

						IF ejeYFin = 'e' THEN

							result := 1;

						END IF;

					WHEN 'h' THEN

						IF ejeYFin = 'f' THEN

							result := 1;

						END IF;

					ELSE

					result := 1;

				END CASE;			

			END IF;

		END IF;

	END IF;	

	RETURN result;

END fn_verifi_trayec_mov_caballo;
/

CREATE OR REPLACE FUNCTION fn_verifi_direccion(ejeYInicio CHAR, ejeYFin CHAR) RETURN CHAR IS

	direccion CHAR(1);

BEGIN

	CASE ejeYInicio

		WHEN 'a' THEN

			direccion := 'D';

		WHEN 'h' THEN

			direccion := 'I';

		WHEN 'b' THEN

			IF ejeYFin = 'a' THEN

				direccion := 'I';

			ELSE

				direccion := 'D';

			END IF;

		WHEN 'c' THEN

			IF ejeYFin = 'a' OR ejeYFin = 'b' THEN

				direccion := 'I';

			ELSE

				direccion := 'D';

			END IF;

		WHEN 'd' THEN

			IF ejeYFin = 'a' OR ejeYFin = 'b' OR ejeYFin = 'c' THEN

				direccion := 'I';

			ELSE

				direccion := 'D';

			END IF;

		WHEN 'e' THEN

			IF ejeYFin = 'f' OR ejeYFin = 'g' OR ejeYFin = 'h' THEN

				direccion := 'D';

			ELSE

				direccion := 'I';

			END IF;

		WHEN 'f' THEN

			IF ejeYFin = 'g' OR ejeYFin = 'h' THEN

				direccion := 'D';

			ELSE

				direccion := 'I';

			END IF;

		WHEN 'g' THEN

			IF ejeYFin = 'h' THEN

				direccion := 'D';

			ELSE

				direccion := 'I';

			END IF;

		ELSE

			direccion := 'N';

	END CASE;

	RETURN direccion;

END fn_verifi_direccion;
/

CREATE OR REPLACE FUNCTION fn_aumentar_letra(letraY CHAR) RETURN CHAR IS

	letra CHAR(1);

BEGIN

	CASE letraY

		WHEN 'a' THEN

			letra := 'b';

		WHEN 'b' THEN

			letra := 'c';

		WHEN 'c' THEN

			letra := 'd';

		WHEN 'd' THEN

			letra := 'e';

		WHEN 'e' THEN

			letra := 'f';

		WHEN 'f' THEN

			letra := 'g';

		WHEN 'g' THEN

			letra := 'h';

		ELSE

			letra := 'N';

	END CASE;

	RETURN letra;

END fn_aumentar_letra;
/

CREATE OR REPLACE FUNCTION fn_disminuir_letra(letraY CHAR) RETURN CHAR IS

	letra CHAR(1);

BEGIN

	CASE letraY

		WHEN 'h' THEN

			letra := 'g';

		WHEN 'g' THEN

			letra := 'f';

		WHEN 'f' THEN

			letra := 'e';

		WHEN 'e' THEN

			letra := 'd';

		WHEN 'd' THEN

			letra := 'c';

		WHEN 'c' THEN

			letra := 'b';

		WHEN 'b' THEN

			letra := 'a';

		ELSE

			letra := 'N';

	END CASE;

	RETURN letra;

END fn_disminuir_letra;
/

CREATE OR REPLACE FUNCTION fn_mov_alfil_mayor_D(ejeYInicio CHAR, ejeYFin CHAR, ejeXInicio NUMBER, ejeXFin NUMBER) RETURN NUMBER IS

	letra CHAR(1);
	continuar NUMBER(1);
	result NUMBER(1) := 1;

BEGIN

	letra := ejeYInicio;

	IF (ejeXInicio + 1) <> ejeXFin THEN

		FOR i IN (ejeXInicio + 1)..ejeXFin LOOP

			letra := fn_aumentar_letra(letra);

			IF letra = 'N' THEN

				RETURN 0;

			END IF;

			IF i <> ejeXFin THEN

				continuar := fn_verifi_coor_x_por_y(i, letra);

				IF continuar = 0 THEN

					RETURN 0;

				END IF;

			ELSE

				IF letra <> ejeYFin THEN

					RETURN 0;

				END IF;

			END IF;

		END LOOP;

	END IF;

	RETURN result;

END fn_mov_alfil_mayor_D;
/

CREATE OR REPLACE FUNCTION fn_mov_alfil_mayor_I(ejeYInicio CHAR, ejeYFin CHAR, ejeXInicio NUMBER, ejeXFin NUMBER) RETURN NUMBER IS

	letra CHAR(1);
	continuar NUMBER(1);
	result NUMBER(1) := 1;

BEGIN

	letra := ejeYInicio;

	IF (ejeXInicio + 1) <> ejeXFin THEN

		FOR i IN (ejeXInicio + 1)..ejeXFin LOOP

			letra := fn_disminuir_letra(letra);

			IF letra = 'N' THEN

				RETURN 0;

			END IF;

			IF i <> ejeXFin THEN

				continuar := fn_verifi_coor_x_por_y(i, letra);

				IF continuar = 0 THEN

					RETURN 0;

				END IF;

			ELSE

				IF letra <> ejeYFin THEN

					RETURN 0;

				END IF;

			END IF;

		END LOOP;

	END IF;

	RETURN result;

END fn_mov_alfil_mayor_I;
/

CREATE OR REPLACE FUNCTION fn_mov_alfil_menor_I(ejeYInicio CHAR, ejeYFin CHAR, ejeXInicio NUMBER, ejeXFin NUMBER) RETURN NUMBER IS

	letra CHAR(1);
	continuar NUMBER(1);
	result NUMBER(1) := 1;

	num NUMBER(2);

BEGIN

	letra := ejeYFin;

	IF (ejeXInicio - 1) <> ejeXFin THEN

		FOR i IN (ejeXFin + 1)..ejeXInicio LOOP

			letra := fn_aumentar_letra(letra);

			IF letra = 'N' THEN  

				RETURN 0;

			END IF;

			IF i <> ejeXInicio THEN

				continuar := fn_verifi_coor_x_por_y(i, letra);

				IF continuar = 0 THEN

					RETURN 0;

				END IF;

			ELSE

				IF letra <> ejeYInicio THEN

					RETURN 0;

				END IF;

			END IF;

		END LOOP;

	END IF;

	RETURN result;

END fn_mov_alfil_menor_I;
/

CREATE OR REPLACE FUNCTION fn_mov_alfil_menor_D(ejeYInicio CHAR, ejeYFin CHAR, ejeXInicio NUMBER, ejeXFin NUMBER) RETURN NUMBER IS

	letra CHAR(1);
	continuar NUMBER(1);
	result NUMBER(1) := 1;

BEGIN

	letra := ejeYFin;

	IF (ejeXInicio - 1) <> ejeXFin THEN

		FOR i IN (ejeXFin + 1)..ejeXInicio LOOP

			letra := fn_disminuir_letra(letra);

			IF letra = 'N' THEN  

				RETURN 0;

			END IF;

			IF i <> ejeXInicio THEN

				continuar := fn_verifi_coor_x_por_y(i, letra);

				IF continuar = 0 THEN

					RETURN 0;

				END IF;

			ELSE

				IF letra <> ejeYInicio THEN

					RETURN 0;

				END IF;

			END IF;

		END LOOP;

	END IF;

	RETURN result;

END fn_mov_alfil_menor_D;
/

CREATE OR REPLACE FUNCTION verifi_trayec_diagonal(ejeYInicio CHAR, ejeYFin CHAR, ejeXInicio NUMBER, ejeXFin NUMBER) RETURN NUMBER IS

	direccion CHAR(1);
	continuar NUMBER(1);

	result NUMBER(1) := 0;

BEGIN

	direccion := fn_verifi_direccion(ejeYInicio, ejeYFin);

	IF ejeXInicio < ejeXFin THEN

		IF direccion = 'D' THEN

			continuar := fn_mov_alfil_mayor_D(ejeYInicio, ejeYFin, ejeXInicio, ejeXFin);

			IF continuar = '1' THEN

				result := 1;

			END IF;

		ELSE

			continuar := fn_mov_alfil_mayor_I(ejeYInicio, ejeYFin, ejeXInicio, ejeXFin);

			IF continuar = '1' THEN

				result := 1;

			END IF;
		END IF;

	ELSE

		IF direccion = 'D' THEN

			continuar := fn_mov_alfil_menor_D(ejeYInicio, ejeYFin, ejeXInicio, ejeXFin);

			IF continuar = '1' THEN

				result := 1;

			END IF;
		ELSE

			continuar := fn_mov_alfil_menor_I(ejeYInicio, ejeYFin, ejeXInicio, ejeXFin);

			IF continuar = '1' THEN

				result := 1;

			END IF;
		END IF;	
	END IF;

	RETURN result;

END verifi_trayec_diagonal;
/

CREATE OR REPLACE FUNCTION fn_verifi_trayec_mov_alfil(coorInicio VARCHAR2, coorFin VARCHAR2) RETURN NUMBER IS

	result NUMBER(1) := 0;
	continuar NUMBER(1);

	ejeYInicio CHAR(1);
	ejeYFin CHAR(1);

	ejeXFin NUMBER(1); 
	ejeXInicio NUMBER(1);

BEGIN

	ejeYInicio := SUBSTR(coorInicio, 1, 1);
	ejeYFin := SUBSTR(coorFin, 1, 1);
	ejeYInicio := LOWER(ejeYInicio);
	ejeYFin := LOWER(ejeYFin);

	ejeXInicio := SUBSTR(coorInicio, 2, 1);
	ejeXFin := SUBSTR(coorFin, 2, 1);

	IF ejeYInicio <> ejeYFin AND ejeXInicio <> ejeXFin THEN

		continuar := verifi_trayec_diagonal(ejeYInicio, ejeYFin, ejeXInicio, ejeXFin);

		IF continuar = 1 THEN

			result := 1;

		END IF;

	END IF;

	RETURN result;

END fn_verifi_trayec_mov_alfil;
/

CREATE OR REPLACE FUNCTION fn_verifi_trayec_mov_rey(coorInicio VARCHAR2, coorFin VARCHAR2) RETURN NUMBER IS

	result NUMBER(1) := 0;
	continuar NUMBER(1);

	ejeYInicio CHAR(1);
	ejeYFin CHAR(1);

	ejeXFin NUMBER(1); 
	ejeXInicio NUMBER(1);

	direccion CHAR(1);
	ejeYTemp CHAR(1);

BEGIN

	ejeYInicio := SUBSTR(coorInicio, 1, 1);
	ejeYFin := SUBSTR(coorFin, 1, 1);
	ejeYInicio := LOWER(ejeYInicio);
	ejeYFin := LOWER(ejeYFin);

	ejeXInicio := SUBSTR(coorInicio, 2, 1);
	ejeXFin := SUBSTR(coorFin, 2, 1);

	IF ejeXInicio < ejeXFin THEN

		IF ejeYInicio = ejeYFin THEN

			IF (ejeXInicio + 1) = ejeXFin THEN

				result := 1;

			END IF;

		ELSE

			direccion := fn_verifi_direccion(ejeYInicio, ejeYFin);

			IF direccion = 'D' THEN

				ejeYTemp := fn_aumentar_letra(ejeYInicio);

				IF ejeYTemp = ejeYFin AND (ejeXInicio + 1) = ejeXFin THEN

					result := 1;

				END IF;

			ELSE

				ejeYTemp := fn_disminuir_letra(ejeYInicio);

				IF ejeYTemp = ejeYFin AND (ejeXInicio + 1) = ejeXFin THEN

					result := 1;

				END IF;

			END IF;

		END IF;

	END IF;

	IF ejeXInicio > ejeXFin THEN

		IF ejeYInicio = ejeYFin THEN

			IF (ejeXInicio - 1) = ejeXFin THEN

				result := 1;

			END IF;

		ELSE

			direccion := fn_verifi_direccion(ejeYInicio, ejeYFin);

			IF direccion = 'D' THEN

				ejeYTemp := fn_aumentar_letra(ejeYInicio);

				IF ejeYTemp = ejeYFin AND (ejeXInicio - 1) = ejeXFin THEN

					result := 1;

				END IF;

			ELSE

				ejeYTemp := fn_disminuir_letra(ejeYInicio);

				IF ejeYTemp = ejeYFin AND (ejeXInicio - 1) = ejeXFin THEN

					result := 1;

				END IF;

			END IF;

		END IF;

	END IF;

	IF ejeXInicio = ejeXFin THEN

		direccion := fn_verifi_direccion(ejeYInicio, ejeYFin);

		IF direccion = 'D' THEN

			ejeYTemp := fn_aumentar_letra(ejeYInicio);

			IF ejeYTemp = ejeYFin THEN

				result := 1;

			END IF;

		ELSE

			ejeYTemp := fn_disminuir_letra(ejeYInicio);

			IF ejeYTemp = ejeYFin THEN

				result := 1;

			END IF;

		END IF;

	END IF;

	RETURN result;

END fn_verifi_trayec_mov_rey;
/

CREATE OR REPLACE FUNCTION fn_verifi_tipo_movimiento(ejeYInicio CHAR, ejeYFin CHAR, ejeXInicio NUMBER, ejeXFin NUMBER) RETURN VARCHAR2 IS

	movimiento VARCHAR2(20);

BEGIN

	IF ejeYInicio = ejeYFin OR ejeXInicio = ejeXFin THEN

		IF ejeYInicio = ejeYFin THEN

			movimiento := 'vertical';

		END IF;

		IF ejeXInicio = ejeXFin THEN

			movimiento := 'horizontal';


		END IF;

	ELSE

		movimiento := 'diagonal';

	END IF;

	RETURN movimiento;

END fn_verifi_tipo_movimiento;
/

CREATE OR REPLACE FUNCTION fn_verifi_trayec_mov_dama(coorInicio VARCHAR2, coorFin VARCHAR2) RETURN NUMBER IS

	result NUMBER(1) := 0;
	continuar NUMBER(1);

	ejeYInicio CHAR(1);
	ejeYFin CHAR(1);

	ejeXFin NUMBER(1); 
	ejeXInicio NUMBER(1);

	movimiento VARCHAR2(20);

BEGIN

	ejeYInicio := SUBSTR(coorInicio, 1, 1);
	ejeYFin := SUBSTR(coorFin, 1, 1);
	ejeYInicio := LOWER(ejeYInicio);
	ejeYFin := LOWER(ejeYFin);

	ejeXInicio := SUBSTR(coorInicio, 2, 1);
	ejeXFin := SUBSTR(coorFin, 2, 1);

	movimiento := fn_verifi_tipo_movimiento(ejeYInicio, ejeYFin, ejeXInicio, ejeXFin);

	IF movimiento = 'vertical' THEN

		continuar := fn_verifi_trayec_vertical(ejeYInicio, ejeXInicio, ejeXFin);

	END IF;

	IF movimiento = 'horizontal' THEN

		continuar := fn_verifi_trayec_horizontal(ejeYInicio, ejeYFin, ejeXInicio);

	END IF;

	IF movimiento = 'diagonal' THEN

		continuar := verifi_trayec_diagonal(ejeYInicio, ejeYFin, ejeXInicio, ejeXFin);

	END IF;	

	IF continuar = 1 THEN

		result := 1;

	END IF;

	RETURN result;

END fn_verifi_trayec_mov_dama;
/

CREATE OR REPLACE FUNCTION fn_mover(coordInicio VARCHAR2, coordDestino VARCHAR2) RETURN NUMBER IS

	idJugadorMueve tbl_jugadores.id_jugador%TYPE;

	colorPiezaJug tbl_jugadores.tipo_pieza%TYPE;
	nombrePieza tbl_piezas.tipo%TYPE; 

	coordenadaInicio VARCHAR2(2);
	coordenadaDestino VARCHAR2(2);

	continuar NUMBER(1);
	accion VARCHAR2(5);

	result NUMBER(1);

BEGIN

	continuar := fn_validar_coordenadas(coordInicio, coordDestino);

	IF continuar = 1 THEN

		idJugadorMueve := fn_jug_mueve;

		colorPiezaJug := fn_tipo_pieza_mueve(idJugadorMueve);

		coordenadaInicio := fn_cambiar_a_minuscula(coordInicio);
		coordenadaDestino := fn_cambiar_a_minuscula(coordDestino);

		continuar := fn_val_cont_coordenadas(coordenadaInicio, coordenadaDestino, colorPiezaJug);

		IF continuar = 1 THEN

			nombrePieza := fn_ret_nom_pieza_coor(coordenadaInicio);

			accion := fn_verifi_movimiento(coordenadaDestino);

			CASE nombrePieza

				WHEN 'peon' THEN 

					IF accion = 'mover' THEN

						continuar := fn_verifi_trayec_mov_peon(coordenadaInicio, coordenadaDestino, colorPiezaJug);

						IF continuar = 1 THEN

							pr_mover_pieza(coordenadaInicio, coordenadaDestino);
							pr_registrar_movimiento(coordenadaInicio, coordenadaDestino, colorPiezaJug);

							pr_cambiar_jugador_mueve(idJugadorMueve);

							result := 1;

						ELSE

							result := 9;

						END IF;

					ELSE

						continuar := fn_verifi_trayec_com_peon(coordenadaInicio, coordenadaDestino, colorPiezaJug);

						IF continuar = 1 THEN

							pr_comer_pieza(coordenadaInicio, coordenadaDestino);
							pr_registrar_movimiento(coordenadaInicio, coordenadaDestino, colorPiezaJug);

							pr_cambiar_jugador_mueve(idJugadorMueve);

							result := 2;

						ELSE

							result := 9;

						END IF;

					END IF;

				WHEN 'torre' THEN 

					continuar := fn_verifi_trayec_mov_torre(coordenadaInicio, coordenadaDestino);

					IF accion = 'mover' AND continuar = 1 THEN

						pr_mover_pieza(coordenadaInicio, coordenadaDestino);
						pr_registrar_movimiento(coordenadaInicio, coordenadaDestino, colorPiezaJug);

						pr_cambiar_jugador_mueve(idJugadorMueve);

						result := 1;

					END IF;

					IF accion = 'comer' AND continuar = 1 THEN

						pr_comer_pieza(coordenadaInicio, coordenadaDestino);
						pr_registrar_movimiento(coordenadaInicio, coordenadaDestino, colorPiezaJug);

						pr_cambiar_jugador_mueve(idJugadorMueve);

						result := 2;
						
					END IF;
						
					IF continuar = 0 THEN

						result := 9;
						
					END IF;

				WHEN 'caballo' THEN

					continuar := fn_verifi_trayec_mov_caballo(coordenadaInicio, coordenadaDestino);

					IF accion = 'mover' AND continuar = 1 THEN

						pr_mover_pieza(coordenadaInicio, coordenadaDestino);
						pr_registrar_movimiento(coordenadaInicio, coordenadaDestino, colorPiezaJug);

						pr_cambiar_jugador_mueve(idJugadorMueve);

						result := 1;

					END IF;

					IF accion = 'comer' AND continuar = 1 THEN

						pr_comer_pieza(coordenadaInicio, coordenadaDestino);
						pr_registrar_movimiento(coordenadaInicio, coordenadaDestino, colorPiezaJug);

						pr_cambiar_jugador_mueve(idJugadorMueve);

						result := 2;

					END IF;

					IF continuar = 0 THEN

						result := 9;

					END IF;

				WHEN 'alfil' THEN 

					continuar := fn_verifi_trayec_mov_alfil(coordenadaInicio, coordenadaDestino);

					IF accion = 'mover' AND continuar = 1 THEN

						pr_mover_pieza(coordenadaInicio, coordenadaDestino);
						pr_registrar_movimiento(coordenadaInicio, coordenadaDestino, colorPiezaJug);

						pr_cambiar_jugador_mueve(idJugadorMueve);

						result := 1;

					END IF;

					IF accion = 'comer' AND continuar = 1 THEN

						pr_comer_pieza(coordenadaInicio, coordenadaDestino);
						pr_registrar_movimiento(coordenadaInicio, coordenadaDestino, colorPiezaJug);

						pr_cambiar_jugador_mueve(idJugadorMueve);

						result := 2;

					END IF;

					IF continuar = 0 THEN

						result := 9;

					END IF;

				WHEN 'rey' THEN 

					continuar := fn_verifi_trayec_mov_rey(coordenadaInicio, coordenadaDestino);

					IF accion = 'mover' AND continuar = 1 THEN

						pr_mover_pieza(coordenadaInicio, coordenadaDestino);
						pr_registrar_movimiento(coordenadaInicio, coordenadaDestino, colorPiezaJug);

						pr_cambiar_jugador_mueve(idJugadorMueve);

						result := 1;

					END IF;

					IF accion = 'comer' AND continuar = 1 THEN

						pr_comer_pieza(coordenadaInicio, coordenadaDestino);
						pr_registrar_movimiento(coordenadaInicio, coordenadaDestino, colorPiezaJug);

						pr_cambiar_jugador_mueve(idJugadorMueve);

						result := 2;

					END IF;

					IF continuar = 0 THEN

						result := 9;

					END IF;

				WHEN 'dama' THEN

					continuar := fn_verifi_trayec_mov_dama(coordenadaInicio, coordenadaDestino);

					IF accion = 'mover' AND continuar = 1 THEN

						pr_mover_pieza(coordenadaInicio, coordenadaDestino);
						pr_registrar_movimiento(coordenadaInicio, coordenadaDestino, colorPiezaJug);

						pr_cambiar_jugador_mueve(idJugadorMueve);

						result := 1;

					END IF;

					IF accion = 'comer' AND continuar = 1 THEN

						pr_comer_pieza(coordenadaInicio, coordenadaDestino);
						pr_registrar_movimiento(coordenadaInicio, coordenadaDestino, colorPiezaJug);

						pr_cambiar_jugador_mueve(idJugadorMueve);

						result := 2;

					END IF;

					IF continuar = 0 THEN

						result := 9;

					END IF;

				ELSE

					result := 6;

			END CASE;

		ELSE

			result := 8;

		END IF;
	ELSE

		result := 7;

	END IF;

	RETURN result;

END fn_mover;
/

CREATE OR REPLACE FUNCTION fn_partida_en_juego RETURN NUMBER IS

	idPartida tbl_partidas.id_partida%TYPE;

BEGIN

	SELECT id_partida 
	INTO idPartida
	FROM tbl_partidas 
	WHERE id_partida = (
		SELECT MAX(id_partida) 
		FROM tbl_partidas
	);

	RETURN idPartida;

END fn_partida_en_juego;
/
