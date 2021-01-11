library(tidyverse)
library(janitor)
library(lubridate)

avocados <- read_csv("data/avocado.csv") %>% 
  clean_names()
dictionary <- read_csv("data/data_dict.txt") %>% 
  clean_names()


summary(avocados)
unique(avocados$region)

regions_string <- c("California", "Midsouth", "Northeast","Plains", "SouthCentral", "Southeast", "West", "GreatLakes")

totalUS <- avocados %>% 
  filter(region == "TotalUS")

regions <- avocados %>% 
  filter(region %in% regions_string)

everywhereelse <- avocados %>% 
  filter(region != "TotalUS",
         !region %in% regions_string)


sum(totalUS$total_volume)
sum(regions$total_volume)
sum(everywhereelse$total_volume)

avocados_cleaned <- regions %>% 
  mutate(season = case_when(month(date) <= 2 | month(date) == 12 ~ "winter",
                            month(date) >= 3 & month(date) <= 5 ~ "spring",
                            month(date) >= 6 & month(date) <= 8 ~ "summer",
                            month(date) >= 9 & month(date) <= 11 ~ "autumn")) %>% 
  rename("small_hass" = "x4046",
         "large_hass" = "x4225",
         "xl_hass" = "x4770") %>%
  mutate(small_hass_percent = small_hass/total_volume*100,
         large_hass_percent = large_hass/total_volume*100,
         xl_hass_percent = xl_hass/total_volume*100,
         non_hass_percent = 
           (total_volume - small_hass - large_hass - xl_hass)/total_volume*100) %>% 
  mutate(small_bag_percent = small_bags/total_bags*100) %>% 
  mutate(organic = if_else(type == "organic", T, F),
         year = as.factor(year)) %>% 
  dplyr::select(-x1, -date, -small_bags, -large_bags, -total_bags, -x_large_bags, -small_hass, -large_hass, -xl_hass, -type)


                          
rm(avocados, dictionary, everywhereelse, regions, totalUS, regions_string)
  
  
  
  
  

