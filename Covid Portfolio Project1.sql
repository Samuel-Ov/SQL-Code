select *
from coviddata
order by 2,3

select *
from covidvaccination
order by 2,3

--Selecting data to be used 

select cd.continent, cd.date, cd.population, cd.location, cd.total_cases, cd.total_deaths, cv.new_tests, cv.new_vaccinations
from coviddata as cd
join covidvaccination cv
	on cd.location = cv.location
	and cd.date= cv.date
order by continent

---Checking the likelyhood of death compared to cases, percentage of vaccination per countries

select cd.continent, cd.date, cd.population, cd.location, (cd.total_deaths/cd.total_cases)*100 as DeathPercentage, (cv.new_vaccinations/cd.population)*100 as Vacpercentage
from coviddata as cd
join covidvaccination cv
	on cd.location = cv.location
where cd.continent is not null


select location, Max(cast(total_deaths as int)) as DeathCount 
from coviddata
where continent is not null 
group by location
order by DeathCount desc

--looking at the continent by break down: --Showing continets with the highest death count per populaation
select continent, Max(cast(total_deaths as int)) as DeathCount 
from PortfolioProject..coviddata
where continent is not null 
group by continent
order by DeathCount desc

--Global Number break down covid death cases and vaccination

select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Deathpercnt---,total_deaths, population,(total_deaths/total_cases)*100 as Dpercentage 
from PortfolioProject..coviddata
---where location like '%United%'
where continent is not null
group by date
order by 1,2

select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Deathpercnt---,total_deaths, population,(total_deaths/total_cases)*100 as Dpercentage 
from coviddata
---where location like '%United%'
where continent is not null
group by date
order by 1,2

select cd.continent, cd.location, cd.date,cd.population, cv.new_vaccinations,
sum(cast(cv.new_vaccinations as bigint)) over (partition by cd.location order by cd.location,cd.date)
from coviddata as cd
join covidvaccination cv
	on cd.location=cv.location
	and cd.date=cv.date
--where cd.continent is not null
order by 2,3

With PoVsVacc (continent, location, date, population, New_vaccinations, RollingPeopleVaccinated)
as
(select cd.continent, cd.location, cd.date,cd.population, cv.new_vaccinations
, Sum(convert(bigint, cv.new_vaccinations)) Over (Partition by cd.location order by cd.location, 
  cd.Date) as RollingPeopleVaccinated
from coviddata as cd
join covidvaccination cv
	on cd.location=cv.location
	and cd.date=cv.date
where cd.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100 as VaccinatedPopulation
from PoVsVacc
where New_vaccinations is not null

---TEMP TABLE
drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated
select cd.continent, cd.location, cd.date,cd.population, cv.new_vaccinations
, Sum(convert(bigint, cv.new_vaccinations)) Over (Partition by cd.location order by cd.location, 
  cd.Date) as RollingPeopleVaccinated
from PortfolioProject..coviddata as cd
join PortfolioProject..covidvaccination cv
	on cd.location=cv.location
	and cd.date=cv.date
where cd.continent is not null
--order by 2,3
select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated

--Creating view to store for visualizations

create view PercentPopulationVaccinated as
select cd.continent, cd.location, cd.date,cd.population, cv.new_vaccinations
, Sum(convert(bigint, cv.new_vaccinations)) Over (Partition by cd.location order by cd.location, 
  cd.Date) as RollingPeopleVaccinated
from PortfolioProject..coviddata as cd
join PortfolioProject..covidvaccination cv
	on cd.location=cv.location
	and cd.date=cv.date
where cd.continent is not null

select *
from PercentPopulationVaccinated



