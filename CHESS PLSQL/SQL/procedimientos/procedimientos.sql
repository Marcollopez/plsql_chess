CREATE OR REPLACE PROCEDURE pr_mostrar_tablero IS

	ejeY 			tbl_tableros_piezas.eje_y%TYPE;
	piezaCoordenada tbl_tableros_piezas.pieza_coordenada%TYPE;
	dimPieza 		tbl_piezas.dim%TYPE;

	tablero 		VARCHAR2(100);
	cadena 			VARCHAR2(100);

	CURSOR info_eje_y IS
		SELECT DISTINCT(eje_y)
		FROM tbl_tableros_piezas
		ORDER BY eje_y DESC;

	CURSOR info_pieza_coordenada_eje_y(pejeY NUMBER) IS
		SELECT pieza_coordenada
		FROM tbl_tableros_piezas
		WHERE eje_y = pejeY;

BEGIN

	pr_mostrar_eje_x;

	OPEN info_eje_y;
		LOOP
			FETCH info_eje_y INTO ejeY;
			EXIT WHEN info_eje_y%NOTFOUND;

			OPEN info_pieza_coordenada_eje_y(ejeY);
				LOOP
					FETCH info_pieza_coordenada_eje_y INTO piezaCoordenada;
					EXIT WHEN info_pieza_coordenada_eje_y%NOTFOUND;

					SELECT dim
					INTO dimPieza
					FROM tbl_piezas
					WHERE id_pieza = piezaCoordenada;

					IF dimPieza = 'v' THEN

						dimPieza := '_';
						cadena := '|'|| '  ' || dimPieza || '  ';
						tablero := tablero || cadena;

					ELSE
						cadena := '|'|| '  ' || dimPieza || '  ';
						tablero :=  tablero || cadena;

					END IF;

				END LOOP;
				dbms_output.put_line('-------------------------------------------------');
				tablero := tablero || '|' || '   ' || ejeY;
				dbms_output.put_line(tablero);
				tablero := '';
			CLOSE info_pieza_coordenada_eje_y;
		END LOOP;
		dbms_output.put_line('-------------------------------------------------');
	CLOSE info_eje_y;
	
	pr_mostrar_eje_x;

END pr_mostrar_tablero;
/

CREATE OR REPLACE PROCEDURE pr_mostrar_jug_mueve IS

	idJugador 	tbl_jugadores.id_jugador%TYPE;
	verMueve 	NUMBER(1);

	nom 		tbl_jugadores.nombre%TYPE;
	tipo 	tbl_jugadores.tipo_pieza%TYPE;

	jugBlancas 	tbl_jugadores.nombre%TYPE;
	jugNegras 	tbl_jugadores.nombre%TYPE;

	jugMueve 	tbl_jugadores.tipo_pieza%TYPE;

	CURSOR info_jugador_mueve IS
		SELECT DISTINCT(id_jugador), mueve
		FROM tbl_jugadores_piezas;

BEGIN

	OPEN info_jugador_mueve;
		LOOP
			FETCH info_jugador_mueve INTO idJugador, verMueve;
			EXIT WHEN info_jugador_mueve%NOTFOUND;

			SELECT nombre, tipo_pieza
			INTO nom, tipo
			FROM tbl_jugadores
			WHERE id_jugador = idJugador;

			IF tipo = 'Blancas' THEN

				jugBlancas := nom;

			ELSE

				jugNegras := nom;

			END IF;

			IF verMueve = 1 THEN

				jugMueve := tipo;

			END IF;

		END LOOP;


		dbms_output.put_line(chr(10) || '- Blancas: ' || jugBlancas || '   ' || 'Negras: ' || jugNegras || '   ' || 'Mueve: ' || jugMueve);

	CLOSE info_jugador_mueve;

END pr_mostrar_jug_mueve;
/

CREATE OR REPLACE PROCEDURE pr_mover_pieza(coorInicio VARCHAR2, coorFin VARCHAR2) IS

	idPieza tbl_piezas.id_pieza%TYPE;

