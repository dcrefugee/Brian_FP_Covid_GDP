## Installing and basic graphs in R
## Installing
install.packages('readr')
## Loading
library('readr')

install.packages("scales")
library("scales")

# Read a csv file
covid_gdp <-read_csv("r_data/r_total_deaths_gdp.csv")


# Basic Exploration of Data in R
head(covid_gdp)
tail(covid_gdp)
summary(covid_gdp)

# Assign Variables 
x<-covid_gdp$total_deaths
y<-covid_gdp$median_gdp_2016_2020
h<-covid_gdp$hospital_beds_per_thousand
d<-covid_gdp$human_development_index

# Correlation Tests


# Correlation Deaths and Human Development Index
pearsons_death_human_dev<-cor.test(covid_gdp$total_deaths,covid_gdp$human_development_index,method="pearson")

pearsons_death_human_dev

# Correlation Deaths and Median GDP

pearsons_deaths_median_gdp<-cor.test(covid_gdp$total_deaths,covid_gdp$median_gdp_2016_2020,method="pearson")

pearsons_deaths_median_gdp


# Correlation Deaths and Hospital Beds per 1000

pearsons_deaths_hospital_beds<-cor.test(covid_gdp$total_deaths,covid_gdp$hospital_beds_per_thousand,method="pearson")

pearsons_deaths_hospital_beds