library(tidyverse)
library(assertr)

meteorite_landings_raw <- read_csv("data/meteorite_landings.csv")

meteorite_landings_cleaned <- meteorite_landings_raw %>%
  janitor::clean_names() %>% 
  mutate(geo_location = 
  str_remove_all(geo_location, "[()]")) %>% 
  separate(geo_location,
           into = c("latitude", "longitude"),
           sep = ", ") %>% 
  mutate(latitude = as.double(latitude),
         longitude = as.double(longitude)) %>% 
  as.data.frame() %>% 
  mutate(latitude = coalesce(latitude, 0),
         longitude = coalesce(longitude, 0)) %>% 
  filter(mass_g >= 1000) %>%         # drops 40,845 values
  arrange(year)

meteorite_landings_cleaned %>% 
  summarise(across(.fns = ~sum(is.na(.x))))

meteorite_landings_cleaned %>% 
  verify(latitude >= -90 & latitude <= 90) %>% 
  verify(longitude >= -180 & longitude <= 180) %>% 
  verify(mass_g >= 1000) %>% 
  verify(fall %in% c("Fell", "Found")) %>% 
  drop_na() %>% # Dropped NA's as I know 57 NA's in year but want to verify remaining values
  verify(year <= 2020 & year >= 0) # is there a way to include is.na() in verify?(i.e is between 0 and 2020 or is NA)


