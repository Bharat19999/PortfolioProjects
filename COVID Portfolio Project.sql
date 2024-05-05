--SELECT *
--FROM PortfolioProject..CovidDeaths
--WHERE continent IS NOT NULL
--ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 3,4

-- Select data that we are going to be using

--SELECT location, date, total_cases, new_cases, total_deaths, population
--FROM PortfolioProject..CovidDeaths
--ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

--SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
--FROM PortfolioProject..CovidDeaths
----WHERE location LIKE '%states%'
--ORDER BY 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

--SELECT location, date, population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
--FROM PortfolioProject..CovidDeaths
----WHERE location LIKE '%states%'
--ORDER BY 1,2

-- Looking at Countries with Highest Infection Rate compared to Population

--SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
--FROM PortfolioProject..CovidDeaths
----WHERE location LIKE '%states%'
--GROUP BY location, population
--ORDER BY PercentPopulationInfected DESC

-- Showing countries with Highest Death Count per Population

--SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
--FROM PortfolioProject..CovidDeaths
----WHERE location LIKE '%states%'
--WHERE continent IS NOT NULL
--GROUP BY location
--ORDER BY TotalDeathCount DESC


-- LET'S BREAK THINGS DOWN BY CONTINENT

-- Showing continents with the highest death count per population

--SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
--FROM PortfolioProject..CovidDeaths
----WHERE location LIKE '%states%'
--WHERE continent IS NOT NULL
--GROUP BY continent
--ORDER BY TotalDeathCount DESC

-- GLOBAL NUMBERS

--SELECT date, SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, (SUM(new_deaths)/SUM(new_cases))*100 AS DeathPercentage
--FROM PortfolioProject..CovidDeaths
----WHERE location LIKE '%states%'
--WHERE continent IS NOT NULL AND new_cases != 0 AND new_deaths!= 0
--GROUP BY date
--ORDER BY 1,2


-- Looking at Total Population vs Vaccinations

--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
--SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--FROM PortfolioProject..CovidDeaths dea
--JOIN PortfolioProject..CovidVaccinations vac
--	ON dea.location = vac.location
--	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL AND vac.new_vaccinations IS NOT NULL
----GROUP BY dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--ORDER BY 1,2,3


-- USE CTE

--WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
--AS
--(
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
--SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--FROM PortfolioProject..CovidDeaths dea
--JOIN PortfolioProject..CovidVaccinations vac
--	ON dea.location = vac.location
--	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL AND vac.new_vaccinations IS NOT NULL
----GROUP BY dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
----ORDER BY 1,2,3
--)
--SELECT *, (RollingPeopleVaccinated/population)*100
--FROM PopvsVac


-- TEMP TABLE

--DROP TABLE IF EXISTS #PercentPopulationVaccinated
--CREATE TABLE #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--Date datetime,
--Population numeric,
--New_vaccinations numeric,
--RollingPeopleVaccinated numeric
--)

--INSERT INTO #PercentPopulationVaccinated
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
--SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--FROM PortfolioProject..CovidDeaths dea
--JOIN PortfolioProject..CovidVaccinations vac
--	ON dea.location = vac.location
--	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL AND vac.new_vaccinations IS NOT NULL
----GROUP BY dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
----ORDER BY 1,2,3

--SELECT *, (RollingPeopleVaccinated/population)*100
--FROM #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

--CREATE VIEW PercentPopulationVaccinated AS
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
--SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--FROM PortfolioProject..CovidDeaths dea
--JOIN PortfolioProject..CovidVaccinations vac
--	ON dea.location = vac.location
--	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL AND vac.new_vaccinations IS NOT NULL
--GROUP BY dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
----ORDER BY 1,2,3

SELECT * 
FROM PercentPopulationVaccinated