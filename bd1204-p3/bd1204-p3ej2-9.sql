/*
Asignatura: Bases de Datos
Curso: 2024/25
Convocatoria: junio

Practica: P3. Definicion y Modificacion de Datos en SQL

Equipo de practicas: bd1204
 Integrante 1: Pablo Belchí Corredor
 Integrante 2: Daniel Cascales Marcos
*/

-------------------------------------------------------------------------------
-- EJERCICIO 2: Añadir y Eliminar columnas
-------------------------------------------------------------------------------

-- 2a. Añadir columna 'texto' en la tabla MENSAJE
ALTER TABLE MENSAJE
ADD texto VARCHAR2(35);

-- 2b. Añadir columna 'numero_mensajes' en la tabla MIUSUARIO
ALTER TABLE MIUSUARIO
ADD numero_mensajes NUMBER(3) DEFAULT 0 NOT NULL;

-- 2c. Eliminar la columna 'descripcion' de la tabla MIUSUARIO
ALTER TABLE MIUSUARIO
DROP COLUMN descripcion;

-------------------------------------------------------------------------------
-- EJERCICIO 3: Modificar valores de una columna
-------------------------------------------------------------------------------

-- 3a. Actualizar numero_mensajes con el conteo de mensajes de cada usuario
UPDATE MIUSUARIO U
SET numero_mensajes = (
    SELECT COUNT(*)
    FROM MENSAJE M
    WHERE M.usuario = U.telefono
);

COMMIT;

-- 3b. Actualizar texto del mensaje anclado si el último mensaje es anterior a 03/04/2024
UPDATE MENSAJE
SET texto = 'CHAT ANTIGUO: VALORA SU BORRADO'
WHERE mensaje_id IN (
    SELECT msj_anclado
    FROM CHAT_GRUPO G
    JOIN MENSAJE M ON G.msj_anclado = M.mensaje_id
    WHERE M.diahora < TO_DATE('03/04/2024', 'DD/MM/YYYY')
);

-- 3c. Mostrar mensajes anclados modificados
SELECT mensaje_id, texto
FROM MENSAJE
WHERE mensaje_id IN (
    SELECT msj_anclado
    FROM CHAT_GRUPO G
    JOIN MENSAJE M ON G.msj_anclado = M.mensaje_id
    WHERE M.diahora < TO_DATE('03/04/2024', 'DD/MM/YYYY')
);

-- 3d. Deshacer la modificación
ROLLBACK;

-------------------------------------------------------------------------------
-- EJERCICIO 4: Modificar el valor de una clave primaria de manera ordenada
-------------------------------------------------------------------------------

-- 4a. Desactivar restricciones que usan el teléfono como clave ajena
ALTER TABLE CONTACTO DISABLE CONSTRAINT contact_fk_usuario;
ALTER TABLE MENSAJE DISABLE CONSTRAINT mensaje_fk_usuario;
ALTER TABLE CHAT_GRUPO DISABLE CONSTRAINT chat_fk_administrador;
ALTER TABLE PARTICIPACION DISABLE CONSTRAINT participacion_fk_usuario;

-- 4a. Actualizar el teléfono 600000004 a 610000004 en MIUSUARIO
UPDATE MIUSUARIO
SET telefono = 610000004
WHERE telefono = 600000004;

-- 4a. Actualizar el teléfono en CONTACTO 
UPDATE CONTACTO
SET usuario = 610000004
WHERE usuario = 600000004;

-- 4a. Actualizar el teléfono en MENSAJE
UPDATE MENSAJE
SET usuario = 610000004
WHERE usuario = 600000004;

-- 4a. Actualizar el teléfono en CHAT_GRUPO 
UPDATE CHAT_GRUPO
SET administrador = 610000004
WHERE administrador = 600000004;

-- 4a. Actualizar el teléfono en PARTICIPACION
UPDATE PARTICIPACION
SET usuario = 610000004
WHERE usuario = 600000004;

-- 4a. Confirmar los cambios
COMMIT;

-- 4a. Reactivar las restricciones de claves ajenas
ALTER TABLE CONTACTO ENABLE CONSTRAINT contact_fk_usuario;
ALTER TABLE MENSAJE ENABLE CONSTRAINT mensaje_fk_usuario;
ALTER TABLE CHAT_GRUPO ENABLE CONSTRAINT chat_fk_administrador;
ALTER TABLE PARTICIPACION ENABLE CONSTRAINT participacion_fk_usuario;


-------------------------------------------------------------------------------
-- EJERCICIO 5: Borrar algunas filas de una tabla
-------------------------------------------------------------------------------

-- 5a. Visualizar los mensajes que cumplen la condición
SELECT M.mensaje_id, M.diahora, M.msj_original, M.chat_grupo, M.usuario
FROM MENSAJE M
WHERE M.diahora < TO_DATE('10/02/2025', 'DD/MM/YYYY')
  AND M.msj_original IS NOT NULL
  AND M.mensaje_id NOT IN (SELECT msj_anclado FROM CHAT_GRUPO WHERE msj_anclado IS NOT NULL)
  AND M.chat_grupo IN (
      SELECT codigo
      FROM CHAT_GRUPO
      WHERE miembros > 3
  )
  AND M.usuario IN (
      SELECT usuario
      FROM PARTICIPACION
      GROUP BY usuario
      HAVING COUNT(*) < 4
  );

