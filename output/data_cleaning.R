library(lubridate)
library(tidyverse)

data <- read.csv("../data/GlobalLandTemperaturesByCountry.csv")
data$dt <- as.Date(data$dt)
data <- data %>% 
  mutate(year = year(dt)) %>% 
  group_by(Country, year) %>% 
  summarise(AvgTemp = mean(AverageTemperature, na.rm = T),
            AvgUncertainty = mean(AverageTemperatureUncertainty, na.rm = T))

data <- data %>% 
  mutate(UpperQuantile = AvgTemp - AvgUncertainty/2) %>% 
  mutate(LowerQuantile = AvgTemp + AvgUncertainty/2)
                        

write.csv(data, file="../output/CleanedTemperaturesByCountry.csv", row.names=FALSE)

