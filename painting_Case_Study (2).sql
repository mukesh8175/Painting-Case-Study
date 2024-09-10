
-- 1. Fetch all the paintings which are not displayed on any museums?

select * from work
	where museum_id is NULL

-- 2. Are there museums without any paintings?

	
	select w.work_id from work w
	join museum m on m.museum_id=w.museum_id
    where museum_id not in (select m.museum_id from museum m
	where m.museum_id not null)



-- 3. How many paintings have an asking price of more than their regular price?
		
	select count(1) from product_size
	where sale_price>regular_price;

	
-- 4. Identify the paintings whose asking price is less than 50% of its regular price

select * from product_size
	where sale_price<(regular_price*0.5)

-- 5. Which canva size costs the most?


select cs.label as canva, ps.sale_price
	from  product_size ps
	join canvas_size cs on cs.size_id::text=ps.size_id
	order by  ps.sale_price desc
	limit 1;


-- 6. Delete duplicate records from work, product_size, subject and image_link tables


delete from subject 
	where ctid not in (select min(ctid)
						from subject
						group by work_id,subject);

delete from work 
	where ctid not in (select min(ctid)
						from work
						group by work_id );	



delete from product_size 
	where ctid not in (select min(ctid)
						from product_size
						group by work_id, size_id );


delete from image_link
	where ctid not in (select min(ctid)
						from image_link
						group by work_id,url );


-- 7. Identify the museums with invalid city information in the given dataset

select * from museum
	where city ~ '^[0-9]'


-- 8. Museum_Hours table has 1 invalid entry. Identify it and remove it.

delete from museum_hours 
	where ctid not in (select min(ctid)
						from museum_hours
						group by museum_id, day );

	
	
-- 9. Fetch the top 10 most famous painting subject
--	

select t.subject from
	(
	
	select count(ps.sale_price) as total_sale ,s.subject ,
	rank() over( order by count(ps.sale_price) desc ) as rnk
	from product_size ps
	join subject s on s.work_id=ps.work_id
	group by s.subject
	) t
	where t.rnk <=10;


--10. Identify the museums which are open on both Sunday and Monday. Display
--museum name, city.

select m.name,m.city from museum m
join museum_hours mh on m.museum_id=mh.museum_id
where mh.day='Sunday' 
and m.museum_id in (select mh.museum_id from museum_hours mh 
where mh.day='Monday');

--11. How many museums are open every single day?


SELECT COUNT(*)
FROM (
    SELECT m.museum_id
    FROM museum_hours m
    GROUP BY m.museum_id
    HAVING COUNT(DISTINCT m.day) = 7
) AS subquery;

-- 12. Which are the top 5 most popular museum? (Popularity is defined based on most
-- no of paintings in a museum)



select m.name ,m.city,t.total_painting from (
	select count(1) as total_painting,museum_id
		from work 
		group by museum_id
		order by total_painting desc ) t
	join museum m on m.museum_id=t.museum_id
	order by t.total_painting desc
	limit 5


	 				--OR 

	
	select m.name as museum, m.city,m.country,x.no_of_painintgs
	from (	select m.museum_id, count(1) as no_of_painintgs
			, rank() over(order by count(1) desc) as rnk
			from work w
			join museum m on m.museum_id=w.museum_id
			group by m.museum_id) x
	join museum m on m.museum_id=x.museum_id
	where x.rnk<=5;


-- 13. Who are the top 5 most popular artist? (Popularity is defined based on most no of
-- paintings done by an artist)

   select  ar.first_name,count(w.work_id) as total_painting
	   from artist ar
	   join work w on w.artist_id=ar.artist_id
	   group by ar.first_name
	   order by total_painting desc
	   limit 5;
	   


-- 14. Display the 3 least popular canva sizes

select cs.size_id
	from product_size ps
	join canvas_size cs on cs.size_id::text =ps.size_id
	group by cs.size_id
	order by count(ps.work_id)
	limit 3




-- 15. Which museum is open for the longest during a day. Dispay museum name, state
-- and hours open and which day?

	
select m.name,m.state,mh.day,
	to_timestamp(mh.close,'HH:MI pm')- to_timestamp(mh.open,'HH:MI am')as during
	from museum m
	join museum_hours mh on mh.museum_id=m.museum_id
	order by during desc
	limit 1;



