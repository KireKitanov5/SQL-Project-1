CREATE DATABASE PortfolioProject1;
GO

USE PortfolioProject1;

Select *
From PortfolioProject1.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 3,4

--Select *
--From PortfolioProject1.dbo.CovidVaccinations
--ORDER BY 3,4

--Select Data that we are going to use
Select [location],[date],total_cases,new_cases,total_deaths,population
From PortfolioProject1.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 1,2

--Looking at total_cases vs total-deaths
--Shows likelihood of dying if you contract covid in your country
Select location,date,total_cases,total_deaths, (cast(total_deaths as decimal)/total_cases)*100 AS DeathPercentage
From PortfolioProject1.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 1,2

Select location,date,total_cases,total_deaths, (cast(total_deaths as decimal)/total_cases)*100 AS DeathPercentage
From PortfolioProject1.dbo.CovidDeaths
WHERE location like '%states%'

ORDER BY 1,2

--Looking Total_cases vs Population
--Shows what percentage of population got covid
Select location,date,total_cases,population, (cast(total_cases as decimal)/population)*100 AS PercentPopulationInfected
From PortfolioProject1.dbo.CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
ORDER BY 1,2

--Looking at Countries with Highest infection compared to Population
Select location,MAX(total_cases) AS HighestInfectionCount,population, MAX((cast(total_cases as decimal)/population))*100 AS PercentPopulationInfected
From PortfolioProject1.dbo.CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

--Countries with Highest Death Count per Population
Select location,MAX(cast(total_deaths as int)) AS TotalDeathCount
From PortfolioProject1.dbo.CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC

--Breaking things by CONTINENT
Select continent,MAX(cast(total_deaths as int)) AS TotalDeathCount
From PortfolioProject1.dbo.CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

Select [location],MAX(cast(total_deaths as int)) AS TotalDeathCount
From PortfolioProject1.dbo.CovidDeaths
--WHERE location like '%states%'
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount DESC

--Continents with Highest Death Count per Population
Select continent,MAX(cast(total_deaths as int)) AS TotalDeathCount
From PortfolioProject1.dbo.CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

--GLOBAL NUMBERS
Select date,total_cases,total_deaths, (cast(total_deaths as decimal)/total_cases)*100 AS DeathPercentage
From PortfolioProject1.dbo.CovidDeaths
--WHERE location like '%states%'
where continent is not NULL
ORDER BY 1,2

Select date,SUM(new_cases)--,total_deaths), (cast(total_deaths as decimal)/total_cases)*100 AS DeathPercentage
From PortfolioProject1.dbo.CovidDeaths
--WHERE location like '%states%'
where continent is not NULL
group by date
ORDER BY 1,2

Select date,SUM(new_cases), SUM(cast(new_deaths as int))--,total_deaths), (cast(total_deaths as decimal)/total_cases)*100 AS DeathPercentage
From PortfolioProject1.dbo.CovidDeaths
--WHERE location like '%states%'
where continent is not NULL
group by date
ORDER BY 1,2

Select date,SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject1.dbo.CovidDeaths
--WHERE location like '%states%'
where continent is not NULL
group by date
ORDER BY 1,2

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject1.dbo.CovidDeaths
--WHERE location like '%states%'
where continent is not NULL
--group by date
ORDER BY 1,2

SELECT *
FROM PortfolioProject1.dbo.CovidVaccinations

--Total Population VS Vaccination
SELECT *
FROM PortfolioProject1.dbo.CovidDeaths dea
Join PortfolioProject1.dbo.CovidVaccinations vac
    On dea.location = vac.location
    and dea.date = vac.date

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
FROM PortfolioProject1.dbo.CovidDeaths dea
Join PortfolioProject1.dbo.CovidVaccinations vac
    On dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is NOT NULL    
ORDER BY 2,3    

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location)
FROM PortfolioProject1.dbo.CovidDeaths dea
Join PortfolioProject1.dbo.CovidVaccinations vac
    On dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is NOT NULL    
ORDER BY 2,3 

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
    AS RollingPeopleVaccinated
 --(RollingPeopleVaccinated/population)*100     
FROM PortfolioProject1.dbo.CovidDeaths as dea
Join PortfolioProject1.dbo.CovidVaccinations as vac
    On dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is NOT NULL    
--ORDER BY 2,3 



  SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
    AS RollingPeopleVaccinated
 --(RollingPeopleVaccinated/population)*100     
FROM PortfolioProject1.dbo.CovidDeaths dea
Join PortfolioProject1.dbo.CovidVaccinations vac
    On dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is NOT NULL    
--ORDER BY 2,3   


--Using CTE
With PopvsVacc (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated) 
AS
(
  SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
    AS RollingPeopleVaccinated
 --(RollingPeopleVaccinated/population)*100     
FROM PortfolioProject1.dbo.CovidDeaths dea
Join PortfolioProject1.dbo.CovidVaccinations vac
    On dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is NOT NULL    
--ORDER BY 2,3   
)
SELECT *, CAST (RollingPeopleVaccinated AS FLOAT)/CAST (population AS FLOAT)*100
FROM PopvsVacc

--TEMP TABLE

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Content nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT into #PercentPopulationVaccinated
  SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
    AS RollingPeopleVaccinated
 --(RollingPeopleVaccinated/population)*100     
FROM PortfolioProject1.dbo.CovidDeaths dea
Join PortfolioProject1.dbo.CovidVaccinations vac
    On dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is NOT NULL    
--ORDER BY 2,3  
  
SELECT *, CAST (RollingPeopleVaccinated AS FLOAT)/CAST (population AS FLOAT)*100
FROM #PercentPopulationVaccinated

--CREATING VIEW to store data for later visualizations

Create View PercentPopulationVaccinated AS
  SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
    AS RollingPeopleVaccinated
 --(RollingPeopleVaccinated/population)*100     
FROM PortfolioProject1.dbo.CovidDeaths dea
Join PortfolioProject1.dbo.CovidVaccinations vac
    On dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is NOT NULL    
--ORDER BY 2,3  

SELECT *
FROM PercentPopulationVaccinated