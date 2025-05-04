/*
Asignatura: Bases de Datos
Curso: 2024/25
Convocatoria: junio

Practica: P3. Definicion y Modificacion de Datos en SQL

Equipo de practicas: bd1204
 Integrante 1: Pablo Belchí Corredor
 Integrante 2: Daniel Cascales Marcos
*/

-- 1. Insertar datos en MIUSUARIO
INSERT INTO MIUSUARIO VALUES (600000001, 'Juan Pérez', TO_DATE('10/01/2024', 'DD/MM/YYYY'), 'Español', 'Usuario activo');
INSERT INTO MIUSUARIO VALUES (600000002, 'María García', TO_DATE('15/01/2024', 'DD/MM/YYYY'), 'Español', 'Usuario premium');

-- 2. Insertar datos en CONTACTO
INSERT INTO CONTACTO VALUES (600000003, 'Carlos López', 'Gómez', 15, 5, 600000001);
INSERT INTO CONTACTO VALUES (600000004, 'Ana Martínez', NULL, NULL, NULL, 600000001);

-- 3. Insertar datos en EMAIL_CONTACTO
INSERT INTO EMAIL_CONTACTO VALUES (600000001, 600000003, 'carlos.lopez@email.com');
INSERT INTO EMAIL_CONTACTO VALUES (600000001, 600000004, 'ana.martinez@email.com');

-- 4. Insertar datos en CHAT_GRUPO 
INSERT INTO CHAT_GRUPO (codigo, nombre, fecha_creacion, administrador, msj_anclado, miembros)
VALUES ('C001', 'Amigos', TO_DATE('20/01/2024', 'DD/MM/YYYY'), 600000001, NULL, 5);

-- 5. Insertar datos en MENSAJE 
-- Primero mensajes que no son respuestas a otros
INSERT INTO MENSAJE VALUES ('MSG000001', TO_DATE('25/01/2024 10:00', 'DD/MM/YYYY HH24:MI'), 'NO', 600000001, 'C001', NULL);

-- Mensajes que son respuestas
INSERT INTO MENSAJE VALUES ('MSG000101', TO_DATE('25/01/2024 10:05', 'DD/MM/YYYY HH24:MI'), 'NO', 600000002, 'C001', 'MSG000001');

-- 6. Actualizar CHAT_GRUPO con mensajes anclados
UPDATE CHAT_GRUPO SET msj_anclado = 'MSG000001' WHERE codigo = 'C001';

-- 7. Insertar datos en PARTICIPACION
INSERT INTO PARTICIPACION VALUES (600000001, 'C001', TO_DATE('20/01/2024', 'DD/MM/YYYY'));
INSERT INTO PARTICIPACION VALUES (600000002, 'C001', TO_DATE('20/01/2024', 'DD/MM/YYYY'));

COMMIT;



