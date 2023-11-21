SELECT *
From PortfolioProject..Coviddeaths
order by 3,4


SELECT *
From PortfolioProject..CovidVacinations
order by 3,4


-- Select Data that we are going to be using


SELECT Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..Coviddeaths
order by 1,2


-- Looking at Total Cases vs Total Deaths


SELECT Location, date, total_cases, total_deaths, CAST(total_deaths AS decimal(18,2))/CAST(total_cases AS decimal(18,2))*100 AS DeathRate
From PortfolioProject..Coviddeaths
order by 1,2

-- Shows the percentage or likelihod of dying from covid in USA
SELECT Location, date, total_cases, total_deaths, CAST(total_deaths AS decimal(18,2))/CAST(total_cases AS decimal(18,2))*100 AS DeathRate
From PortfolioProject..Coviddeaths
where location like '%state%'
order by 1,2

-- Shows the percentage or likelihod of dying from covid in Nigeria

SELECT Location, date, total_cases, total_deaths, CAST(total_deaths AS decimal(18,2))/CAST(total_cases AS decimal(18,2))*100 AS DeathRate
From PortfolioProject..Coviddeaths
where location like '%Nigeria%'
order by 1,2


-- Looking at the Total Cases vs  Population in Nigeria

SELECT Location, date, Population, total_cases,  CAST(total_cases AS decimal(18,2))/CAST(population AS decimal(18,2))*100 AS PopulationPercentage
From PortfolioProject..Coviddeaths
where location like '%Nigeria%'
order by 1,2

-- Looking at Total Caes vs Population in US ie the percentage of the ppulation with covid
SELECT Location, date, total_cases, Population, CAST(total_cases AS decimal(18,2))/CAST(population AS decimal(18,2))*100 AS PopulationPercentage
From PortfolioProject..Coviddeaths
where location like '%state%'
order by 1,2

-- Looking at Total Caes vs Population in the World ie the percentage of the ppulation with covid

SELECT Location, date, Population, total_cases,  CAST(total_cases AS decimal(18,2))/CAST(population AS decimal(18,2))*100 AS PopulationPercentage
From PortfolioProject..Coviddeaths
--where location like '%Nigeria%'
order by 1,2

-- Looking at Countries with highest infection rate vs population

SELECT Location, Population, MAX(total_cases) as HighestInfectionCount,  MAX(CAST(total_cases AS decimal(18,2)) /CAST(population AS decimal(18,2))*100 )AS PercentagePopulationInfected
From PortfolioProject..Coviddeaths
--where location like '%Nigeria%'
Group by Location, Population
order by PercentagePopulationInfected desc

-- Looking at Countries with lowest infection rate vs population

SELECT Location, Population, MIN(total_cases) as LowestInfectionCount,  MIN(CAST(total_cases AS decimal(18,2)) /CAST(population AS decimal(18,2))*100 )AS PercentagePopulationInfected
From PortfolioProject..Coviddeaths
--where location like '%Nigeria%'
Group by Location, Population
order by PercentagePopulationInfected desc


-- Looking at Countries with highest death rate vs population

SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathCount  --MAX(CAST(total_deaths AS decimal(18,2)) /CAST(population AS decimal(18,2))*100 )AS PercentagePopulationDeaths
From PortfolioProject..Coviddeaths
--where location like '%Nigeria%'
Group by Location
order by TotalDeathCount desc


-- To select only countries

SELECT *
From PortfolioProject..Coviddeaths
where continent is not null
order by 3,4

SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathCount  --MAX(CAST(total_deaths AS decimal(18,2)) /CAST(population AS decimal(18,2))*100 )AS PercentagePopulationDeaths
From PortfolioProject..Coviddeaths
where continent is not null
Group by Location
order by TotalDeathCount desc


-- Lets breat it down by continent

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount  
From PortfolioProject..Coviddeaths
where continent is null
Group by location
order by TotalDeathCount desc



 -- GLOBAL NUMBERS


