# Meteorite landings

An R project providing some investigations into meteorite landings worldwide.

# Contents

* csv file containing data on meteorite landings, within "data" folder [read only]
* "cleaning_script.R" 
  - R script which cleans the raw data
* "meteorite_analysis.Rmd"
  - R markdown file containing analysis of clean data
* "century_function.R"
  - R script containing function to determine the century a year is in
* README.md file

# Versions used

* Rstudio Version 1.3.1093
* Tidyverse 1.3.0
* ggplot2 3.3.2     * purrr   0.3.4
* tibble  3.0.4     * dplyr   1.0.2
* tidyr   1.1.2     * stringr 1.4.0
* readr   1.4.0     * forcats 0.5.0

# Instructions

Open "meteorite_analysis.Rmd" in Rstudio and run all

# Cleaning Script

* Loads "tidyverse" and "assertr"
* reads in data
* cleans column names
* creates "latitude" and "longitude" columns
* coerces NA's in "latitude" and "longitude" columns into "0"
* drops values with a mass under 1000g
* verifies data using assertr functions

# Meteorite Analysis

* Reads in cleaned data
* Loads "tidyverse" and "assertr"
* Shows 10 largest meteorites
* Finds mean mass for meteorites that were found on the ground vs those spotted falling
* Shows number of meteorites per year since 2000
* Investigates number and mean size of meteorites found in each hemisphere
  - In addition, between the tropics of Cancer and Capricorn; outwith the tropics; and within the Arctic and Antarctic circles
* Loads in "century" function
* Investigates number and mean size of meteorites per century

# Century Function

* function to determine century from year
* Issue - returns years since 2000 as "21th" century despite best efforts








