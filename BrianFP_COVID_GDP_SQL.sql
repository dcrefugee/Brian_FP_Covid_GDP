
--SQL Code used to clean and create tables used for visualizations in support 
--of my data analyst portfolio project looking at COVID 19 and Gross Domestic Product
--data.  

--The project page can be found at https://sites.google.com/view/brianfpcovidandgdp

--I can be reached at bfperry(at)gmail
  
--Data Sources
--1. https://blogs.worldbank.org/opendata/new-world-bank-country-classifications-income-level-2020-2021
--2. https://ourworldindata.org/covid-deaths


--#1
--Countries with Highest Infection Rate Compared to Population

SELECT Location,
         Population,
         Max(total_cases) AS HighestInfectionCount,
         Max((total_cases/population))*100 AS PercentPopulationInfected
FROM Project_Covid_GDP.dbo.CovidDeaths
Where continent is not null
GROUP BY  Location, Population
ORDER BY  PercentPopulationInfected desc

--#2
-- Showing Countries with Highest Death Count

SELECT Location,
         Max(cast(Total_deaths AS int)) AS TotalDeathCount
FROM Project_Covid_GDP.dbo.CovidDeaths
WHERE continent is NOT null
GROUP BY  Location
ORDER BY  TotalDeathCount desc

--#3
-- Showing Count of Deaths by Continent - accturate but not for drill downs

SELECT location,
         Max(cast(Total_deaths AS int)) AS TotalDeathCount
FROM Project_Covid_GDP.dbo.CovidDeaths
WHERE continent is null
GROUP BY  location
ORDER BY  TotalDeathCount desc

--#4
-- Global Numbers

SELECT SUM(new_cases) AS total_cases,
         SUM(cast(new_deaths AS int)) AS total_deaths,
         SUM(cast(new_deaths AS int))/sum(new_cases)*100 AS DeathPercentage
FROM Project_Covid_GDP.dbo.CovidDeaths
WHERE continent is NOT null
ORDER BY  1,2

-- #5 Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From Project_Covid_GDP.dbo.CovidDeaths dea
Join Project_Covid_GDP.dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3



/*
Queries used for Visualizations - Power BI
*/



-- 1. 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Project_Covid_GDP.dbo.CovidDeaths
where continent is not null 
--Group By date
order by 1,2

-- 2. 

-- Removing continents and world presented as countries in data.

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From Project_Covid_GDP.dbo.CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Project_Covid_GDP.dbo.CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Project_Covid_GDP.dbo.CovidDeaths
Group by Location, Population, date
order by PercentPopulationInfected desc






--/*
--Join and queries with gdp data
--*/

----Per Capita GDP and Income Grouping

SELECT DISTINCT v.iso_code as CountryCode,
			m.IncomeGroup,
			v.life_expectancy,
			v.gdp_per_capita,
			v.location as Country
FROM Project_Covid_GDP.dbo.CovidVaccinations AS v
LEFT JOIN Project_Covid_GDP.dbo.[Metadata - Countries] AS m
	ON v.iso_code = m."Country Code"
WHERE IncomeGroup is NOT NULL
ORDER BY  iso_code desc;

---- Country and GDP

SELECT DISTINCT g.[Country Code] AS CountryCode,
			g.[Country Name] AS Country,
			g.[Median 2016-2020] AS GDP
FROM Project_Covid_GDP.dbo.GDP_Data AS g
ORDER BY  CountryCode desc;


---- Country and Country Code Index for Visualization - Power BI

SELECT DISTINCT g.[Country Code] AS CountryCode,
         g.[Country Name] AS Country
FROM Project_Covid_GDP.dbo.GDP_Data AS g
ORDER BY  CountryCode asc;


----Join Vaccination Table with GDP Table 

----Income Group Comparison on Average (GDP Per Capita, Hospital Beds, Vaccinated, Fully Vaccinated, Life Expectancy) 

SELECT m.IncomeGroup,
         AVG(v.life_expectancy) AS avg_life_expectancy,
         avg(v.gdp_per_capita) AS avg_gdp_per_capita,
         avg(v.hospital_beds_per_thousand) AS avg_hosp_beds_per_thousand,
         avg(cast (v.people_vaccinated_per_hundred AS float)) AS avg_people_vaccinated,
         avg(cast (v.people_fully_vaccinated_per_hundred AS float)) AS avg_people_fully_vaccinated,
		 avg(cast (v.positive_rate AS float)) AS positive_covid_rate
FROM Project_Covid_GDP.dbo.CovidVaccinations AS v
LEFT JOIN Project_Covid_GDP.dbo.[Metadata - Countries] AS m
    ON v.iso_code = m."Country Code"
WHERE IncomeGroup is NOT NULL
GROUP BY  IncomeGroup
ORDER BY  IncomeGroup;

--Country Comparison on Average (GDP Per Capita, Hospital Beds, Vaccinated, Fully Vaccinated, Life Expectancy)

SELECT m.Country,
         AVG(v.life_expectancy) AS avg_life_expectancy,
         avg(v.gdp_per_capita) AS avg_gdp_per_capita,
         avg(v.hospital_beds_per_thousand) AS avg_hosp_beds_per_thousand,
         avg(cast (v.people_vaccinated_per_hundred AS float)) AS avg_people_vaccinated,
         avg(cast (v.people_fully_vaccinated_per_hundred AS float)) AS avg_people_fully_vaccinated
FROM Project_Covid_GDP.dbo.CovidVaccinations AS v
LEFT JOIN Project_Covid_GDP.dbo.[Metadata - Countries] AS m
    ON v.iso_code = m."Country Code"
WHERE Country is NOT NULL
GROUP BY  Country
ORDER BY  Country;
