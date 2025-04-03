/*
Asignatura: (1903) Bases de Datos
Curso: 2024/25
Convocatoria: junio

Practica: P2. Consultas en SQL

Equipo de practicas: *****
 Integrante 1: Pablo Belchi Corredor             
 Integrante 2: Daniel Cascales Marcos
*/

-- EJERCICIOS:


--Q4



DESCRIBE SERIE
DESCRIBE USUARIO
DESCRIBE INTERES
DESCRIBE ESTOY_VIENDO




SELECT serie_id,titulo,genero
FROM serie
WHERE serie_id IN(
    SELECT serie
    FROM interes
    WHERE usuario IN(
        SELECT usuario_id
        FROM usuario
        WHERE f_registro BETWEEN '31/12/2021' AND '01/01/2023'
    )
)OR
serie_id IN(
    SELECT serie
    FROM estoy_viendo
    WHERE usuario IN(
        SELECT usuario_id
        FROM usuario
        WHERE cuota > '70'
    )
)
ORDER BY genero
;







--Q5

SELECT serie_id, titulo, edad_minima
FROM SERIE
WHERE genero = 'Drama' AND serie_id IN 
    (SELECT serie
    FROM interes
    WHERE usuario NOT IN (
        SELECT usuario
        FROM ESTOY_VIENDO
        WHERE serie = INTERES.serie
    )
)
;



--Q6


SELECT S.serie_id AS serie, (
    SELECT COUNT(*)
    FROM TEMPORADA T
    WHERE T.serie = S.serie_id
) AS n_temporadas
FROM SERIE S
WHERE (
    SELECT COUNT(DISTINCT I.interprete_id)
    FROM INTERPRETE I, REPARTO R
    WHERE I.interprete_id = R.interprete
    AND R.serie = S.serie_id
    AND I.nacionalidad = 'Reino Unido'
) > 5
;