BEGIN

	SELECT id_pieza
	INTO idPieza
	FROM tbl_piezas
	WHERE coordenada = coorInicio;

	UPDATE tbl_piezas
	SET coordenada = coorFin
	WHERE id_pieza = idPieza;

	UPDATE tbl_tableros_piezas
	SET id_pieza = '00'
	WHERE coordenada = coorInicio;

	UPDATE tbl_tableros_piezas
	SET pieza_coordenada = '00'
	WHERE coordenada = coorInicio;

	UPDATE tbl_tableros_piezas
	SET pieza_coordenada = idPieza
	WHERE coordenada = coorFin;

	UPDATE tbl_tableros_piezas
	SET id_pieza = idPieza
	WHERE coordenada = coorFin;

END pr_mover_pieza;
/

CREATE OR REPLACE PROCEDURE pr_comer_pieza(coorInicio VARCHAR2, coorFin VARCHAR2) IS

	idPiezaInicio tbl_piezas.id_pieza%TYPE;
	idPiezaFin tbl_piezas.id_pieza%TYPE;

BEGIN

	SELECT id_pieza
	INTO idPiezaInicio
	FROM tbl_piezas
	WHERE coordenada = coorInicio;

	SELECT id_pieza
	INTO idPiezaFin
	FROM tbl_piezas
	WHERE coordenada = coorFin;

	UPDATE tbl_piezas
	SET coordenada = coorFin
	WHERE id_pieza = idPiezaInicio;

	UPDATE tbl_tableros_piezas
	SET id_pieza = '00'
	WHERE coordenada = coorInicio;

	UPDATE tbl_tableros_piezas
	SET pieza_coordenada = '00'
	WHERE coordenada = coorInicio;

	UPDATE tbl_tableros_piezas
	SET pieza_coordenada = idPiezaInicio
	WHERE coordenada = coorFin;

	UPDATE tbl_tableros_piezas
	SET id_pieza = idPiezaInicio
	WHERE coordenada = coorFin;

	UPDATE tbl_piezas
	SET estado = 0
	WHERE id_pieza = idPiezaFin;

	UPDATE tbl_piezas
	SET coordenada = '00'
	WHERE id_pieza = idPiezaFin;

END pr_comer_pieza;
/



CREATE OR REPLACE PROCEDURE pr_cargar_piezas IS
BEGIN

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'a8',
		'negra',
		'torre',
		'a8',
		1,
		't'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'b8',
		'negra',
		'caballo',
		'b8',
		1,
		'c'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'c8',
		'negra',
		'alfil',
		'c8',
		1,
		'a'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'd8',
		'negra',
		'dama',
		'd8',
		1,
		'd'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'e8',
		'negra',
		'rey',
		'e8',
		1,
		'r'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'f8',
		'negra',
		'alfil',
		'f8',
		1,
		'a'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'g8',
		'negra',
		'caballo',
		'g8',
		1,
		'c'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'h8',
		'negra',
		'torre',
		'h8',
		1,
		't'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'a7',
		'negra',
		'peon',
		'a7',
		1,
		'p'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'b7',
		'negra',
		'peon',
		'b7',
		1,
		'p'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'c7',
		'negra',
		'peon',
		'c7',
		1,
		'p'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'd7',
		'negra',
		'peon',
		'd7',
		1,
		'p'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'e7',
		'negra',
		'peon',
		'e7',
		1,
		'p'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'f7',
		'negra',
		'peon',
		'f7',
		1,
		'p'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'g7',
		'negra',
		'peon',
		'g7',
		1,
		'p'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'h7',
		'negra',
		'peon',
		'h7',
		1,
		'p'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'a1',
		'blanca',
		'torre',
		'a1',
		1,
		'T'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'b1',
		'blanca',
		'caballo',
		'b1',
		1,
		'C'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'c1',
		'blanca',
		'alfil',
		'c1',
		1,
		'A'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'd1',
		'blanca',
		'dama',
		'd1',
		1,
		'D'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'e1',
		'blanca',
		'rey',
		'e1',
		1,
		'R'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'f1',
		'blanca',
		'alfil',
		'f1',
		1,
		'A'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'g1',
		'blanca',
		'caballo',
		'g1',
		1,
		'C'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'h1',
		'blanca',
		'torre',
		'h1',
		1,
		'T'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'a2',
		'blanca',
		'peon',
		'a2',
		1,
		'P'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'b2',
		'blanca',
		'peon',
		'b2',
		1,
		'P'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'c2',
		'blanca',
		'peon',
		'c2',
		1,
		'P'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'd2',
		'blanca',
		'peon',
		'd2',
		1,
		'P'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'e2',
		'blanca',
		'peon',
		'e2',
		1,
		'P'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'f2',
		'blanca',
		'peon',
		'f2',
		1,
		'P'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'g2',
		'blanca',
		'peon',
		'g2',
		1,
		'P'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'h2',
		'blanca',
		'peon',
		'h2',
		1,
		'P'
	);

	INSERT INTO TBL_PIEZAS (id_pieza, tipo, nombre, coordenada, estado, dim)
	VALUES
	(
		'00',
		'none',
		'none',
		'00',
		3,
		'v'
	);

