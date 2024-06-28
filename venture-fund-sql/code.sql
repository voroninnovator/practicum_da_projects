-- 1
SELECT *
FROM company
WHERE status = 'closed';

--2
SELECT funding_total
FROM company
WHERE country_code = 'USA'
    AND category_code = 'news'
ORDER BY funding_total DESC;

--3
SELECT SUM(price_amount)
FROM acquisition
WHERE term_code = 'cash'
AND EXTRACT('YEAR' FROM acquired_at) BETWEEN '2011' AND '2013';

--4
SELECT 
    first_name,
    last_name,
    network_username
FROM people
WHERE network_username LIKE 'Silver%';

--5
SELECT *
FROM people
WHERE network_username LIKE '%money%'
AND last_name LIKE 'K%';

--6
SELECT 
    country_code,
    SUM(funding_total)
FROM company
GROUP BY country_code
ORDER BY SUM(funding_total) DESC;

--7
SELECT 
    funded_at,
    MAX(raised_amount),
    MIN(raised_amount)
FROM funding_round
GROUP BY funded_at
HAVING MIN(raised_amount) != 0
    AND MIN(raised_amount) != MAX(raised_amount);

--8
SELECT *,
    CASE
    WHEN invested_companies >= 100 THEN 'high_activity'
    WHEN invested_companies >= 20 AND invested_companies < 100 THEN 'middle_activity'
    ELSE 'low_activity'
    END
FROM fund;

--9
SELECT
       CASE
           WHEN invested_companies>=100 THEN 'high_activity'
           WHEN invested_companies>=20 THEN 'middle_activity'
           ELSE 'low_activity'
       END AS activity,
       ROUND(AVG(investment_rounds))
FROM fund
GROUP BY activity
ORDER BY ROUND(AVG(investment_rounds));

--10
SELECT 
    country_code,
    MIN(invested_companies),
    MAX(invested_companies),
    AVG(invested_companies)
FROM fund
WHERE EXTRACT(YEAR FROM founded_at) BETWEEN 2010 AND 2012
GROUP BY country_code
HAVING MIN(invested_companies) > 0
ORDER BY AVG(invested_companies) DESC, country_code
LIMIT 10;

--11
SELECT
    p.first_name,
    p.last_name,
    e.instituition
FROM people p
LEFT JOIN education e ON e.person_id = p.id;

-- 12
SELECT 
    c.name,
    COUNT(DISTINCT e.instituition)
FROM people p
JOIN company c ON company_id = c.id
LEFT JOIN education e ON p.id = e.person_id
GROUP BY c.name
ORDER BY COUNT(DISTINCT e.instituition) DESC
LIMIT 5;

--13
SELECT DISTINCT(C.NAME)
FROM company c
JOIN funding_round fr ON c.id = fr.company_id
WHERE c.status = 'closed'
    AND fr.is_first_round = 1
    AND fr.is_last_round = 1;

--14
SELECT DISTINCT(p.id)
FROM people p
JOIN company c on p.company_id = c.id
JOIN funding_round fr on c.id = fr.company_id
WHERE c.status = 'closed'
    AND fr.is_first_round=1
    AND fr.is_last_round=1;

--15
SELECT DISTINCT(p.id),
    e.instituition
FROM people p
JOIN company c on p.company_id = c.id
JOIN funding_round fr on c.id = fr.company_id
LEFT JOIN education e ON p.id = e.person_id
WHERE c.status = 'closed'
    AND fr.is_first_round=1
    AND fr.is_last_round=1
    AND e.instituition IS NOT NULL;

--16
WITH fr AS (
    SELECT company_id
    FROM funding_round
    WHERE is_first_round = 1
    AND is_last_round = 1
), 
closed_companies AS (
    SELECT c.id
    FROM company AS c
    JOIN fr ON fr.company_id = c.id
    WHERE c.status = 'closed'
),
p AS (
    SELECT DISTINCT p.id
    FROM people AS p
    WHERE p.company_id IN (SELECT id FROM closed_companies)
)
SELECT 
    p.id AS employee_id,
    COUNT(e.instituition) AS institution_count
FROM 
    education AS e
JOIN 
    p ON p.id = e.person_id
GROUP BY 
    p.id
ORDER BY 
    employee_id;

--17
WITH fr AS (
    SELECT company_id
    FROM funding_round
    WHERE is_first_round = 1
    AND is_last_round = 1
),
closed_companies AS (
    SELECT c.id
    FROM company AS c
    JOIN fr ON fr.company_id = c.id
    WHERE c.status = 'closed'
),
p AS (
    SELECT DISTINCT p.id
    FROM people AS p
    WHERE p.company_id IN (SELECT id FROM closed_companies)
),
employee_education AS (
    SELECT 
        p.id AS employee_id,
        COUNT(e.instituition) AS institution_count
    FROM 
        education AS e
    JOIN 
        p ON p.id = e.person_id
    GROUP BY 
        p.id
)
SELECT 
    AVG(institution_count)
