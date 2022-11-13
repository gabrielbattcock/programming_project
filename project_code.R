#programming project code

working_directory = "~/Documents/LSHTM/Programming/programming_project/programming_project"
setwd(working_directory)

library(arsenal)
library(tidyverse)
library(Epi)

#read both of the files saved in the same working directory
path_to_file <- "births.csv"
births <- read_csv(path_to_file)

path_to_file <- "score.csv"
score <- read_csv(path_to_file)
head(births)

#refactor the categorical variables with 
births$lowbw <- factor(births$lowbw, labels = c("No","Yes"))
births$preterm <- factor(births$preterm, labels = c("No","Yes"))
births$hyp <- factor(births$hyp, labels = c('No', "Yes"))
#sex is 1=M, 2=F from the codebook
births$sex <- factor(births$sex, labels = c("Male", "Female"))

#remove any null values
births <- na.omit(births)
head(births)

#merge the births data set with the score keeping both the matched and unmatched data
births <- merge(births, score, by = "id", all = TRUE)
births <- births[order(births$score),]
head(births)

#create plots to examine whether a spearman is valid

par(mfrow=c(2,3))
plot(births$bweight~births$gestwks)
plot(births$bweight~births$matage)
plot(births$bweight~births$score)
plot(births$gestwks~births$matage)
plot(births$gestwks~births$score)
plot(births$score~births$matage)

# matage does not appear to have any correlation to the other variables so has not been used in the
# correlation calculation

#create correlation matrix between all continuous variables

corr <- cor(births[,c("bweight", "gestwks", "score")], use = "complete.obs", method = "spearman")
print(corr)

# two_way <- lm(data = births_match, formula = )
  
#create new column with a Yes for score > 150
births$highscore <- with(births, ifelse(score>150, "Yes", "No"))
head(births)


aggr <- aggregate(bweight~highscore+sex, data=births, FUN=mean)
print(aggr)

#create a plot between the variables bweight and gestwks as they are the only cont. variables with a corr >0.5

plot(x=births$gestwks, y=births$bweight)



#write the final data to a csv

write.csv(births, "births_output_r.csv", )

