-- Visual 1: Daily Death PCT per 1M

SELECT date
	,SUM(new_cases) AS total_cases
	,SUM(new_deaths) AS total_deaths
	,SUM(new_deaths)/SUM(New_Cases)*100 AS DailyDeathPCT
FROM CovidDatabase..CovidDeaths
WHERE continent is not null
	AND new_cases > 0
GROUP BY date
ORDER BY 1,2;

-- Visual 2: deaths by date and continent
-- Remove items not included in first query, EU is included in 'Europe'

SELECT date
	,location
	,SUM(new_deaths) AS continent_deaths
FROM CovidDatabase..CovidDeaths
WHERE continent IS NULL 
	AND location NOT IN ('World', 'European Union', 'International'
	,'High income', 'Upper middle income', 'Lower middle income', 'Low income')
GROUP BY location, date
ORDER BY date;

-- Visual 3: population, deaths and death rate by date and country

SELECT date
	,location
	, SUM(population) AS country_pop
	,SUM(new_deaths) AS deaths_per_day
	,SUM(new_deaths)/SUM(population) *100 AS country_death_rate
FROM CovidDatabase..CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY location, date
ORDER BY date;

-- Visual 4: infections by date and country

SELECT date
	,location
	,SUM(population) AS country_pop
	,SUM(total_cases) AS infections
	, (SUM(total_cases)/SUM(population)) * 100 AS infection_rate
FROM CovidDatabase..CovidDeaths
GROUP BY date, location
ORDER BY date

-- Visual 5: avg gdp per capita by date, country

SELECT date
	,location
	,AVG(gdp_per_capita) AS avg_gdp_per_capita
FROM CovidDatabase..CovidVaccinations
WHERE continent IS NOT NULL
GROUP BY date, location
ORDER BY date, location;


-- Visual 6: Total vaccinations and vaccination rate by country

SELECT date
	,location
	,SUM(population) AS total_pop
	,SUM(new_vaccinations) AS total_vaccinations
	,SUM(new_vaccinations)/SUM(population) * 100 AS vaccination_rate
FROM CovidDatabase..CovidVaccinations
WHERE continent IS NOT NULL
GROUP BY date, location
ORDER BY date

-- Visual 7: Excess mortality by week

SELECT date, SUM(excess_mortality) AS week_excess_mortality
FROM CovidDatabase..CovidVaccinations
WHERE excess_mortality IS NOT NULL
GROUP BY date
ORDER BY date;
