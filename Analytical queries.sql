-- Emissions by locations across the US
Select latitude,
longitude,
`GHG emissions mtons CO2e` as Emissions
from emissions_data
limit 10

-- Emissions per person
-- Usin CAST to convert data from STRING to INT type
SELECT county_state_name,
       population,
       CAST(
         REPLACE(`GHG emissions mtons CO2e`, ',', '') AS DOUBLE
       ) / CAST(
         REPLACE(population, ',', '') AS DOUBLE
       ) AS emissions_per_person
FROM emissions_data
order by emissions_per_person DESC
limit 10

-- Top 10 States with the Highest total emissons
SELECT state_abbr,
       SUM(
       CAST(
         REPLACE(`GHG emissions mtons CO2e`, ',', '') AS DOUBLE
       ) / CAST(
         REPLACE(population, ',', '') AS DOUBLE
       )) AS Total_emissions
FROM emissions_data
group by state_abbr
order by Total_emissions DESC
limit 10

-- Percentage of Top 10 States compared to the total emissons of the US
With Top10 as(
 SELECT state_abbr,
       SUM(
       CAST(
         REPLACE(`GHG emissions mtons CO2e`, ',', '') AS DOUBLE
       ) 
       ) AS Total_emissions
FROM emissions_data
group by state_abbr
order by Total_emissions DESC
limit 10
)

select SUM(Total_emissions) as Top10_Emission,
(SUM(Total_emissions)/
(Select  SUM(
       CAST(
         REPLACE(`GHG emissions mtons CO2e`, ',', '') AS DOUBLE)) from emissions_data)) * 100 AS Top10_Percentage
from Top10

-- Top 10 County with the Highest emissions
SELECT county_state_name,
       population,
       CAST(
         REPLACE(`GHG emissions mtons CO2e`, ',', '') AS DOUBLE
       )  AS Total_emission
FROM emissions_data
order by Total_emission DESC
limit 10
