select * from netflix;

select count(*) as total_content from netflix;

select distinct type from netflix;

-- 15 business problems i will be solving
-- 1. Count the number of movies and TV shows. 

SELECT 
  type,
  COUNT(*) AS total_content
FROM netflix
GROUP BY type;


--2. find the most common rating for the movies and TV shows?

SELECT
  type,
  rating
FROM
  (
    SELECT
      type,
      rating,
      COUNT(*) AS total_count,
      RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM
      netflix
    GROUP BY
      type, rating
  ) AS t1
WHERE
  ranking = 1;

 --3. List all movies released in a specific year(i.e 2020)
-- filter movie
-- 2020

SELECT * 
FROM netflix
WHERE type = 'Movie'
  AND release_year = 2020;


--4.Find the top 5 countries with the most content on netflix

SELECT
  unnest(string_to_array(country, ',')) AS new_country,
  COUNT(show_id) AS total_content
FROM
  netflix
GROUP BY
  new_country
order by 2 desc
limit 5

--5.identify the longest movie?

SELECT * 
FROM netflix
WHERE type = 'Movie'
  AND duration = (SELECT MAX(duration) FROM netflix);


--6. Find content add in the last 5 years.

SELECT * 
FROM netflix 
WHERE TO_DATE(date_added, 'Month dd, yyyy') >= CURRENT_DATE - INTERVAL '5 years';

--7.Find all the movie/TV shows by director 'Rajiv Chilaka'?
Select * from netflix
where director ilike '%rajiv chilaka%'

--8. List all TV show with more than 5 seasons?

SELECT * 
FROM netflix 
WHERE type = 'TV Show'
  AND split_part(duration, ' ', 1)::numeric > 5;

--9. Count the number of content items in each genre.

SELECT
  unnest(string_to_array(listed_in, ',')) AS genre,
  COUNT(show_id) AS total_content
FROM netflix
GROUP BY genre;

--10. Find each year and the average number of content release by india on netflix.
--return top five year with highest avg content release.

 SELECT 
  EXTRACT(YEAR FROM TO_DATE(date_added, 'Month dd, yyyy')) AS year,
  COUNT(*) AS yearly_content,
  ROUND((COUNT(*)::numeric / (SELECT COUNT(*) FROM netflix WHERE country = 'India')) * 100, 2) AS avg_content_per_year
FROM 
  netflix
WHERE 
  country = 'India'
GROUP BY 
  year;

  
--11. List all movies that are documentaries.

SELECT * 
FROM netflix 
WHERE listed_in ILIKE '%documentaries';

--12. Find all content without a director.

SELECT * 
FROM netflix 
WHERE director IS NULL;

--13. Find how many movie actor 'Beth Chalmers' appeared in the last 10 years.

SELECT * 
FROM netflix 
WHERE casts ILIKE '%Beth chalmers%'
  AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;

--14.  Find the top 10 actor who have appeared in the highest number of movies produced in India.

SELECT 
  unnest(string_to_array(casts, ',')) AS actors,
  COUNT(*) AS total_content
FROM netflix
WHERE country ILIKE '%india'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

--15. Categorize the content based on the presence of the keywords 'kill' and 'violence'
--in the description filed. label content containing these keywords as 'bad'  and allm others as 'good' 
--count how many items fall into each category.


WITH new_table AS (
    SELECT *,
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'bad_content'
            ELSE 'good_content'
        END AS category
    FROM netflix
)
SELECT category,
       COUNT(*) AS total_content
FROM new_table
GROUP BY category;

)












 