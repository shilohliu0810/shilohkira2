library(tidyverse)
#Here's the data we want in our package:
setwd("/Users/shilohliu/Dropbox/shilohkira/data-raw")
mortality <- read_csv("mortality.csv")
usethis::use_data(mortality, overwrite = TRUE)

