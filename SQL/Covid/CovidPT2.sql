--select * from PortfolioProjects..CovidDeaths$
--where continent is not null
--order by 3,4

select location, max(cast(total_deaths as int)) as
TotalDeathCount from PortfolioProjects..CovidDeaths$
where continent is not null
group by location
order by TotalDeathCount desc

-- LET'S BREAK THINGS DOWN BY CONTINENT
select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProjects..CovidDeaths$
where continent is not null
group by continent
order by TotalDeathCount desc

--  global numbers

select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProjects..CovidDeaths$
where continent is not null
-- group by date
order by 1,2

select * from PortfolioProjects..CovidVaccinations$

-- looking at total population vs vaccinations 

select * from PortfolioProjects..CovidDeaths$ da
join PortfolioProjects..CovidVaccinations$ vac
on da.date=vac.date and da.location=vac.location

select dea.continent, dea.location, dea.date, population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as vaccine_count
from PortfolioProjects..CovidDeaths$ dea
join PortfolioProjects..CovidVaccinations$ vac
on dea.date=vac.date and dea.location=vac.location
where dea.continent is not null
order by 2,3


-- USE CTE
with PopvsVac (continent, location,date, population,new_vaccinations,vaccine_count)
as
(
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) as vaccine_count
from PortfolioProjects..CovidDeaths$ dea
join PortfolioProjects..CovidVaccinations$ vac
on dea.date=vac.date and dea.location=vac.location
where dea.continent is not null
-- order by( 2,3
)select *,(vaccine_count/population)*100 from PopvsVac


-- TEMP TABLES
drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
total_vaccinated numeric)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) as vaccine_count
from PortfolioProjects..CovidDeaths$ dea
join PortfolioProjects..CovidVaccinations$ vac
on dea.date=vac.date and dea.location=vac.location
where dea.continent is not null

Select *,(total_vaccinated/population)*100 as percentage_vaccine from #PercentPopulationVaccinated


-- create view to store data for later visualizations
create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) as vaccine_count
from PortfolioProjects..CovidDeaths$ dea
join PortfolioProjects..CovidVaccinations$ vac
on dea.date=vac.date and dea.location=vac.location
where dea.continent is not null

select * from PercentPopulationVaccinated
