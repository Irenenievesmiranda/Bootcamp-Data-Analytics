use transactions;
-- NIVEL 1:
-- Ejercicio 2: Utilizando JOIN realizarás las siguientes consultas:
# a) Listado de los países que están realizando compras.
SELECT DISTINCT country FROM company
WHERE declined = 0;

# b) Desde cuántos países se realizan las compras.
SELECT COUNT(DISTINCT country) FROM company
WHERE declined = 0;

# c) Identifica a la compañía con la mayor media de ventas.
SELECT t.company_id, c.company_name, AVG(t.amount) AS media_ventas
FROM transaction t
JOIN company c
ON t.company_id = c.company_id 
WHERE declined = 0
GROUP BY company_id, company_name
ORDER BY media_ventas DESC
LIMIT 1;

-- Ejercicio 3: Utilizando sólo subconsultas (sin utilizar JOIN):
# a) Muestra todas las transacciones realizadas por empresas de Alemania.
SELECT *
FROM transaction
WHERE company_id IN (
	SELECT company_id 
    FROM company
    WHERE country = 'Germany');

# b)Lista las empresas que han realizado transacciones por un amount superior a la media de todas las transacciones.
SELECT company_name
FROM company
WHERE company_id IN (
	SELECT company_id
    FROM transaction 
    where amount > (
		Select 
		AVG(amount)
        FROM transaction
        WHERE declined = 0));

# c)Eliminarán del sistema las empresas que carecen de transacciones registradas, entrega el listado de estas empresas.
select company_name
from company
where company_id not in(
select company_id
from transaction);
#Obtenemos un listado vacio, por lo que todas las empresas han hecho alguna transaccion. (comprobado con join)

-- NIVEL 2:
# Ejercicio 1: Identifica los cinco días que se generó la mayor cantidad de ingresos en la empresa por ventas. 
# Muestra la fecha de cada transacción junto con el total de las ventas.
SELECT DATE(timestamp), SUM(amount) AS Total_dia
FROM transaction
WHERE declined = 0
GROUP BY DATE(timestamp)
ORDER BY Total_dia DESC
LIMIT 5;

# Ejercicio 2: ¿Cuál es la media de ventas por país? Presenta los resultados ordenados de mayor a menor medio.
SELECT c.country, ROUND(AVG(t.amount),2) AS Media_ventas
FROM company c
JOIN transaction t
ON c.company_id = t.company_id
WHERE declined = 0
GROUP BY c.country
ORDER BY Media_ventas DESC;

# Ejercicio 3: En tu empresa, se plantea un nuevo proyecto para lanzar algunas campañas publicitarias para hacer competencia a la compañía “Non Institute”. 
# Para ello, te piden la lista de todas las transacciones realizadas por empresas que están ubicadas en el mismo país que esta compañía.
# a) Muestra el listado aplicando JOIN y subconsultas.
SELECT *
FROM transaction
WHERE company_id IN (SELECT t.company_id 
					FROM transaction t
                    JOIN company c
                    ON t.company_id = c.company_id
                    WHERE country = (SELECT country
									FROM company
                                    WHERE company_name = 'Non Institute'));

# b) Muestra el listado aplicando solo subconsultas.
SELECT *
FROM transaction
WHERE company_id IN (SELECT company_id 
					FROM company 
                    WHERE country = (SELECT country
									FROM company
									WHERE company_name = 'Non Institute'));

-- NIVEL 3:
# Ejercicio 1: Presenta el nombre, teléfono, país, fecha y amount, de aquellas empresas que realizaron transacciones 
# con un valor comprendido entre 100 y 200 euros y en alguna de estas fechas: 
# 29 de abril de 2021, 20 de julio de 2021 y 13 de marzo de 2022. Ordena los resultados de mayor a menor cantidad.
SELECT c.company_name, c.phone, c.country, DATE_FORMAT(timestamp, '%d/%m/%Y') AS fecha_formateada, t.amount
FROM company c
JOIN transaction t
ON c.company_id = t.company_id
WHERE t.amount between 100 and 200
AND declined = 0
HAVING fecha_formateada IN ('29/04/2021', '20/07/2021', '13/03/2022')
order by t.amount DESC;

# Ejercicio 2: Necesitamos optimizar la asignación de los recursos y dependerá de la capacidad operativa que se requiera, 
# por lo que te piden la información sobre la cantidad de transacciones que realizan las empresas, pero el departamento de recursos humanos es exigente 
# y quiere un listado de las empresas en las que especifiques si tienen más de 4 transacciones o menos.

SELECT c.company_name, SUM(t.transaction_id) AS Total_transactions, 
CASE WHEN SUM(t.transaction_id) >= 4 THEN 'Yes'
ELSE 'No'
END AS More_than_4_trans
FROM company c
JOIN transaction t
ON c.company_id = t.company_id
GROUP BY C.company_name;


