# Exploratory Data Analysis and Data Cleanup of COVID-19 Data
## Skills Used: SQL(Window Functions, View Creation, CTE Creation, Temp Table Creation, Aggregation)
### Data From: [Our World in Data COVID-19 World Data](https://ourworldindata.org/covid-deaths)
Personal Project exploring COVID-19 death and vaccination rates by country and continent.  Mainly exploratory in nature and was to prepare for Tableau dashboard I published [here](https://public.tableau.com/app/profile/alberto.rivas.ii).\
Created a view for COVID-19 of rolling death toll with information from a CTE\
Created 7 queries to export to excel and use for further analysis in Tableau including vaccination rates, GDP per capita, and death rates all by country and/or date\

Goal was to try and visualize the relationship between COVID-19 vaccination rates and the death rate of any given country and create an animation on Tableau for those interested to see how vaccination and death rates changed over time.

## Possibilities for Improvement
- Fill Null Values in SQL to have one less step for Tableau analysis
- Explore other data comparison options such as GDP/capita and its relation to COVID-19 Deaths
- Create a view that creates vaccination and death rates on a per capita basis
