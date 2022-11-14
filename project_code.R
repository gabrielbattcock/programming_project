#programming project code

working_directory = "~/Documents/LSHTM/Programming/programming_project/programming_project"
setwd(working_directory)

library(arsenal)
library(tidyverse)
library(Epi)
library(ggplot2)

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

par(mfrow=c(3,2))
plot(births$bweight~births$gestwks)
plot(births$bweight~births$matage)
plot(births$bweight~births$score)
plot(births$gestwks~births$matage)
plot(births$gestwks~births$score)
plot(births$score~births$matage)

# matage does not appear to have any correlation to the other variables so has not been used in the
# correlation calculation

#create correlation matrix between all continuous variables

corr <- cor(births[,c("bweight", "gestwks", "score")], use = "complete.obs")
print(corr)

#two way frequency tables for categorical variables

lowbw_preterm <- with(births, table(lowbw, preterm))
sprintf("Two way frequency table between low birth weight and a preterm baby: ")
print(lowbw_preterm)

sex_bw <- with(births, table(lowbw, sex))
print("Two way frequency table between low birth weight and sex: ")
print(sex_bw)

hyp_bw <- with(births, table(lowbw, hyp))
print("Two way frequency table between low birth weight and hypertension: ")
print(hyp_bw)

preterm_hyp <- with(births, table(hyp, preterm))
print("Two way frequency table between a preterm baby and hypertension: ")
print(preterm_hyp)

preterm_sex <- with(births, table(sex, preterm))
print("Two way frequency table between a preterm baby and sex: ")
print(preterm_sex)

sex_hyp <- with(births, table(hyp, sex))
print("Two way frequency table between hypertension and sex: ")
print(sex_hyp)
  
#create new column with a Yes for score > 150

births$highscore <- with(births, ifelse(score>150, "Yes", "No"))

#check the tail to see that NAs have been kept as NA

tail(births)

#create aggregated dataset with mean birthweight by sex and highscore

aggr <- aggregate(bweight~highscore+sex, data=births, FUN=mean)
print(aggr)

#create a plot between the variables bweight and gestwks as they are the only cont. variables with a corr >0.5

ggplot(births, aes(x = gestwks, y = bweight)) +
      geom_point(color = "#000099", alpha = 0.3)+ 
      geom_smooth(method = "lm", se = FALSE, color = "#CC0000") +
      labs(x = "Gestational weeks", y = "Birth weight (g)")
ggsave("bweight_plot_r.pdf")

#write the final data to a csv

write.csv(births, "births_output_r.csv", )

