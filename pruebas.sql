//S1.1. [F] Título, género y edad mínima recomendada de las series no españolas [observa que la
//nacionalidad española se indica con el texto 'Espana'] cuya edad mínima recomendada es inferior
//a 18 años. (titulo, genero, edad_minima)
  
select titulo, genero, edad_minima
from serie
where nacionalidad <> 'Espana' AND edad_minima < 18;

//S1.2. [F] Identificadores de las series y temporadas que los usuarios están viendo. Sin duplicados.
//Ordenado por serie y temporada. (serie, temporada).
  
select distinct serie, temporada
from estoy_viendo
order by serie, temporada;

//S1.3. [F] Capítulos de la temporada 3 o posterior de alguna serie, cuya duración sea inferior a 45
//minutos, ordenado por serie y temporada. (serie, temporada, capitulo, titulo, duracion).
  
select serie, temporada, capitulo, titulo, duracion
from capitulo
where temporada >= 3 and duracion < 45
order by serie, temporada;

//a medias S1.4. [F] Usuarios cuya cuota está entre 50 y 100 euros y que se registraron después del 20/05/2020,
//ordenados por fecha de registro, de más reciente a más antigua (usuario_id, nombre, f_registro).
  
select usuario_id, nombre, f_registro
from usuario
where cuota between 50 and 100 and f_registro > '2020-05-20'
order by f_registro desc;

//S1.5. [F] Identificador de los usuarios que desde antes del 05/02/2025 tienen pendiente de terminar
//algún capítulo del que visualizaron al menos 15 minutos. Sin duplicados y ordenado por
//usuario. (usuario).
  
select distinct usuario
from estoy_viendo
where f_ultimo_acceso < '05/02/2025' AND minuto >= 15 
order by usuario;

//S1.6 [F] Intérpretes nacidos en la década de los 70 (del siglo XX, claro) de nacionalidad británica
//('Reino Unido'), ordenado por año de nacimiento y por nombre. (interprete_id, nombre,
//a_nacimiento).

select interprete_id, nombre, a_nacimiento
from interprete
where a_nacimiento between 1970 and 1979 and nacionalidad = 'Reino Unido'
order by a_nacimiento, nombre;

//a medias S1.7. [F] Para cada usuario cuyo nombre incluye el texto ‘ia’, mostrar el nombre, email y mes (no la
//fecha, sino el mes en letras) en que se registró en la plataforma. (nombre, email, mes_registro).

select nombre, to_char(fecha_registro, '%M%') AS mes_registro
from usuario
where nombre like '%ia%';

//a medias S1.8. [F] Para cada usuario registrado antes del 1 de enero de 2021 y que paga una cuota inferior a
//80€, mostrar cómo quedaría su cuota si aumentara un 5% redondeada a dos decimales [Puedes
//utilizar la función ROUND(valor, numero_decimales)]. Ordenado por identificador de usuario.
//(usuario_id, nombre, nueva_cuota).

SELECT usuario_id, nombre, ROUND(cuota * 1.05, 2) AS nueva_cuota
FROM usuario
WHERE f_registro < '2021-01-01' AND cuota < 80
ORDER BY usuario_id;
