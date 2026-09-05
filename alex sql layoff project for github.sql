use layoff_emp;
select * from layoffs;

use layoff_emp;
select * from layoffs;

-- remove duplicates
-- standardized the data 
-- null values or blank values
-- unnecesary columns remove

create table layoffs_stage
like layoffs;

select * from layoffs_stage;

insert layoffs_stage
select * from layoffs;

select * from layoffs_stage;

select *, row_number() over(partition by company,industry,total_laid_off,percentage_laid_off,`date`) as row_num 
from layoffs_stage;


with duplicate_coulumn as
(
select *, row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num 
from layoffs_stage
)
select * from duplicate_coulumn
where row_num > 1;

select * from layoffs_stage;

create table layoff2
like layoffs_stage;

select * from layoff2;

insert layoff2
select distinct * from layoffs_stage;

select * from layoff2;


with duplicate_coulumn as
(
select *, row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num 
from layoff2
)
select * from duplicate_coulumn
where row_num > 1;

select * from layoff2;

select company, trim(company) from layoff2;

update layoff2
set company = trim(company);

use layoff_emp;
show tables;

select * from layoff2;
select length(company),company
from layoff2
order by company desc
limit 1,1;

update layoff2
set company = trim(company);

select * from layoff2;
select length(company),company
from layoff2
order by company desc
limit 1,1;


use layoff_emp;

select * from layoff2;

select distinct(industry) from layoff2
order by industry;

update layoff2
set industry = "Crypto"
where industry like 'Crypto%';

select distinct(industry) from layoff2
order by industry;


select distinct(country) from layoff2
order by country;

select distinct(country) from layoff2
where country like 'United States%';


update layoff2
set country = trim(trailing '.' from country)
where country like 'United States%';


select distinct(country) from layoff2
order by country;

select `date`
from layoff2;

use layoff_emp;

select * from layoff2;

update layoff2
set `date`= str_to_date(`date`,'%m/%d/%Y');

select `date`
from layoff2;

alter table layoff2
modify column `date` date;


select * from layoff2;


select * from layoff2
where industry is null
or industry = '';

select * from layoff2
where company = 'airbnb';


select * from layoff2 lay1
join layoff2 lay2 on lay1.company = lay2.company
and lay1.location = lay2.location
where (lay1.industry is null or lay1.industry ='')
and lay2.industry is not null;	

update layoff2
set industry = null
where industry = '';


update layoff2 lay1 
join layoff2 lay2 on lay1.company = lay2.company
set lay1.industry = lay2.industry
where lay1.industry is null
and lay2.industry is not null;	

select * from layoff2
where industry is null;

select * from layoff2
where total_laid_off is null
and percentage_laid_off is null;


select * from layoff2;


delete from layoff2
where total_laid_off is null
and percentage_laid_off is null;

use layoff_emp;
select * from layoff2;

select max(total_laid_off), max(percentage_laid_off) from layoff2;


select * from layoff2
where percentage_laid_off = 1
order by funds_raised_millions desc;

select company, sum(total_laid_off)
from layoff2
group by company
order by sum(total_laid_off) desc;

select max(`date`), min(`date`)
from layoff2;

select year(`date`), sum(total_laid_off) as layoff
from layoff2
where year(`date`) is not null
group by year(`date`)
order by year(`date`);

select country, sum(total_laid_off) as layoff
from layoff2
group by country
order by layoff desc;

select substring(`date`,1,7) as `month`, sum(total_laid_off)
from layoff2
where substring(`date`,1,7) is not null
group by `month`
order by sum(total_laid_off) desc;


with rolling_total as
(
select substring(`date`,1,7) as `month`, sum(total_laid_off) as total_layoff
from layoff2
where substring(`date`,1,7) is not null
group by `month`
order by sum(total_laid_off) desc
)
select `month`, total_layoff, sum(total_layoff) over(order by `month`) as rolling_sum  from rolling_total;


select * from layoff2;

select company, year(`date`), sum(total_laid_off)
from layoff2
group by company, year(`date`);


with company_year(company,years,total_laid_off) as
(
select company, year(`date`), sum(total_laid_off)
from layoff2
group by company, year(`date`)
)
select * from company_year;


with company_year(company,years,total_laid_off) as
(
select company, year(`date`), sum(total_laid_off)
from layoff2
group by company, year(`date`)
)
select *,dense_rank() over(partition by years order by total_laid_off desc) from 
company_year
where years is not null;