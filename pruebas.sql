//EJ1
select titulo, genero, edad_minima
from serie
where nacionalidad <> 'Espana' AND edad_minima < 18;

//EJ2
select distinct serie, temporada
from estoy_viendo
order by serie, temporada;

//EJ3
select serie, temporada, capitulo, titulo, duracion
from capitulo
where temporada >= 3 and duracion < 45
order by serie, temporada;

//EJ4 a medias
select usuario_id, nombre, f_registro
from usuario
where cuota between 50 and 100 and f_registro > '2020-05-20'
order by f_registro desc;

/EJ5
select distinct usuario
from estoy_viendo
where f_ultimo_acceso < '05/02/2025' AND minuto >= 15 
order by usuario;

//EJ6
select interprete_id, nombre, a_nacimiento
from interprete
where a_nacimiento between 1970 and 1979 and nacionalidad = 'Reino Unido'
order by a_nacimiento, nombre;

//EJ7 a medias
select nombre, to_char(fecha_registro, '%M%') AS mes_registro
from usuario
where nombre like '%ia%';

//EJ8
SELECT usuario_id, nombre, ROUND(cuota * 1.05, 2) AS nueva_cuota
FROM usuario
WHERE f_registro < '2021-01-01' AND cuota < 80
ORDER BY usuario_id;