-- 5b. Borrar esos mensajes
DELETE FROM MENSAJE
WHERE mensaje_id IN (
    SELECT M.mensaje_id
    FROM MENSAJE M
    WHERE M.diahora < TO_DATE('10/02/2025', 'DD/MM/YYYY')
      AND M.msj_original IS NOT NULL
      AND M.mensaje_id NOT IN (SELECT msj_anclado FROM CHAT_GRUPO WHERE msj_anclado IS NOT NULL)
      AND M.chat_grupo IN (
          SELECT codigo
          FROM CHAT_GRUPO
          WHERE miembros > 3
      )
      AND M.usuario IN (
          SELECT usuario
          FROM PARTICIPACION
          GROUP BY usuario
          HAVING COUNT(*) < 4
      )
);

COMMIT;


-------------------------------------------------------------------------------
-- EJERCICIO 6: Borrar todas las filas relacionadas con un chat de grupo
-------------------------------------------------------------------------------

-- 6a. Desactivar restricciones que impidan el borrado
ALTER TABLE CHAT_GRUPO DISABLE CONSTRAINT chat_fk_msj;
ALTER TABLE MENSAJE DISABLE CONSTRAINT mensaje_fk_chat;
ALTER TABLE PARTICIPACION DISABLE CONSTRAINT participacion_fk_chatgrupo;

-- 6a. Eliminar primero los MENSAJES del chat 'C004'
DELETE FROM MENSAJE
WHERE chat_grupo = 'C004';

-- 6a. Eliminar primero las PARTICIPACIONES en el chat 'C004'
DELETE FROM PARTICIPACION
WHERE chat_grupo = 'C004';

-- 6a. Eliminar el CHAT_GRUPO 'C004'
DELETE FROM CHAT_GRUPO
WHERE codigo = 'C004';

-- 6a. Confirmar cambios
COMMIT;

-- 6a. Reactivar las restricciones
ALTER TABLE CHAT_GRUPO ENABLE CONSTRAINT chat_fk_msj;
ALTER TABLE MENSAJE ENABLE CONSTRAINT mensaje_fk_chat;
ALTER TABLE PARTICIPACION ENABLE CONSTRAINT participacion_fk_chatgrupo;



-------------------------------------------------------------------------------
-- EJERCICIO 7a: Crear la vista INTERACCION_ADMIN
-------------------------------------------------------------------------------

CREATE OR REPLACE VIEW INTERACCION_ADMIN AS
SELECT 
    U.telefono AS tel_admin,
    U.nombre AS nom_admin,
    U.fecha_registro AS f_registro,
    G.nombre AS nom_chat,
    (SELECT COUNT(*)
     FROM MENSAJE M
     WHERE M.usuario = G.administrador
       AND M.chat_grupo = G.codigo) AS n_mensajes
FROM 
    CHAT_GRUPO G
    JOIN MIUSUARIO U ON G.administrador = U.telefono;

-------------------------------------------------------------------------------
-- EJERCICIO 7b: Mostrar el contenido de la vista INTERACCION_ADMIN
-------------------------------------------------------------------------------

SELECT *
FROM INTERACCION_ADMIN
ORDER BY nom_admin, nom_chat;

-------------------------------------------------------------------------------
-- EJERCICIO 7c: Modificar la vista INTERACCION_ADMIN
-------------------------------------------------------------------------------

CREATE OR REPLACE VIEW INTERACCION_ADMIN AS
SELECT 
    U.telefono AS tel_admin,
    U.nombre AS nom_admin,
    G.nombre AS nom_chat,
    (SELECT COUNT(*)
     FROM MENSAJE M
     WHERE M.usuario = G.administrador
       AND M.chat_grupo = G.codigo) AS n_mensajes,
    (SELECT COUNT(*)
     FROM MENSAJE M
     WHERE M.chat_grupo = G.codigo) AS total_mensajes
FROM 
    CHAT_GRUPO G
    JOIN MIUSUARIO U ON G.administrador = U.telefono;


-------------------------------------------------------------------------------
-- EJERCICIO 7d: Insertar dos nuevos mensajes
-------------------------------------------------------------------------------

-- 1. Crear primero los usuarios 600000008 y 600000011 
INSERT INTO MIUSUARIO (telefono, nombre, fecha_registro, idioma)
VALUES (600000008, 'Usuario 8', TO_DATE('01/05/2024', 'DD/MM/YYYY'), 'Español');

INSERT INTO MIUSUARIO (telefono, nombre, fecha_registro, idioma)
VALUES (600000011, 'Usuario 11', TO_DATE('01/05/2024', 'DD/MM/YYYY'), 'Español');

-- 2. Crear primero el chat 'C007' para poder insertar los mensajes
INSERT INTO CHAT_GRUPO (codigo, nombre, fecha_creacion, administrador, msj_anclado, miembros)
VALUES ('C007', 'Chat C007', TO_DATE('01/05/2024', 'DD/MM/YYYY'), 600000001, NULL, 5);

-- 3. Insertar los mensajes en el chat 'C007'
-- Mensaje 1
INSERT INTO MENSAJE (mensaje_id, diahora, reenviado, usuario, chat_grupo, msj_original, texto)
VALUES ('MSJ00701', SYSDATE, 'NO', 600000008, 'C007', NULL, 'Q deberes puso la de mates?');

-- Mensaje 2 
INSERT INTO MENSAJE (mensaje_id, diahora, reenviado, usuario, chat_grupo, msj_original, texto)
VALUES ('MSJ00702', SYSDATE, 'NO', 600000011, 'C007', 'MSJ00701', 'Toda la pagina 36 del libro');

-- 4. Confirmar todos los cambios
COMMIT;



-------------------------------------------------------------------------------
-- EJERCICIO 7e: Visualizar la vista INTERACCION_ADMIN y comentar
-------------------------------------------------------------------------------

SELECT *
FROM INTERACCION_ADMIN
ORDER BY nom_admin, nom_chat;


COMMIT;



