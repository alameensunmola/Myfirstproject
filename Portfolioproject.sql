SELECT *
FROM PortfolioProject..CovidDeaths
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
Order by 1,2

--Total Cases vs Total Death in Africa
--Shows likelihood of dying if you contracted covid in African countries
SELECT continent, location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)* 100 AS DeathPerc
FROM PortfolioProject..CovidDeaths
WHERE continent = 'Africa'
AND continent IS NOT NULL
Order by 1,2

--Total Cases vs Total Death in Nigeria
--Shows likelihood of dying if you contracted covid in Nigeria

SELECT location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)* 100 AS DeathPerc
FROM PortfolioProject..CovidDeaths
WHERE location = 'Nigeria'
AND continent IS NOT NULL
Order by 1,2



--Total case vs total population
--percentage of Population of people Infected
SELECT location, date, population, total_cases, (total_cases/population)* 100 AS PercPopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE location = 'Nigeria'
Order by 1,2

--Countries with Highest infection rate compared to population

SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))* 100 AS PercPopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE location = 'Nigeria'
Group by location,population
ORDER BY PercPopulationInfected DESC

--Nigeria's Highest infection rate compared to population
SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))* 100 AS PercPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE location = 'Nigeria'
Group by location,population
ORDER BY 1,2

--Showing countries with highest death per population


SELECT location, MAX(total_deaths) as HighestDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
Group by location
ORDER BY HighestDeathCount DESC

--Convert Data type using CAST function
SELECT location, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE location = 'Nigeria
WHERE continent IS NOT NULL
Group by location
ORDER BY TotalDeathCount DESC

--Showing African countries with highest death per population
SELECT location, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE location = 'Nigeria
WHERE continent = 'Africa'
AND continent IS NOT NULL
Group by location
ORDER BY TotalDeathCount DESC

--Total Death Count By continent
-- shows the number of covids death all ove the world by continent
--SELECT location, MAX(CAST(total_deaths as int)) as TotalDeathCount
--FROM PortfolioProject..CovidDeaths
----WHERE location = 'Nigeria'
--WHERE continent IS  NULL
--Group by location
--ORDER BY TotalDeathCount DESC

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS
--Shows global Total Covid cases, Total Deaths, and Death Percentage

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Shows the the daily covid Total cases, Total deaths,and Death percentages of the world 
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
Group By date
order by 1,2


--AFRICAN NUMBERS
--Shows Africa's Total Covid cases, Total Deaths, and Death Percentage
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
WHERE continent = 'Africa'
AND continent is not null 
order by 1,2

-- Shows the the daily covid Total cases, Total deaths,and Death percentages of Countries in Africa
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
WHERE continent = 'Africa'
AND continent is not null 
Group By date
order by 1,2


--JOINing CovidDeaths and CovidVaccination table ON dates and location
SELECT *
FROM PortfolioProject..CovidDeaths  dea
  Join PortfolioProject..CovidVaccinations  vac
  ON dea.location = vac.location
  AND dea.date = vac.date

  --Looking at Total Global Population VS Vaccination
  SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortfolioProject..CovidDeaths  dea
  Join PortfolioProject..CovidVaccinations  vac
  ON dea.location = vac.location
  AND dea.date = vac.date
  WHERE dea.continent IS NOT NULL
  ORDER BY 1,2,3


  -- Africa's Population VS Vaccination

  -- Shows the countries in Africa that first adopted covid vaccine
    SELECT dea.continent, dea.location, dea.date, dea.population, vac.total_vaccinations
FROM PortfolioProject..CovidDeaths  dea
  Join PortfolioProject..CovidVaccinations  vac
  ON dea.location = vac.location
  AND dea.date = vac.date
  WHERE dea.continent IS NOT NULL
  AND dea.continent = 'Africa'
  AND vac.total_vaccinations IS NOT NULL
  ORDER BY 3


  -- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location  Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100 AS PercOfPopVaccinated
From #PercentPopulationVaccinated



-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 



Create View AfricaCovidDeathRate as
 SELECT location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)* 100 AS DeathPerc
FROM PortfolioProject..CovidDeaths
WHERE continent = 'Africa'
AND continent IS NOT NULL


Create View PercentPopInfected as
SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))* 100 AS PercPopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE location = 'Nigeria'
Group by location,population


create view TotalDeathCountbycountry as
SELECT location, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE location = 'Nigeria
WHERE continent IS NOT NULL
Group by location