-- 1. 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc


/*
--- EDA SCRIPTS --



SELECT *
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY [location], [date]
;

SELECT *
FROM CovidVaccinations
WHERE continent IS NOT NULL
ORDER BY [location], [date]
;

-- Get data we will be using

SELECT continent, location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY continent, location, date
;

-- Find Total Cases vs Total Deaths
-- the likelihood of dying from covid
SELECT continent, location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY continent, location, date
;

-- Total Cases Vs Population
-- the likelihood of getting from covid
SELECT continent, location, date, total_cases, population, (total_cases/population)*100 AS Percentage_Has_Covid_InPopulation
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY continent, location, date
;

-- Countries with Highest Infection Rate Vs Population
SELECT continent, location, population, MAX(total_cases) AS Highest_Infection_Count, MAX((total_cases/population)*100) AS Percentage_Have_Covid
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent, location, population
ORDER BY Highest_Infection_Count DESC
;

-- Countries with Highest Death Count Per Population
SELECT continent, location, MAX(total_deaths) AS Total_Death_Count
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent, location
ORDER BY Total_Death_Count DESC
;

-- Continents with Highest Death Count Per Population
SELECT continent, location, MAX(total_deaths) AS Total_Death_Count
FROM CovidDeaths
WHERE continent IS NULL
GROUP BY continent, location
ORDER BY Total_Death_Count DESC
;


-- Global Numbers
SELECT SUM(new_cases) AS Total_Cases, SUM(new_deaths) AS Total_Deaths, SUM(new_deaths) / SUM(new_cases) * 100 AS Death_Percentage
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2
;


-- Joining Deaths and Vaccinations tables
SELECT D.continent, D.location, D.date, D.population, V.new_vaccinations,
    SUM(V.new_vaccinations) OVER (PARTITION BY V.location ORDER BY D.location, D.date) AS Running_People_Vaccinated
FROM CovidDeaths D
    JOIN CovidVaccinations V
    ON D.location = V.location
        AND D.date = V.date
WHERE D.continent IS NOT NULL
ORDER BY 1,2,3
;

-- USE CTE

WITH
    PopversusVac (continent, location, date, population, new_vaccinations, Running_People_Vaccinated)
    AS
    (
        SELECT D.continent, D.location, D.date, D.population, V.new_vaccinations,
            SUM(V.new_vaccinations) OVER (PARTITION BY V.location ORDER BY D.location, D.date) AS Running_People_Vaccinated
        FROM CovidDeaths D
            JOIN CovidVaccinations V
            ON D.location = V.location
                AND D.date = V.date
        WHERE D.continent IS NOT NULL
    )

SELECT *, (Running_People_Vaccinated / population) * 100
FROM PopversusVac
;


-- Using a Temp Table
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
    continent nvarchar(255),
    location nvarchar(255),
    date DATETIME,
    population NUMERIC,
    new_vaccinations numeric,
    RollinPeopleVaccinated NUMERIC
)

INSERT INTO #PercentPopulationVaccinated
SELECT D.continent, D.location, D.date, D.population, V.new_vaccinations,
    SUM(V.new_vaccinations) OVER (PARTITION BY V.location ORDER BY D.location, D.date) AS Running_People_Vaccinated
FROM CovidDeaths D
    JOIN CovidVaccinations V
    ON D.location = V.location
        AND D.date = V.date
WHERE D.continent IS NOT NULL

SELECT * FROM #PercentPopulationVaccinated;

-- Creating a view for Visulations in Power BI
--
DROP VIEW IF EXISTS vPercentPopulationVaccinated;
CREATE VIEW vPercentPopulationVaccinated
AS
    SELECT D.continent, D.location, D.date, D.population, V.new_vaccinations,
        SUM(V.new_vaccinations) OVER (PARTITION BY V.location ORDER BY D.location, D.date) AS Running_People_Vaccinated
    FROM CovidDeaths D
        JOIN CovidVaccinations V
        ON D.location = V.location
            AND D.date = V.date
    WHERE D.continent IS NOT NULL
;

SELECT * from vPercentPopulationVaccinated;


*/