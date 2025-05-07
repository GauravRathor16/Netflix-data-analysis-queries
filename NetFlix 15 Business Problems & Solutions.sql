Create Database NetFlix;
use Netflix;

Create Table [netflix(CV)] ( Show_ID varchar(100),
                             Type Varchar (100),
							 Title Varchar(100),
							 Director varchar(100),
							 Cast Varchar (200),
							 Date_Added Date,
							 Release_Year bigint,
							 Rating varchar(100),
							 Duration varchar(100),
							 Listed_In varchar (200),
							 Description varchar(100)
							 );


select * from [netflix(CV)];

--1. Count the number of Movies vs TV Shows


select Type,  COUNT(*) AS number_of_shows 
from [netflix(CV)] 
group by Type;


--2. Find the most common rating for movies and TV shows

select Top 1 Rating, COUNT(*) as most_common_rating
from [netflix(CV)]
where Type In ( 'Movie' , 'TV Show')
Group by Rating
order by most_common_rating desc;


--3. List all movies released in a specific year (e.g., 2020)

select Show_Id, Type, Title, Release_Year, Rating 
from [netflix(CV)]
where Release_Year = 2020
      and Type = 'Movie';



--4. Find the top 5 countries with the most content on Netflix

select TOP 5 Country , COUNT(*) AS COUNT
FROM [netflix(CV)]
WHERE Country <> ' '
GROUP BY Country
ORDER BY COUNT DESC;


--Identify the longest movie

SELECT TOP 1 Title, Country, Duration, Description
FROM [netflix(CV)]
WHERE type = 'Movie'
  AND Duration IS NOT NULL
ORDER BY 
  TRY_CAST(LEFT(Duration, CHARINDEX(' ', Duration + ' ') - 1) AS INT) DESC;


  --6. Find content added in the last 5 years

  select * 
  from [netflix(CV)]
  where Date_Added >= DATEADD(year, -5, GETDATE());


  --7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

  Select * 
  from [netflix(CV)]
  Where Director IN ('Rajiv Chilaka');


 -- 8. List all TV shows with more than 5 seasons

 Select Title, Type, Rating, Duration, Release_Year
 From [netflix(CV)]
 Where Type IN ('TV Show')
	AND TRY_CAST(LEFT(Duration, CHARINDEX(' ', Duration + ' ') -1) As int) > 5;


--9. Count the number of content items in each genre


with exploded_Genre as (
                       Select TRIM(value) as Genre
					   from [netflix(CV)]
					   CROSS APPLY STRING_SPLIT(Listed_In, ',')
					   )
Select Genre, COUNT(*) as number_of_conent_items
From exploded_Genre
Group by Genre;


--10.Find each year and the average numbers of content release in India on netflix. 


Select Top 5 YEAR(Date_Added) as Year, COUNT(*) as average_numbers_of_content_release
From [netflix(CV)]
Where Country IN ('India')
Group by YEAR(Date_Added)
Order by average_numbers_of_content_release DESC;



--11. List all movies that are Documentaries

Select Type, Title, Listed_In
From [netflix(CV)]
Where Type IN ('Movie')
And Listed_In IN ( 'Documentaries');


--12. Find all content without a director

Select * 
From [netflix(CV)]
Where Director = ' ';


--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * 
From [netflix(CV)]
Where Cast Like '%Salman Khan%'
And Type = 'Movie'
and Date_Added >= DATEADD(YEAR, -10, GETDATE());




--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.


with exploded_cast as ( 
                       Select TRIM(value) as Actor
					   from [netflix(CV)]
					   CROSS APPLY STRING_SPLIT(cast, ',')
					   Where Type Like '%Movie%'
					   And Country Like '%India%'
					   AND cast IS NOT NULL
					   )
Select Top 10 Actor, COUNT(*) as Count
From exploded_cast
Group by Actor
order by Count DESC;


--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.




Select 
      CASE
	      WHEN Description Like '%Kill%' or  Description Like '%violence%' Then 'Bad'
		  else 'Good'
	 End as content_category,
COUNT(*) as Total_Count
From [netflix(CV)]
WHERE description IS NOT NULL
Group by  CASE
	      WHEN Description Like '%Kill%' or  Description Like '%violence%' Then 'Bad'
		  else 'Good'
	 End;







