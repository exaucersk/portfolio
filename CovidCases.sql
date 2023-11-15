Select*
From PortfolioProject..CovidDeaths
where continent is not null
order by 3,4


-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
Select Location, date, total_cases, total_deaths, (Total_deaths/total_cases)*100 as MortalityRate
From PortfolioProject..CovidDeaths
Where location like '%Germany%'
order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population has covid

Select Location, date, population, total_cases, (Total_cases/population)*100 as PercentageofPopulationInfected
From PortfolioProject..CovidDeaths
Where location like '%Germany%'
order by 1,2

-- Which country has the highest infection rate?
Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((Total_cases/population))*100 as PercentPopInfected
From PortfolioProject..CovidDeaths
--Where location like '%Germany%'
Group by Location, Population
order by PercentPopInfected desc

-- LETS BREAK THINGS DOWN BY CONTINENT
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%Germany%'
where continent is null
Group by location
order by TotalDeathCount desc




-- How many people died? Countries with highest Death Count per Population
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%Germany%'
where continent is not null
Group by Location
order by TotalDeathCount desc

-- Showing continents with the highest death count per population
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%Germany%'
where continent is not null
Group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS <- Mortality Rates daily and global
Select date, SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalNewDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%Germany%'
where continent is not null
Group by date
order by 1,2

--USE CTE
With PopvsVac (Continent, Location, date, population, New_Vaccinations, RollingPeopleVaccinated)
as (
-- Looking at Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
SELECT*, (RollingPeopleVaccinated/population*100) as VacRate
From PopvsVac




--TEMP TABLE
 Create Table #PercentPopulationVaccinated (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric,
 RollingPeopleVaccinated numeric
 )
 
 INSERT INTO #PercentPopulationVaccinated
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

SELECT*, (RollingPeopleVaccinated/population*100) as VacRate
From #PercentPopulationVaccinated



-- Creating view to store data for later visualizations
Create View PeopleVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3


Create view HIGHESTINFECTIONRATE as
-- Which country has the highest infection rate?
Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((Total_cases/population))*100 as PercentPopInfected
From PortfolioProject..CovidDeaths
--Where location like '%Germany%'
Group by Location, Population
--order by PercentPopInfected desc