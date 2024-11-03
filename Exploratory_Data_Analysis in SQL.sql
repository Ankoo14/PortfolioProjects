
select * from 
layoffs_staging2;

select max(total_laid_off), max(percentage_laid_off) 
from layoffs_staging2;

-- WHere layoff is 100% means company shutdown completely and raised the funds in billions
select *
from layoffs_staging2
where percentage_laid_off=1
order by funds_raised_millions desc;

-- total employee laidoff from the company
select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

-- starting date of layoffs
select min(`date`), max(`date`)
from layoffs_staging2;

-- most industry hit in the layoffs

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;


-- percentage laidoff

select industry, max(percentage_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

-- country wise laid off

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

-- Year wise

select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;

-- STAGE of the company

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 1 desc;

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

-- Month and year wise layoff mostly: ASC/desc

select substring(`date`,1,7) as months, sum(total_laid_off) 
from layoffs_staging2
where substring(`date`,1,7) is not null
group by months
order by 1 ;

-- Rolling total month wise: it keeps adding the next month layoffs or aggregated sum 
-- and at last total layoffs by the end of march'23. GONNA DO IT BY USING CTE

WITH Rolling_Total AS 
(
select substring(`date`,1,7) as months, sum(total_laid_off) AS total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by months
order by 1
)
select months,total_off, sum(total_off) as total_sum
from Rolling_Total
group by months;


-- Company and year wise

select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc ;


-- Need to explore the below query again

WITH company_year(Company, Years, Total_laid_off)  AS
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc
)
select *, dense_rank() over (partition by years order by Total_laid_off desc) as layoff_rank
from company_year
where years is not null
order by layoff_rank ;

-- To find out the top 5 year wise most laid companies. BY ADDING ANOTHER CTE IN THE SAME QUERY


WITH company_year(Company, Years, Total_laid_off)  AS
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc
), Company_Year_Rank AS
(select *, dense_rank() over (partition by years order by Total_laid_off desc) as layoff_rank
from company_year
where years is not null
)
select * 
from Company_Year_Rank
where layoff_rank <=5;


select year(`date`) as Years, sum(total_laid_off)
from layoffs_staging2
group by Years
order by 2 desc;

select  sum(total_laid_off) as TOTAL_LAID_OFF
from layoffs_staging2
;
select  company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select  min(`date`), max(`date`)
from layoffs_staging2
;

-- SUBSTRING() AND CTE ARE AWESOME, HAVE TO USE THEM