SELECT Location, date, total_cases, total_deaths, CAST(total_deaths AS decimal(18,2))/CAST(total_cases AS decimal(18,2))*100 AS DeathRate
From PortfolioProject..Coviddeaths
--where location like '%Nigeria%'
where continent is not null
order by 1,2

SELECT Location, SUM(new_cases) as Total_cases, SUM(CAST(new_deaths as int)) as total_deaths, --SUM(CAST(new_deaths as int)) /SUM(new_cases)*100  AS PercentageDeaths
CASE
WHEN SUM(new_cases) = 0 THEN 0
ELSE SUM(CAST(new_deaths as int)) /SUM(new_cases)*100 
END AS PercentageDeaths
From PortfolioProject..Coviddeaths
--where location like '%Nigeria%'
where continent is not null
GROUP  by Location
order by 1,2

SELECT date, SUM(new_cases) as Total_cases, SUM(CAST(new_deaths as int)) as total_deaths, --SUM(CAST(new_deaths as int)) /SUM(new_cases)*100  AS PercentageDeaths
CASE
WHEN SUM(new_cases) = 0 THEN 0
ELSE SUM(CAST(new_deaths as int)) /SUM(new_cases)*100 
END AS PercentageDeaths
From PortfolioProject..Coviddeaths
--where location like '%Nigeria%'
where continent is not null
GROUP  by date
order by 1,2

--Across the world, the totals

SELECT SUM(new_cases) as Total_cases, SUM(CAST(new_deaths as int)) as total_deaths, --SUM(CAST(new_deaths as int)) /SUM(new_cases)*100  AS PercentageDeaths
CASE
WHEN SUM(new_cases) = 0 THEN 0
ELSE SUM(CAST(new_deaths as int)) /SUM(new_cases)*100 
END AS PercentageDeaths
From PortfolioProject..Coviddeaths
--where location like '%Nigeria%'
where continent is not null
--GROUP  by date
order by 1,2


SELECT *
FROM PortfolioProject..CovidVacinations


-- To join the two tables
SELECT *
FROM PortfolioProject..Coviddeaths dea
JOIN PortfolioProject..CovidVacinations vac
	on dea.location = vac.location
	and dea.date = vac.date


-- To look at Total Population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortfolioProject..Coviddeaths dea
JOIN PortfolioProject..CovidVacinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location order by dea.Location, dea.date) as RollPeopleVacinated
FROM PortfolioProject..Coviddeaths dea
JOIN PortfolioProject..CovidVacinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3


-- Looking at Total vaccinations vs Population

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location order by dea.Location, dea.date) as RollPeopleVacinated
FROM PortfolioProject..Coviddeaths dea
JOIN PortfolioProject..CovidVacinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3

-- USE CTE

With PopvsVac (Continents, Location, Date, Population, new_vaccinations, RollPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location order by dea.Location, dea.date) as RollPeopleVacinated
FROM PortfolioProject..Coviddeaths dea
JOIN PortfolioProject..CovidVacinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3
)

Select *, (RollPeopleVaccinated/Population)*100
FROM PopvsVac

-- TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location order by dea.Location, dea.date) as RollPeopleVacinated
FROM PortfolioProject..Coviddeaths dea
JOIN PortfolioProject..CovidVacinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2, 3

Select *, (RollPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated



-- creating view to store or visualization

create view PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location order by dea.Location, dea.date) as RollPeopleVacinated
FROM PortfolioProject..Coviddeaths dea
JOIN PortfolioProject..CovidVacinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3

SELECT *
FROM PercentPopulationVaccinated

CREATE VIEW PercentageDeaths AS
SELECT SUM(new_cases) as Total_cases, SUM(CAST(new_deaths as int)) as total_deaths, --SUM(CAST(new_deaths as int)) /SUM(new_cases)*100  AS PercentageDeaths
CASE
WHEN SUM(new_cases) = 0 THEN 0
ELSE SUM(CAST(new_deaths as int)) /SUM(new_cases)*100 
END AS PercentageDeaths
From PortfolioProject..Coviddeaths
--where location like '%Nigeria%'
where continent is not null
--GROUP  by date
--order by 1,2

