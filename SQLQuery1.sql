
--Coming from command line only database management and querying, learning to use a workbench(syntax, formatting, import tools) using data from https://ourworldindata.org/covid-deaths


--is our data imported correctly?
	--data was cleaned in excel, below statement returns matching data to.xlsx
	--if coming back to do tableau drilldown, include continent in select statements
SELECT * 
FROM covid..CovidDeaths
ORDER BY 3, 4
;

SELECT * 
FROM  covid..CovidVaccinations
ORDER BY 3, 4;



--Exploring the Deaths table
	-- narrow select statement to relevant information

SELECT 
	location, 
	date,
	total_cases, 
	new_cases, 
	total_deaths, 
	population 
FROM 
	covid..CovidDeaths
ORDER BY 1, 2;

--find daily mortality rate of disease by country
	--if datatype int and returning 0, use (CAST(total_deaths as float))/(CAST(total_cases AS float))*100 AS percent_infected_dead 

SELECT 
	location, 
	date,
	total_cases, 
	total_deaths, 
	(total_deaths/total_cases)*100 AS percent_infected_dead 
FROM 
	covid..CovidDeaths
WHERE 
	continent IS NOT NULL
ORDER BY 1, 2;

--by date, what percent of the population has been infected in the US?

SELECT 
	location, 
	date,
	total_cases, 
	population, 
	(total_cases/population)*100 AS percent_infected 
FROM 
	covid..CovidDeaths
WHERE 
	location LIKE '%states' 
ORDER BY 1, 2; 

--which day did the danes cross the 10% infected mark?
		-- casting numeric to float for syntax practice

SELECT 
	location, 
	MIN(date) AS date 
FROM 
	covid..CovidDeaths 
WHERE 
	location LIKE 'denmark' AND 
	((CAST(total_cases as float))/(CAST(population AS float))*100) > 10 
GROUP BY location
ORDER BY 1, 2;

-- Countries with highest infection rate 

SELECT 
	location, 
	population, 
	MAX(total_cases) AS highest_case_count, 
	MAX((total_cases/population))*100 AS percent_pop_infected
FROM 
	Covid..CovidDeaths
WHERE 
	continent IS NOT NULL AND 
	total_cases IS NOT NULL 
GROUP BY location, population
ORDER BY percent_pop_infected DESC;

--which country has the highest death count?
	--not great comparison data without accounting for population

SELECT 
	location, 
	MAX(total_deaths) as total_death_count
FROM 
	Covid..CovidDeaths
WHERE 
	continent IS NOT NULL AND 
	total_deaths IS NOT NULL
GROUP BY location, population
ORDER BY total_death_count DESC;

--accounting for population

SELECT 
	location, 
	MAX(total_deaths/population)*100 as total_death_count
FROM 
	Covid..CovidDeaths
WHERE 
	continent IS NOT NULL AND 
	total_deaths IS NOT NULL
GROUP BY location, population
ORDER BY total_death_count DESC;

--what is the total number of reported cases, deaths, and mortality rate?

SELECT
	SUM(new_cases) AS total_cases, 
	SUM(new_deaths) AS total_deaths, 
	SUM(new_deaths)/SUM(new_cases)*100
FROM 
	Covid..CovidDeaths
;

--gaining insight by joining deaths and vaccination tables

SELECT *
FROM Covid..CovidDeaths dea
JOIN Covid..CovidVaccinations vax
	ON dea.date = vax.date AND
	dea.location = vax.location
;

-- partition by / window functions
SELECT 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vax.new_vaccinations, 
	SUM(vax.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_vaxed_pop
FROM 
	Covid..CovidDeaths dea
JOIN 
	Covid..CovidVaccinations vax
		ON dea.date = vax.date AND
		dea.location = vax.location 
WHERE 
	dea.continent IS NOT NULL 
ORDER BY 2, 3;

--find the percent of the population that has been vaccinated based on the rolling total on that date. use a CTE

WITH 
	VaxPct 
		(continent, location, date, population, new_vaccinations, rolling_vaxed_pop)
AS
	(

SELECT 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vax.new_vaccinations, 
	SUM(vax.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_vaxed_pop
FROM 
	Covid..CovidDeaths dea
JOIN 
	Covid..CovidVaccinations vax
		ON dea.date = vax.date AND
		dea.location = vax.location 
WHERE 
	dea.continent IS NOT NULL 
	)
SELECT *, (rolling_vaxed_pop/population)
FROM VaxPct
;

--with temp table


DROP TABLE IF EXISTS #percent_vaxed 
CREATE TABLE 
	#percent_vaxed 
		(
		continent nvarchar(255), 
		location nvarchar(255), 
		date date, 
		population numeric(18,0), 
		new_vaccinations numeric, 
		rolling_vaxed_pop numeric
		)


INSERT INTO #percent_vaxed
SELECT 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vax.new_vaccinations, 
	SUM(vax.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_vaxed_pop
FROM 
	Covid..CovidDeaths dea
JOIN 
	Covid..CovidVaccinations vax
		ON dea.date = vax.date AND
		dea.location = vax.location 
WHERE 
	dea.continent IS NOT NULL 

SELECT *, (rolling_vaxed_pop/population)
FROM #percent_vaxed