-- Exploratory Data Analysis

SELECT *
FROM layoffs_replica2;

SELECT MAX(total_laid_off)
FROM layoffs_replica2;

SELECT MAX(percentage_laid_off)
FROM layoffs_replica2;

SELECT *
FROM layoffs_replica2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_replica2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_replica2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_replica2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_replica2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_replica2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_replica2
GROUP BY stage
ORDER BY 2 DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_replica2
GROUP BY company
ORDER BY 2 DESC;

SELECT SUBSTR(`DATE`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_replica2
WHERE SUBSTR(`DATE`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH `Rolling_Total` AS
(
SELECT SUBSTR(`DATE`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_replica2
WHERE SUBSTR(`DATE`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

SELECT company, SUM(total_laid_off)
FROM layoffs_replica2
GROUP BY company
ORDER BY 2 DESC;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_replica2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_Year AS
(SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_replica2
GROUP BY company, YEAR(`date`)
)
SELECT *
FROM Company_Year;

WITH Company_Year (company, years, total_laid_off) AS
(SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_replica2
GROUP BY company, YEAR(`date`)
)
SELECT *
FROM Company_Year;

WITH Company_Year (company, years, total_laid_off) AS
(SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_replica2
GROUP BY company, YEAR(`date`)
)
SELECT *,
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
ORDER BY Ranking ASC;

WITH Company_Year (company, years, total_laid_off) AS
(SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_replica2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *,
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT*
FROM Company_Year_Rank
WHERE Ranking <= 5;

WITH Industry_Year (industry, years, total_laid_off) AS
(SELECT industry, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_replica2
GROUP BY industry, YEAR(`date`)
), Industry_Year_Rank AS
(SELECT *,
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Industry_Year
WHERE years IS NOT NULL
)
SELECT*
FROM Industry_Year_Rank
WHERE Ranking <= 5;