FROM 
    employee_education;

--18
WITH fr AS (
    SELECT company_id
    FROM funding_round
), 
p AS (
    SELECT DISTINCT p.id
    FROM people AS p
    WHERE p.company_id IN (
        SELECT DISTINCT c.id
        FROM company AS c
        JOIN fr ON fr.company_id = c.id
        WHERE c.name LIKE '%Socialnet%'
    )
), 
pe AS (
    SELECT p.id,
           COUNT(e.instituition) AS institution_count
    FROM education AS e
    JOIN p ON p.id = e.person_id
    GROUP BY p.id
) 
SELECT AVG(institution_count) AS avg_institution_count
FROM pe;

--19
WITH fr AS (
    SELECT *
    FROM funding_round AS fr
    WHERE funded_at BETWEEN '2012-01-01'
    AND '2013-12-31'
),
c AS (SELECT *
     FROM company
     WHERE milestones > 6)
SELECT 
    f.name AS name_of_fund,
    c.name AS name_of_company,
    fr.raised_amount AS amount
FROM investment AS i
JOIN c ON c.id = i.company_id
JOIN fund AS f ON f.id = i.fund_id
JOIN fr ON fr.id = i.funding_round_id;

--20
WITH c2 AS (
    SELECT *
    FROM company
    WHERE funding_total > 0
)
SELECT c1.name AS acquiring_company_name, 
    a.price_amount, 
    c2.name AS acquired_company_name, 
    c2.funding_total, 
    ROUND(A.PRICE_AMOUNT / c2.funding_total)
FROM acquisition AS a
LEFT JOIN company AS c1 ON c1.id = a.acquiring_company_id 
LEFT JOIN company AS c2 ON c2.id = a.acquired_company_id  
WHERE  a.price_amount > 0
AND c2.funding_total > 0
ORDER BY  a.price_amount DESC, c2.name 
LIMIT 10;

--21
WITH
fr AS (
    SELECT company_id, 
              EXTRACT(MONTH FROM funded_at) AS funded_month
       FROM   funding_round
       WHERE  funded_at BETWEEN '2010-01-01' AND '2013-12-31'
       AND    raised_amount > 0
), 
c AS (
    SELECT id, 
             name
      FROM   company
      WHERE  category_code = 'social'
) 
SELECT c.name, 
       fr.funded_month
FROM   c 
JOIN   fr ON fr.company_id = c.id

--22
WITH invest AS (
    SELECT EXTRACT(MONTH FROM fr.funded_at) AS funded_month, 
                  COUNT(DISTINCT f.id) AS count_fund
           FROM   investment AS i 
           JOIN   funding_round AS fr ON fr.id = i.funding_round_id
           JOIN   fund AS f ON f.id = i.fund_id
           WHERE  f.country_code = 'USA'
           AND    fr.funded_at BETWEEN '2010-01-01' AND '2013-12-31'
           GROUP BY funded_month
), 
acquired AS (
    SELECT EXTRACT(MONTH FROM acquired_at) AS acquired_month, 
                    COUNT(acquired_company_id) AS count_company, 
                    SUM(price_amount) AS sum_price_amount 
             FROM   acquisition
             WHERE  acquired_at BETWEEN '2010-01-01' AND '2013-12-31'
             GROUP BY acquired_month
) 
SELECT invest.funded_month, 
       invest.count_fund, 
       acquired.count_company,
       acquired.sum_price_amount
FROM   invest
JOIN   acquired ON acquired.acquired_month = invest.funded_month;

--23
WITH
inv_2011 AS (SELECT co.country_code, 
                    AVG(co.funding_total) 
             FROM company AS co
             WHERE EXTRACT(YEAR FROM co.founded_at) = 2011
             GROUP BY co.country_code 
             HAVING COUNT(co.id) > 0), 

inv_2012 AS (SELECT co.country_code, 
                    AVG(co.funding_total) 
             FROM company AS co 
             WHERE EXTRACT(YEAR FROM co.founded_at) = 2012 
             GROUP BY co.country_code 
             HAVING COUNT(co.id) > 0),

inv_2013 AS (SELECT co.country_code, 
                    AVG(co.funding_total) 
             FROM company AS co 
             WHERE EXTRACT(YEAR FROM co.founded_at) = 2013 
             GROUP BY co.country_code 
             HAVING COUNT(co.id) > 0)

SELECT inv_2011.country_code,
       inv_2011.avg AS inv_2011,
       inv_2012.avg AS inv_2012,
       inv_2013.avg AS inv_2013
FROM inv_2011
INNER JOIN inv_2012 ON inv_2012.country_code = inv_2011.country_code
INNER JOIN inv_2013 ON inv_2013.country_code = inv_2011.country_code
ORDER BY inv_2011.avg DESC;