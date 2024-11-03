-- STEP 1: REMOVNG DUPLICATES --

-- TO CHECK DUPLICATES BY Window function: ROW_NUM() and CTE

select * from layoffs_staging;

-- checking duplicates by using row_num & partition on every columns 


select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, 
`date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging;

-- to check VALUE row_num > 1, 
-- so that we can find the any combination of combined column is duplicate 
WITH duplicate_cte AS
(
SELECT *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, 
`date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
select * from duplicate_cte
where row_num > 1
;

-- TO remove actual duplicate values we created the copy of layoffs_staging


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from layoffs_staging2;

insert into layoffs_staging2
SELECT *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, 
`date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging;

select * from layoffs_staging2
where row_num>1;

-- Duplicates are being removed by below query

DELETE from layoffs_staging2
where row_num>1;

-- STEP 2:STANDARDIZING THE DATA--

-- TRIM

select company, TRIM(company)
from layoffs_staging2;

-- Updating the TRIM in our staging2 table
Update layoffs_staging2 
SET company = TRIM(company)
;

select *
from layoffs_staging2;

select distinct industry
from layoffs_staging2
order by 1;

select * 
from layoffs_staging2
where industry like "crypto%";

update layoffs_staging2
set industry = "Crypto"
where industry like "Crypto%";

select *
 from layoffs_staging2
 where country = "United States.";
 
 -- Removing dot(.) from the country(United States) from the end
 
 select distinct country, trim(trailing '.' from country)
 from layoffs_staging2
 order by 1;
 -- Updating it
 update layoffs_staging2
 SET country = trim(trailing '.' from country)
 where country like 'United States%';
 
 select distinct country
 from layoffs_staging2;
 
 -- Correcting the date format from text to date
 
 select `date`,
 STR_TO_DATE(`date`,'%m/%d/%Y')
from layoffs_staging2;
 
 update layoffs_staging2
 SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');
 
 select `date`
from layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
from layoffs_staging2;

-- STEP 3: REMOVING NULL VALUES --

-- Remove NULL

select * from 
layoffs_staging2
where total_laid_off is null 
and
percentage_laid_off is null;

Update layoffs_staging2
set industry = null
where industry = '';

select *
from layoffs_staging2
where industry is null or industry = "";

select *
from layoffs_staging2
where company = "Airbnb";

-- Checking 

SELECT t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry is null or t1.industry='')
and t2.industry is not null;    

Update layoffs_staging2 t1
join layoffs_staging2 t2
	ON t1.company = t2.company
set t1.industry = t2.industry
WHERE t1.industry is null 
and t2.industry is not null; 

select *
from layoffs_staging2
where company like "Bally's Interactive%";

select * from 
layoffs_staging2
where total_laid_off is null 
and
percentage_laid_off is null;

-- STEP 4: REMOVING COLUMNS --

select * from 
layoffs_staging2
where total_laid_off is null 
and
percentage_laid_off is null;

Delete from 
layoffs_staging2
where total_laid_off is null 
and
percentage_laid_off is null;

Select * from 
layoffs_staging2;

-- Removing row_num Column from the table

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;