END pr_cargar_piezas;
/

CREATE OR REPLACE PROCEDURE pr_cargar_tableros_piezas IS
BEGIN

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'a8',
		'a8',
		'a8',
		'A',
		8
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'b8',
		'b8',
		'b8',
		'B',
		8
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'c8',
		'c8',
		'c8',
		'C',
		8
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'd8',
		'd8',
		'd8',
		'D',
		8
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'e8',
		'e8',
		'e8',
		'E',
		8
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'f8',
		'f8',
		'f8',
		'F',
		8
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'g8',
		'g8',
		'g8',
		'G',
		8
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'h8',
		'h8',
		'h8',
		'H',
		8
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'a7',
		'a7',
		'a7',
		'A',
		7
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'b7',
		'b7',
		'b7',
		'B',
		7
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'c7',
		'c7',
		'c7',
		'C',
		7
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'd7',
		'd7',
		'd7',
		'D',
		7
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'e7',
		'e7',
		'e7',
		'E',
		7
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'f7',
		'f7',
		'f7',
		'F',
		7
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'g7',
		'g7',
		'g7',
		'G',
		7
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'h7',
		'h7',
		'h7',
		'H',
		7
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'a6',
		'00',
		'A',
		6
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'b6',
		'00',
		'B',
		6
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'c6',
		'00',
		'C',
		6
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'd6',
		'00',
		'D',
		6
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'e6',
		'00',
		'E',
		6
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'f6',
		'00',
		'F',
		6
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'g6',
		'00',
		'G',
		6
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'h6',
		'00',
		'H',
		6
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'a5',
		'00',
		'A',
		5
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'b5',
		'00',
		'B',
		5
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'c5',
		'00',
		'C',
		5
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'd5',
		'00',
		'D',
		5
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'e5',
		'00',
		'E',
		5
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'f5',
		'00',
		'F',
		5
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'g5',
		'00',
		'G',
		5
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'h5',
		'00',
		'H',
		5
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'a4',
		'00',
		'A',
		4
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'b4',
		'00',
		'B',
		4
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'c4',
		'00',
		'C',
		4
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'd4',
		'00',
		'D',
		4
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'e4',
		'00',
		'E',
		4
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'f4',
		'00',
		'F',
		4
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'g4',
		'00',
		'G',
		4
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'h4',
		'00',
		'H',
		4
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'a3',
		'00',
		'A',
		3
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'b3',
		'00',
		'B',
		3
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'c3',
		'00',
		'C',
		3
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'd3',
		'00',
		'D',
		3
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'e3',
		'00',
		'E',
		3
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'f3',
		'00',
		'F',
		3
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'g3',
		'00',
		'G',
		3
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'00',
		'h3',
		'00',
		'H',
		3
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'a2',
		'a2',
		'a2',
		'A',
		2
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'b2',
		'b2',
		'b2',
		'B',
		2
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'c2',
		'c2',
		'c2',
		'C',
		2
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'd2',
		'd2',
		'd2',
		'D',
		2
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'e2',
		'e2',
		'e2',
		'E',
		2
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'f2',
		'f2',
		'f2',
		'F',
		2
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'g2',
		'g2',
		'g2',
		'G',
		2
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'h2',
		'h2',
		'h2',
		'H',
		2
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'a1',
		'a1',
		'a1',
		'A',
		1
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'b1',
		'b1',
		'b1',
		'B',
		1
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'c1',
		'c1',
		'c1',
		'C',
		1
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'd1',
		'd1',
		'd1',
		'D',
		1
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'e1',
		'e1',
		'e1',
		'E',
		1
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'f1',
		'f1',
		'f1',
		'F',
		1
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'g1',
		'g1',
		'g1',
		'G',
		1
	);

	INSERT INTO  TBL_TABLEROS_PIEZAS (id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
	VALUES
	(
		'tb_chess',
		'h1',
		'h1',
		'h1',
		'H',
		1
	);

END pr_cargar_tableros_piezas;
/

CREATE OR REPLACE PROCEDURE pr_mostrar_estad_jugador(idJugador NUMBER) IS

	nombreJug tbl_jugadores.nombre%TYPE;
	tipoPiezaJug tbl_jugadores.tipo_pieza%TYPE;
	cantGanadas tbl_jugadores.cant_partidas_ganadas%TYPE;
	cantPerdidas tbl_jugadores.cant_partidas_perdidas%TYPE;

BEGIN

	SELECT nombre, tipo_pieza, cant_partidas_ganadas, cant_partidas_perdidas
	INTO nombreJug, tipoPiezaJug, cantGanadas, cantPerdidas
	FROM tbl_jugadores
	WHERE id_jugador = idJugador;

	dbms_output.put_line(chr(10) || 'Nombre del jugador: ' || nombreJug);
	dbms_output.put_line('Tipo de pieza: ' || tipoPiezaJug);
	dbms_output.put_line('Cantidad de partidas ganadas: ' || cantGanadas);
	dbms_output.put_line('Cantidad de partidas perdidas: ' || cantPerdidas || chr(10));

END pr_mostrar_estad_jugador;
/

CREATE OR REPLACE PROCEDURE pr_mostrar_estad_partida(idPartida NUMBER) IS

	idBlancas tbl_partidas.id_jugador_blancas%TYPE;
	idNegras tbl_partidas.id_jugador_negras%TYPE;
	ganador tbl_partidas.jugador_ganador%TYPE;
	movBlancas tbl_partidas.movimientos_blanca%TYPE;
	movNegras tbl_partidas.movimientos_negra%TYPE;

	nomJugBlancas tbl_jugadores.nombre%TYPE;
	nomJugNegras tbl_jugadores.nombre%TYPE;
	nomJugGanador tbl_jugadores.nombre%TYPE;

BEGIN

	SELECT id_jugador_blancas, id_jugador_negras, jugador_ganador, movimientos_blanca, movimientos_negra
	INTO idBlancas, idNegras, ganador, movBlancas, movNegras
	FROM tbl_partidas
	WHERE id_partida = idPartida;

	SELECT nombre 
	INTO nomJugBlancas
	FROM tbl_jugadores
	WHERE id_jugador = idBlancas;

	SELECT nombre 
	INTO nomJugNegras
	FROM tbl_jugadores
	WHERE id_jugador = idNegras;

	SELECT nombre 
	INTO nomJugGanador
	FROM tbl_jugadores
	WHERE id_jugador = ganador;

	dbms_output.put_line(chr(10) || 'Enfrentamiento');
	dbms_output.put_line('Blancas --> ' || nomJugBlancas || ' vs ' || nomJugNegras || ' <-- Negras ' || chr(10));

	dbms_output.put_line('Ganador: ' || nomJugGanador || chr(10));
	dbms_output.put_line('Movimientos Blancas: ' || chr(10) || movBlancas);
	dbms_output.put_line('Movimientos Negras: ' || chr(10) || movNegras);

END pr_mostrar_estad_partida;
/

--

CREATE OR REPLACE PROCEDURE pr_cambiar_jugador_mueve(idJugadorMueve NUMBER) IS

	idJugadorNoMueve tbl_jugadores.id_jugador%TYPE;

BEGIN

	idJugadorNoMueve := fn_jug_no_mueve;

	UPDATE tbl_jugadores_piezas
	SET mueve = 0
	WHERE id_jugador = idJugadorMueve;

	UPDATE tbl_jugadores_piezas
	SET mueve = 1
	WHERE id_jugador = idJugadorNoMueve;

END;
/

CREATE OR REPLACE PROCEDURE pr_terminar_partida IS

	idJugadorMueve tbl_jugadores.id_jugador%TYPE;
	idJugadorNoMueve tbl_jugadores.id_jugador%TYPE;

	idPartida tbl_partidas.id_partida%TYPE;

BEGIN

	idJugadorMueve := fn_jug_mueve;
	idJugadorNoMueve := fn_jug_no_mueve;

	idPartida := fn_partida_en_juego;

	pr_copia_tablero_partida(idPartida);

	UPDATE tbl_informacion_partidas
	SET resultado_partida = 'VICTORIA'
	WHERE id_partida = idPartida AND id_jugador = idJugadorNoMueve;

	UPDATE tbl_informacion_partidas
	SET resultado_partida = 'DERROTA'
	WHERE id_partida = idPartida AND id_jugador = idJugadorMueve;

	UPDATE tbl_partidas
	SET jugador_ganador = idJugadorNoMueve
	WHERE id_partida = idPartida;

	UPDATE tbl_jugadores
	SET cant_partidas_ganadas = cant_partidas_ganadas + 1
	WHERE id_jugador = idJugadorNoMueve;

	UPDATE tbl_jugadores
	SET cant_partidas_perdidas = cant_partidas_perdidas + 1
	WHERE id_jugador = idJugadorMueve;

	dbms_output.put_line(chr(10) || 'ESTADISTICAS DE LOS JUGADORES');

	pr_mostrar_estad_jugador(idJugadorMueve);
	pr_mostrar_estad_jugador(idJugadorNoMueve);

	dbms_output.put_line(chr(10) || 'ESTADISTICAS DE LA PARTIDA');

	pr_mostrar_estad_partida(idPartida);

	DELETE FROM tbl_tableros_piezas;
	DELETE FROM tbl_jugadores_piezas;
	DELETE FROM tbl_piezas;

	pr_cargar_piezas;
	pr_cargar_tableros_piezas;
	
END pr_terminar_partida;
/

CREATE OR REPLACE PROCEDURE pr_registrar_movimiento(coorInicio VARCHAR2, coorFin VARCHAR2, tipoPieza VARCHAR2) IS
	movimiento VARCHAR2(100);

	idPartida tbl_partidas.id_partida%TYPE;
BEGIN

	idPartida := fn_partida_en_juego;

	movimiento := coorInicio || ' - ' || coorFin || chr(10);

	IF tipoPieza = 'blanca' THEN
		UPDATE tbl_partidas
		SET movimientos_blanca = movimientos_blanca || movimiento
		WHERE id_partida = idPartida;
	ELSE
		UPDATE tbl_partidas
		SET movimientos_negra = movimientos_negra || movimiento
		WHERE id_partida = idPartida;
	END IF;
END pr_registrar_movimiento;
/

CREATE OR REPLACE PROCEDURE pr_copia_tablero_partida(idPartida NUMBER) IS 

	idTablero tbl_tableros.id_tablero%TYPE;
	idPieza tbl_tableros_piezas.id_pieza%TYPE;
	coordenadaTabPieza tbl_tableros_piezas.coordenada%TYPE;
	piezaCoordenada tbl_tableros_piezas.pieza_coordenada%TYPE;
	ejeX tbl_tableros_piezas.eje_x%TYPE;
	ejeY tbl_tableros_piezas.eje_y%TYPE;
	
	CURSOR info_tablero IS
		SELECT id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y
		FROM tbl_tableros_piezas;

BEGIN

	OPEN info_tablero;
		LOOP
			FETCH info_tablero INTO idTablero, idPieza, coordenadaTabPieza, piezaCoordenada, ejeX, ejeY;
			EXIT WHEN info_tablero%NOTFOUND;

			INSERT INTO tbl_tableros_partidas (id_partida, id_tablero, id_pieza, coordenada, pieza_coordenada, eje_x, eje_y)
			VALUES (idPartida, idTablero, idPieza, coordenadaTabPieza, piezaCoordenada, ejeX, ejeY);

		END LOOP;

	CLOSE info_tablero;

END pr_copia_tablero_partida;
/

CREATE OR REPLACE PROCEDURE pr_mostrar_eje_x IS

	ejeX 			VARCHAR2(8);
	coorX 			VARCHAR2(100);

	CURSOR info_eje_x IS
		SELECT DISTINCT(eje_x)
		FROM tbl_tableros_piezas
		ORDER BY eje_x ASC;

BEGIN

	OPEN info_eje_x;
		LOOP
			FETCH info_eje_x INTO ejeX;
			EXIT WHEN info_eje_x%NOTFOUND;
			ejeX :='|'|| '  ' || ejeX || '  ';
			coorX := coorX || ejeX;
		END LOOP;
		coorX := coorX || '|' || chr(10);
		dbms_output.put_line(chr(10) || coorX);
	CLOSE info_eje_x;

END pr_mostrar_eje_x;
/

CREATE OR REPLACE PROCEDURE pr_mostrar_tablero_partida(pidPartida NUMBER) IS

	ejeY 			tbl_tableros_piezas.eje_y%TYPE;
	piezaCoordenada tbl_tableros_piezas.pieza_coordenada%TYPE;
	dimPieza 		tbl_piezas.dim%TYPE;

	tablero 		VARCHAR2(100);
	cadena 			VARCHAR2(100);

	CURSOR eje_y_inf IS
		SELECT DISTINCT(eje_y)
		FROM tbl_tableros_piezas
		ORDER BY eje_y DESC;

	CURSOR pieza_eje_y_inf(pejeY NUMBER, pIdPart NUMBER) IS
		SELECT pieza_coordenada
		FROM tbl_tableros_partidas
		WHERE eje_y = pejeY AND id_partida = pIdPart;

BEGIN

	pr_mostrar_eje_x;

	OPEN eje_y_inf;
		LOOP
			FETCH eje_y_inf INTO ejeY;
			EXIT WHEN eje_y_inf%NOTFOUND;

			OPEN pieza_eje_y_inf(ejeY, pidPartida);
				LOOP
					FETCH pieza_eje_y_inf INTO piezaCoordenada;
					EXIT WHEN pieza_eje_y_inf%NOTFOUND;

					SELECT dim
					INTO dimPieza
					FROM tbl_piezas
					WHERE id_pieza = piezaCoordenada;

					IF dimPieza = 'v' THEN

						dimPieza := '_';
						cadena := '|'|| '  ' || dimPieza || '  ';
						tablero := tablero || cadena;

					ELSE
						cadena := '|'|| '  ' || dimPieza || '  ';
						tablero :=  tablero || cadena;

					END IF;

				END LOOP;
				dbms_output.put_line('-------------------------------------------------');
				tablero := tablero || '|' || '   ' || ejeY;
				dbms_output.put_line(tablero);
				tablero := '';
			CLOSE pieza_eje_y_inf;
		END LOOP;
		dbms_output.put_line('-------------------------------------------------');
	CLOSE eje_y_inf;

	pr_mostrar_eje_x;

END pr_mostrar_tablero_partida;
/
