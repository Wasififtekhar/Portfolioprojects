select * 
FROM portfolioproject.dbo.CovidDeaths
where continent is not null
order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
FROM portfolioproject.dbo.CovidDeaths
order by 1,2


select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM portfolioproject.dbo.CovidDeaths
where location like '%states%'
order by 1,2


select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
FROM portfolioproject.dbo.CovidDeaths
where location like '%states%'
order by 1,2

select location, population, MAX(total_cases) as highestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM portfolioproject.dbo.CovidDeaths
--where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc




select location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM portfolioproject.dbo.CovidDeaths
--where location like '%states%'
where continent is null
Group by location
order by TotalDeathCount desc


select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM portfolioproject.dbo.CovidDeaths
--where location like '%states%'
where continent is not null
Group by continent
order by TotalDeathCount desc


select SUM(new_cases) as total_cases, SUM(cast(New_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_cases)*100 as Deathpercentage
FROM portfolioproject.dbo.CovidDeaths
--where location like '%states%'
where continent is not null
--Group by date
order by 1,2

with PopvsVac (Continent, location, date, population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)
from portfolioproject.dbo.CovidDeaths dea
join portfolioproject.dbo.CovidVaccinations vac
    ON dea.location = vac.location
    and dea.date = vac.date
	where dea.continent is not null
	--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
from PopvsVac

      Drop table if exists #PercentPopulationVaccinated
      Create Table #PercentPopulationVaccinated
	  (
	  Continent nvarchar(255),
	  Location nvarchar(255),
	  Date datetime,
	  population numeric,
	  new_vaccinations numeric, 
	  RollingPeopleVaccinated numeric
	  )
	  
       
	Insert into #PercentPopulationVaccinated
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)
from portfolioproject.dbo.CovidDeaths dea
join portfolioproject.dbo.CovidVaccinations vac
    ON dea.location = vac.location
    and dea.date = vac.date
	where dea.continent is not null
	order by 2,3

	Select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated



--visual 
Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)
from portfolioproject.dbo.CovidDeaths dea
join portfolioproject.dbo.CovidVaccinations vac
    ON dea.location = vac.location
    and dea.date = vac.date
	where dea.continent is not null
	--order by 2,3
	      
	
