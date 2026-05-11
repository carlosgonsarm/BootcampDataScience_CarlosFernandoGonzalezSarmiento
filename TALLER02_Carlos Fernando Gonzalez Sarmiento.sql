## Taller 2 SQL Carlos Fernando Gonzalez Sarmiento

# Conexión
USE sakila;

# Parte 1 – SELECT y WHERE -----------------------------------------------------------------------
# 1. Mostrar nombre y apellido de todos los clientes

select first_name,last_name from customer;

# 2. Películas con duración mayor a 120 minutos
# Dice mayor explicitamente

select * from film
where length > 120;

#Parte 2 – ORDER BY -----------------------------------------------------------------------

# 3. Ordenar clientes por apellido --> Por orden alfabetico de la A a la Z

select * from customer
order by last_name ASC;

# 4. Top 5 películas más largas --> TIP: Use la palabra LIMIT

select * from film
order by length DESC
LIMIT 5;

#Parte 3 – INNER JOIN -----------------------------------------------------------------------
# 5. Cantidad pagada y fecha del pago con nombre y apellido del cliente (JOIN entre Payment - Customer)

SELECT * from payment; #Para información
SELECT * from customer; #Para información

SELECT payment.amount, payment.payment_date, customer.first_name, customer.last_name FROM payment
JOIN customer ON customer.customer_id = payment.customer_id;

# 6. Películas alquiladas (JOIN entre Rental - Inventory - Film)

SELECT * from rental; #Para información
SELECT * from inventory; #Para información
SELECT * from film; #Para información

SELECT rental.rental_id, rental.rental_date, film.title FROM inventory
JOIN film ON film.film_id = inventory.film_id
JOIN rental ON rental.inventory_id = inventory.inventory_id;
# No se especificó que campos traer pero yo dejé id de renta, fecha de renta y titulo de la pelicula, para no traer todos los campos

#Parte 4 – LEFT JOIN -----------------------------------------------------------------------
# 7. Nombre y apellido de clientes sin pagos (LEFT JOIN entre Payment - Customer pero usando WHERE)

SELECT * from payment; #Para información
SELECT * from customer; #Para información

# En esta usaré alias aunque no se especifique
SELECT t1.first_name,t1.last_name FROM customer AS t1
LEFT JOIN payment AS t2 ON t1.customer_id = t2.customer_id
WHERE t2.customer_id IS NULL;
#Aparece vacío, eso quiere decir que todos los clientes tienen al menos un pago


# 8. Listar los nombres de las peliculas y su duracion de aquellos titulos que no tienen actores

SELECT * from film; #Para información
SELECT * from film_actor; #Para información

SELECT t1.title,t1.length FROM film AS t1
LEFT JOIN film_actor AS t2 ON t1.film_id = t2.film_id
WHERE t2.film_id IS NULL;
# 3 peliculas sin actores

#Parte 5 – INSERT, UPDATE, DELETE (Data Definition Language ) -----------------------------------------------------------------------
# 9. Insertar actor temporal

SELECT * from actor; #Para información

INSERT INTO actor (first_name, last_name)
VALUES ('CARLOS','GONZALEZ');

SELECT * from actor
WHERE first_name='CARLOS';
# Ahí está

# 10. Actualizar actor

UPDATE actor
SET 
first_name = 'CARLITOS',
last_name = 'CAGE'
WHERE actor_id = '202';
# En mi caso es el 202 porque ya había agregado algo a la base

SELECT * from actor
WHERE actor_id='202';
# Ahí está

#Comprobemos que no hay ningun Carlos
SELECT * from actor
WHERE first_name='CARLOS';	

# 11. Eliminar actor
DELETE FROM actor
WHERE actor_id = 202;

SELECT * FROM Actor
WHERE actor_id = 202;
# Vacio

#Parte 6 - Consultas Avanzadas -----------------------------------------------------------------------

# 12. Top 5 clientes con mayor cantidad de dinero pagado al servicio de rentas

SELECT * from payment; #Para información
SELECT * from customer; #Para información

SELECT t1.customer_id, t1.first_name, t1.last_name, sum(t2.amount)AS total_pagado FROM customer as t1
join payment AS t2 ON t1.customer_id = t2.customer_id
GROUP BY t1.customer_id, t1.first_name, t1.last_name
ORDER BY total_pagado DESC
LIMIT 5;

# 13. Top 5 Películas más alquiladas (JOIN entre Rental - Inventory - Film) --> Agrupar los datos con conteo y tomar las mejores 5

SELECT * from rental; #Para información
SELECT * from inventory; #Para información
SELECT * from film; #Para información

SELECT t2.title, count(t2.title)as recuento_alquiladas FROM inventory as t1
JOIN film as t2 ON t2.film_id = t1.film_id
JOIN rental as t3 ON t3.inventory_id = t1.inventory_id
GROUP BY t2.title
ORDER BY recuento_alquiladas DESC
LIMIT 5;