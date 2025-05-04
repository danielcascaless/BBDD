/*
Asignatura: Bases de Datos
Curso: 2024/25
Convocatoria: junio

Practica: P3. Definicion y Modificacion de Datos en SQL

Equipo de practicas: bd1204
 Integrante 1: Pablo Belchí Corredor
 Integrante 2: Daniel Cascales Marcos
*/

-- EJERCICIO 0. Corregir/mejorar el script de creacion de  tablas 
-- entregado en la Practica P1 Sesion 4 Disenno Logico Especifico

-- Eliminacion de tablas, para ejecucion repetida
DROP TABLE EMAIL_CONTACTO;
DROP TABLE CONTACTO;
ALTER TABLE MENSAJE DROP CONSTRAINT mensaje_fk_chat;
DROP TABLE PARTICIPACION;
DROP TABLE CHAT_GRUPO;
DROP TABLE MENSAJE;
DROP TABLE MIUSUARIO;


CREATE TABLE MIUSUARIO (
    telefono        NUMBER(9)        NOT NULL,
    nombre          VARCHAR2(30)    NOT NULL,
    fecha_registro   DATE           NOT NULL,
    idioma          VARCHAR2(20)    NOT NULL,
    descripcion     VARCHAR2(30),
    PRIMARY KEY(telefono)
);
CREATE TABLE CONTACTO (
    telefono   NUMBER(9)         NOT NULL,
    nombre     VARCHAR2(30)    NOT NULL,
    apellidos   VARCHAR2(30),
    dia         NUMBER(2),   
    mes         NUMBER(2),
    usuario    NUMBER(9)     NOT NULL,
    PRIMARY KEY (telefono,usuario),
    CONSTRAINT chk_dia CHECK (dia BETWEEN 1 AND 31),
    CONSTRAINT chk_mes CHECK (mes BETWEEN 1 AND 12),
    CONSTRAINT chk_dia_mes CHECK ((dia IS NOT NULL AND mes IS NOT NULL) OR (dia IS NULL AND mes IS NULL)),
    CONSTRAINT contact_fk_usuario FOREIGN KEY (usuario) REFERENCES MIUSUARIO(telefono)
                -- ON DELETE CASCADE          ON UPDATE CASCADE
);

CREATE TABLE EMAIL_CONTACTO (
    usuario     NUMBER(9)     NOT NULL,
    contacto    NUMBER(9)     NOT NULL,
    email       VARCHAR2(30)     NOT NULL,
    PRIMARY KEY (usuario,contacto,email),
    CONSTRAINT email_fk_usuariocontacto FOREIGN KEY (usuario,contacto) REFERENCES CONTACTO(usuario,telefono)
                -- ON DELETE CASCADE          ON UPDATE    CASCADE
);


CREATE TABLE MENSAJE (
    mensaje_id      CHAR(10)        NOT NULL,
    diahora         DATE           NOT NULL,
    reenviado       CHAR(2)        NOT NULL,
    usuario         NUMBER(9)      NOT NULL,
    chat_grupo      CHAR(4)        NOT NULL,
    msj_original    CHAR(10),
    PRIMARY KEY (mensaje_id),
    CONSTRAINT chk_reenviado CHECK (reenviado IN('SI','NO')),
    CONSTRAINT chk_mensajeid CHECK (mensaje_id <> msj_original),
    CONSTRAINT mensaje_fk_usuario FOREIGN KEY (usuario)     REFERENCES MIUSUARIO(telefono),
            -- ON DELETE SET NULL            ON UPDATE CASCADE
    CONSTRAINT mensaje_fk_msjoriginal FOREIGN KEY (msj_original)   REFERENCES MENSAJE(mensaje_id)
            -- ON DELETE SET NULL            ON UPDATE CASCADE
);


CREATE TABLE CHAT_GRUPO (
    codigo            CHAR(4)         NOT NULL,
    nombre            VARCHAR2(30)    NOT NULL,
    fecha_creacion      DATE            NOT NULL,
    administrador       NUMBER(9)       NOT NULL,
    msj_anclado         CHAR(10)        NULL,
    miembros            NUMBER(3)       NULL,
    PRIMARY KEY (codigo),
    CONSTRAINT chat_fk_administrador  FOREIGN KEY (administrador) REFERENCES MIUSUARIO(telefono),
            -- ON DELETE SET NULL         ON UPDATE CASCADE 
    CONSTRAINT chat_fk_msj FOREIGN KEY (msj_anclado) REFERENCES MENSAJE(mensaje_id)
            -- ON DELETE SET NULL        ON UPDATE CASCADE
);
ALTER TABLE MENSAJE
    ADD CONSTRAINT mensaje_fk_chat  FOREIGN KEY (chat_grupo)  REFERENCES CHAT_GRUPO(codigo);
        -- ON DELETE SET NULL      ON UPDATE CASCADE

CREATE TABLE participacion (
   usuario      NUMBER(9) NOT NULL, 
   chat_grupo   CHAR(4)   NOT NULL,  
   fecha_inicio DATE      NOT NULL,
   CONSTRAINT participacion_pk PRIMARY KEY(usuario, chat_grupo),
   --
   CONSTRAINT participacion_fk_usuario
      FOREIGN KEY(usuario) REFERENCES miusuario(telefono),
      -- ON DELETE CASCADE
      -- ON UPDATE CASCADE
   CONSTRAINT participacion_fk_chatgrupo
      FOREIGN KEY(chat_grupo) REFERENCES chat_grupo(codigo) 
      -- ON DELETE CASCADE
      -- ON UPDATE CASCADE
);












