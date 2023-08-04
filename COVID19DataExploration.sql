-- Estimated probability of dying if you contract covid in your country
SELECT [location]
	,[date]
	,[total_cases]
	,[total_deaths]
	,[population]
	,([total_deaths]/[total_cases])*100 AS deathPCT
FROM CovidDatabase..CovidDeaths
WHERE [location] LIKE '%United States%'
	AND [continent] IS NOT NULL
ORDER BY 1,2;

-- Percentage of population contract COVID-19
SELECT [location]
	,[date]
	,[total_cases]
	,[total_deaths]
	,[population]
	,([total_cases]/[population])*100 AS CasePCT
FROM CovidDatabase..CovidDeaths
WHERE [location] LIKE '%United States%'
	AND [continent] IS NOT NULL
ORDER BY 1,2;

-- Countries with highest infection rate/population ratio
SELECT[location]
	,[Population]
	,MAX([total_cases]) AS HighestInfectionCount
	, MAX(([total_cases]/[population]))*100 AS HighestInfectionRate
FROM CovidDatabase..CovidDeaths
WHERE [continent] IS NOT NULL
GROUP BY [population], [location]
ORDER BY HighestInfectionRate DESC

-- Countries with highest death rates (NOT per capita)
SELECT[location]
	,MAX([total_deaths]) AS TotalDeathCount
FROM CovidDatabase..CovidDeaths
WHERE [continent] IS NOT NULL
GROUP BY [population], [location]
ORDER BY TotalDeathCount DESC

-- Continent with highest death rates (NOT per capita)
SELECT[continent]
	,MAX([total_deaths]) AS TotalDeathCount
FROM CovidDatabase..CovidDeaths
WHERE [continent] IS NOT NULL
GROUP BY [continent]
ORDER BY TotalDeathCount DESC

-- continents with highest death count per pop
SELECT[continent]
	,MAX([total_deaths]) AS TotalDeathCount
FROM CovidDatabase..CovidDeaths
WHERE [continent] IS NOT NULL
GROUP BY [continent]
ORDER BY TotalDeathCount DESC

-- GLOBAL NUMBERS
SELECT [date]
	,SUM([new_cases]) AS GlobalNewCases
	,SUM([new_deaths]) AS GlobalNewDeaths
	,(SUM([new_deaths])/SUM([new_cases]))*100 AS GlobalDeathPCT
FROM CovidDatabase..CovidDeaths
WHERE [continent] IS NOT NULL
	AND [new_cases] > 0
GROUP BY [date]
ORDER BY 1, 2

-- TOTAL CASES GLOBAL AS OF 7/19/23
SELECT SUM([new_cases]) AS TotalCases
	,SUM([new_deaths]) AS TotalDeaths
	,(SUM([new_deaths])/SUM([new_cases]))*100 AS GlobalDeathPCT
FROM CovidDatabase..CovidDeaths
WHERE [continent] IS NOT NULL
	AND [new_cases] > 0
ORDER BY 1, 2

-- EXPLORATORY QUERY
SELECT *
FROM CovidDatabase..CovidVaccinations

-- Total Population vs Vaccination

-- CTE Creation to get Vaccination Rate
WITH VaxPop (continent, location, date, population, new_vaccinations, RollingVaxCount)
AS (
	SELECT dea.continent
		, dea.location
		, dea.date
		, dea.population
		, vac.new_vaccinations
		, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
	FROM CovidDatabase..CovidVaccinations AS vac
	JOIN CovidDatabase..CovidDeaths AS dea
		ON dea.location = vac.location
		AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL
	)
SELECT *, (RollingVaxCount/Population)*100 AS RollingVaxRate
FROM VaxPop

-- Same result as CTE but with Temp Table
--DROP Table if exists #VaxPopRate
--Create Table #VaxPopRate
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--Date datetime,
--Population numeric,
--New_vax numeric,
--RollingVaxPeople numeric
--)

--Insert into #VaxPopRate
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
--From PortfolioProject..CovidDeaths dea
--Join PortfolioProject..CovidVaccinations vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--Select *, (RollingVaxPeople/Population)*100
--From #VaxPopRate

-- Create VaxCount View to Store Data for Tableau Analysis
CREATE VIEW VaxCounts AS
SELECT dea.continent
		, dea.location
		, dea.date
		, dea.population
		, vac.new_vaccinations
		, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingVaxCount
	FROM CovidDatabase..CovidVaccinations AS vac
	JOIN CovidDatabase..CovidDeaths AS dea
		ON dea.location = vac.location
		AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL

Select *
FROM VaxCounts

-- View of Rolling Death Toll
CREATE VIEW DeathTolls AS
SELECT continent
		, location
		, date
		, population
		, SUM(new_deaths) OVER (PARTITION BY location ORDER BY location, date) AS RollingDeathToll
	FROM CovidDatabase..CovidDeaths
	WHERE continent IS NOT NULL

SELECT *
FROM DeathTolls