select * 
from PortfolioProjects..CovidDeaths$
order by 3,4;

--select * 
--from PortfolioProjects..CovidVaccinations$
--order by 3,4;

-- select data that we are going to be using
select location, date, total_cases, new_cases, total_Deaths, population
from PortfolioProjects..CovidDeaths$

-- looking at total cases vs total deaths

select location, date, total_cases, total_Deaths, (total_Deaths/total_cases)*100 as DeathPercentage
from PortfolioProjects..CovidDeaths$ where location like 'India'
order by 1,2

-- looking at total cases vs population

select location, date, total_cases, population, ROUND((total_cases/population)*100, 2) as RateOfInfection
from PortfolioProjects..CovidDeaths$ where location like 'India'
order by 1,2 desc

-- looking at countries with highest infection rate compared to population
select location, population, max(total_cases) as highest_infection, max((total_cases/population))*100 as infectedpercent
from PortfolioProjects..CovidDeaths$
group by location,population
order by infectedpercent desc 

-- showing countries with highest death count per population
select location,max(total_deaths) as total_death_count 
from PortfolioProjects..CovidDeaths$
group by location
order by total_death_count desc