#programming project code

library(arsenal)
library(tidyverse)

path_to_file <- "score.csv"
score <- read_csv(path_to_file)

head(score)

score <- score[order(id)]