-- 16. Which museum has the most no of most popular painting style?


	with pop_style as 
			(select style
			,rank() over(order by count(1) desc) as rnk
			from work
			group by style),
		cte as
			(select w.museum_id,m.name as museum_name,ps.style, count(1) as no_of_paintings
			,rank() over(order by count(1) desc) as rnk
			from work w
			join museum m on m.museum_id=w.museum_id
			join pop_style ps on ps.style = w.style
			where w.museum_id is not null
			and ps.rnk=1
			group by w.museum_id, m.name,ps.style
	)
	select museum_name,style,no_of_paintings
	from cte 
	where rnk=1;



-- 17. Identify the artists whose paintings are displayed in multiple countries


with cte as
		(select distinct a.full_name as artist, m.country
		from work w
		join artist a on a.artist_id=w.artist_id
		join museum m on m.museum_id=w.museum_id)
	select artist,count(artist) as no_of_countries
	from cte
	group by artist
	having count( artist )>1 
	order by 2 desc;


--18) Display the country and the city with most no of museums. 
--Output 2 seperate columns to mention the city and country.
--If there are multiple value, seperate them with comma.	


with cte as(
	select count(museum_id), country,city,
		rank() over (order by count(museum_id) desc ) as rnk
		from museum
		group by country,city
		order by count(museum_id) desc
	)
select string_agg( distinct country, ',') as country,
   string_agg(distinct city,',') as city
	from cte
	where rnk=1



--19) Identify the artist and the museum where the most expensive and least expensive painting is placed. 
--Display the artist name, sale_price, painting name, museum name, museum city and canvas lab



	with cte as (
		select sale_price,
	rank() over( order by sale_price desc) as rnk_dec,
	row_number() over( order by sale_price ) as rnk_asc
		from product_size 
		 )
	
		select ar.first_name as artist_name,m.name as museum_name, 
		w.name as painting_name,can.label as canvas,
		m.city as museum_city ,ps.sale_price    
		from product_size ps
		join cte on cte.sale_price=ps.sale_price
		join work w on w.work_id=ps.work_id 
		join canvas_size can on can.size_id::text=ps.size_id
		join artist ar on w.artist_id=ar.artist_id
		join museum m on m.museum_id=w.museum_id
		where cte.rnk_dec=1 or cte.rnk_asc=1


--20) Which country has the 5th highest no of paintings?


	select no_of_painting,country
	from(
		select count(w.work_id ) as no_of_painting,
		m.country as country,
		rank() over(order by count(work_id ) desc) as rnk
		from work w
		join museum m on w.museum_id=m.museum_id
		group by country
		order by no_of_painting desc) 
		where rnk=5


--21) Which are the 3 most popular and 3 least popular painting styles?


select style,
	case 
		when rnk_dsc <=3 then 'most_popular'
		when rnk_asc <=3 then 'least_popular'
		end as remark
	
	from(
	select style,
	rank() over(order by  count(style) desc) as rnk_dsc,
	rank() over(order by  count(style) ) as rnk_asc
	from work w
	where style notnull
	group by style
	order by count(style) desc)
	where rnk_dsc in (1,2,3) or rnk_asc in (1,2,3)



select * from artist
select * from canvas_size
select * from image_link
select * from product_size
select * from subject
select * from work
select * from museum
select * from museum_hours

--22) Which artist has the most no of Portraits paintings outside USA?.
	--Display artist name, no of paintings and the artist nationality.



	select count(sub.subject) as no_of_painting,sub.subject,ar.full_name,ar.nationality,
	rank() over (order by count(sub.subject) desc) as rnk
	from subject sub
	join work w on w.work_id=sub.work_id
	join artist ar on ar.artist_id =w.artist_id
	join museum m on m.museum_id=w.museum_id
	where sub.subject='Portraits' and m.country not in
	(select country from museum where country='USA')
	group by sub.subject,ar.full_name,ar.nationality
	order by no_of_painting desc
	limit 1
	


						--OR


select full_name as artist_name, nationality, no_of_paintings
	from (
		select a.full_name, a.nationality
		,count(1) as no_of_paintings
		,rank() over(order by count(1) desc) as rnk
		from work w
		join artist a on a.artist_id=w.artist_id
		join subject s on s.work_id=w.work_id
		join museum m on m.museum_id=w.museum_id
		where s.subject='Portraits'
		and m.country != 'USA'
		group by a.full_name, a.nationality) x
	where rnk=1;
	


