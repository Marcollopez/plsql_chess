CREATE TABLE TBL_JUGADORES
(
	id_jugador 		NUMBER(5) NOT NULL,
	identificacion	VARCHAR2(5) NOT NULL,
	nombre 			VARCHAR2(20) NOT NULL,
	tipo_pieza 		VARCHAR2(10),
	cant_partidas_ganadas 	NUMBER(5),
	cant_partidas_perdidas	NUMBER(5),
	CONSTRAINT jugaror_pk PRIMARY KEY (id_jugador)	
);

CREATE TABLE TBL_PARTIDAS
(
	id_partida 	NUMBER(5) NOT NULL,
	id_jugador_blancas 	NUMBER(5) NOT NULL,
	id_jugador_negras 	NUMBER(5) NOT NULL,
	jugador_ganador		NUMBER(5),
	movimientos_blanca 	VARCHAR2(3000),
	movimientos_negra 	VARCHAR2(3000),
	CONSTRAINT partida_pk PRIMARY KEY (id_partida)
);

CREATE TABLE TBL_INFORMACION_PARTIDAS
(
	id_jugador 	NUMBER(5) NOT NULL,
	id_partida 	NUMBER(5) NOT NULL,
	resultado_partida 	VARCHAR2(10) NOT NULL,
	CONSTRAINT fk_info_partida_jugador FOREIGN KEY (id_jugador) REFERENCES TBL_JUGADORES(id_jugador),
	CONSTRAINT fk_info_partida_partida FOREIGN KEY (id_partida) REFERENCES TBL_PARTIDAS (id_partida)
);

CREATE TABLE TBL_TABLEROS
(
	id_tablero 	VARCHAR2(10) NOT NULL,
	CONSTRAINT tablero_pk PRIMARY KEY (id_tablero)
);

CREATE TABLE TBL_PIEZAS
(
	id_pieza	VARCHAR2(2) NOT NULL,
	tipo 		VARCHAR2(10) NOT NULL,
	nombre 		VARCHAR2(10) NOT NULL,
	coordenada 	VARCHAR2(2) NOT NULL,
	estado 		NUMBER(1) NOT NULL, 
	dim 		CHAR(1) NOT NULL,
	CONSTRAINT pieza_pk PRIMARY KEY (id_pieza)
);

CREATE TABLE TBL_JUGADORES_PIEZAS
(
	id_jugador 	NUMBER(5) NOT NULL,
	id_pieza 	VARCHAR2(2) NOT NULL,
	mueve 		NUMBER(5) NOT NULL,
	CONSTRAINT fk_jugador_jugador FOREIGN KEY (id_jugador) REFERENCES TBL_JUGADORES(id_jugador),
	CONSTRAINT fk_jugador_pieza FOREIGN KEY (id_pieza) REFERENCES TBL_PIEZAS(id_pieza)
);

CREATE TABLE TBL_TABLEROS_PIEZAS
(
	id_tablero 	VARCHAR2(10) NOT NULL,
	id_pieza 	VARCHAR2(2) NOT NULL,
	coordenada 	VARCHAR2(2) NOT NULL,
	pieza_coordenada VARCHAR2(2) NOT NULL,
	eje_x 		CHAR(1) NOT NULL,
	eje_y		NUMBER(1) NOT NULL,
	CONSTRAINT fk_tablero_pieza FOREIGN KEY (id_pieza) REFERENCES TBL_PIEZAS (id_pieza),
	CONSTRAINT fk_tablero_tablero FOREIGN KEY (id_tablero) REFERENCES TBL_TABLEROS (id_tablero)
);

CREATE TABLE TBL_TABLEROS_PARTIDAS
(
	id_partida 	NUMBER(5) NOT NULL,
	id_tablero 	VARCHAR2(10) NOT NULL,
	id_pieza 	VARCHAR2(2) NOT NULL,
	coordenada 	VARCHAR2(2) NOT NULL,
	pieza_coordenada VARCHAR2(2) NOT NULL,
	eje_x 		CHAR(1) NOT NULL,
	eje_y 		NUMBER(1) NOT NULL,
	CONSTRAINT fk_tablero_partida FOREIGN KEY (id_partida) REFERENCES TBL_PARTIDAS (id_partida)
);

CREATE SEQUENCE incrementar_id_jugador start WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 10000;
CREATE SEQUENCE incrementar_id_partida start WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 10000;
