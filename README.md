# Data Exploration of Covid data in SQL
This project was started as a way to learn the tools and features of a database workbench. Up to this point, My SQL and database management experience had been based solely in a MySQL command line client. 

In this project i explore a Covid dataset with particular attention paid to <b>SQL formatting within a workbench, import tools, and syntax</b><br><br>
<b>
Skills Utilized:<br>
Import Tools<br>
Syntax<br>
Aggregate Functions<br>
Window Functions
</b>

---

## The Dataset
This dataset comes from https://ourworldindata.org/covid-deaths and contains worldwide data from the start of 2020 until today. In this project, I focus specifically on the height of the pandemic and exclude data after the start of 2022

### Cleaning the Data
This data was relatively clean from the start, only containing some extra spaces and duplicates so i was able to prepare the data in excel (TRIM, remove duplicates). This is also where i split up the data into 2 seperate tables (deaths, vaccinations).
  <br> <br>NOTE: for data cleaning, i prefer to use python(pandas), i did not find it necessary for this project</br> </br>
 

 ###  Importing Data
 I am using Microsoft SQL server in this project, which includes an import/export wizard. I had a few problems using it and opted for a flat file import and set the datatypes manually. This gave me the most confidence in subsequent querying. to test the import i used these 2 simple queries. 
 Now that we know the data was imported correctly we can continue with more complex queries.<br><br><br>

![image](https://github.com/Gmindedahl/sql_covid/assets/132941581/c69d9b32-486d-4929-947a-21905a12585d)
![image](https://github.com/Gmindedahl/sql_covid/assets/132941581/0e373738-4cdb-4c74-bb3e-54783aeccdf7)
![image](https://github.com/Gmindedahl/sql_covid/assets/132941581/fdd27bff-b38a-4d3d-8822-3833ec11a55d)
<br><br>

# Gaining Insight Using SQL 
### What was the Daily Mortality Rate of this Illness in the United States?<br><br>
![image](https://github.com/Gmindedahl/sql_covid/assets/132941581/5a8bac14-daa2-455e-88d1-a16a466c585e)
![image](https://github.com/Gmindedahl/sql_covid/assets/132941581/f4c5e481-4dd9-4e81-b3d2-b3bb10bd5ade)<br><br>

This query shows us the mortality rate of the disease on each day of the pandemic. I have included the results from the first 2 weeks of 2021, and just from these few lines we can make some solid conclusions.<br>
1. In just the first year of the pandemic (starting (1/1/2020), there were over 350,000 deaths attributed to the disease
2. If you were to contract this disease, your chance of death was less than 2%, given you lived in the United States
3. Because i did not group by location, we can see trends in mortality rate. We see that by this time, the percent chance of death was continuing on a steady decline.

--- 

### On Which Day did the Danes Cross the 10% Infected Mark?<br><br>

![image](https://github.com/Gmindedahl/sql_covid/assets/132941581/f6252365-f809-43d2-b28b-b716cea9ee03)<br><br>
![image](https://github.com/Gmindedahl/sql_covid/assets/132941581/f7ef6ac7-a49c-41bc-bf9d-d14dd79d333a)<br><br>

Here we can see that over 10% of Denmark was infected starting on 12/17/21. While this is a rather simple query, i like how easy it is to change the parameters to find customized data points. Change country and percentage by specifying country name in the LIKE clause, and the '10' to a specified percent, respectively.<br><br>
NOTE: total_cases and population are both datatype NUMERIC. It is actually unnecessary to cast them as datatype FLOAT but it is there for syntax practice purposes.

---

### Which Countries Have the highest Infection Rate?<br><br>
![image](https://github.com/Gmindedahl/sql_covid/assets/132941581/95279340-01c2-4a2c-9938-7d33a56d5dc2)<br><br>
![image](https://github.com/Gmindedahl/sql_covid/assets/132941581/508ad3ac-7042-465c-8574-ed0c8258c8fc)<br><br>

Ive included the first 10 results from this query. As we can see, the countries with the highest infection rate are typically lower population countries which makes sense from a statistical standpoint.<br><br> It would also be interesting to see which countries had the highest and lowest average cases throughout the pandemic.
This could easily be achieved by swapping the aggregate function "MAX" to to "AVG" on the percent_pop_infected column.

---

### Create a Rolling Total of Vaccinations by Country and Date<br><br>
![image](https://github.com/Gmindedahl/sql_covid/assets/132941581/2e32ce52-0f75-4935-9dc0-695adeeabff6)<br><br>
![image](https://github.com/Gmindedahl/sql_covid/assets/132941581/da1f46e6-79b7-43c5-9bca-2fdc6df18beb)<br><br>

After successfully joining the two tables, we can use this query to look at the number of new vaccinations being reported by the United States by date, as well as the rolling total of vaccinations up to that point. I included the first two weeks of results starting with the day prior to the first reported vaccinations.<br><br>
I had to use a window function here to ensure the rolling total would start at 0 for each country. Although only US data will be shown due to the included WHERE clause, i added the window function so the query will maintain its functionality if i decide to remove 'dea.location LIKE' and return data from all countries.

---

# Conclusion<br><br>
SQL workbenches do provide valuable tools and functionality to better manage and query your database. Importing data was relatively straightforward, and the syntax highlighting in the workbench is helpful to solve problems, or change queries at a glance.<br><br>

Although this project was mainly for practicing syntax and readability, I can see a few different directions this project could go if i wanted to to take it further. The joined tables weren't really utilized in the above queries, but the data lends itself to be visualized in a map format, i perfer Tableau. It would not be too difficult to add what is needed 
for drilldown funcionality in Tableau, then creating a map that can provide individualized data about continent, country, state/province, etc.










