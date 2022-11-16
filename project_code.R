#Candidate number: 221352
#programming project code
#

#Please uncomment the packages and run if you do not have them installed in R
# install.packages("tidyverse")
# install.packages("ggplot2")

library(rstudioapi) 
library(tidyverse)
library(ggplot2)


setwd(dirname(getActiveDocumentContext()$path))#sets working director to source location which is where the source
getwd()


#read both of the files saved in the same working directory

path_to_file <- "births.csv"
births <- read_csv(path_to_file)

path_to_file <- "score.csv"
score <- read_csv(path_to_file)
print("Check the head of the births file:")
head(births)
summary(births)
str(births)
#refactor the categorical variables with 

births$lowbw <- factor(births$lowbw, labels = c("No","Yes"))
births$preterm <- factor(births$preterm, labels = c("No","Yes"))
births$hyp <- factor(births$hyp, labels = c('No', "Yes"))
births$sex <- factor(births$sex, labels = c("Male", "Female")) #sex is 1=M, 2=F from the codebook
print("Check that the top and bottom of the data frame to see if the factors have been applied:")
head(births)
tail(births)

#remove any null values
births <- na.omit(births)
print("Check that the ID=2 with an NA has been dropped:")
head(births)

#merge the births data set with the score keeping both the matched and unmatched data

births <- merge(births, score, by = "id", all = TRUE)
births <- births[order(births$score),]
print("Check that the datasets have been appropriately merged and sorted by score")
head(births)
str(births)
print("As we have used an outer join and there are some missing score values, some IDs contain a null score field. 
      \n No entries from the original births dataframe have been lost in the merger.")


# correlation calculation

#create correlation matrix between all continuous variables

corr <- cor(births[,c("bweight", "gestwks","matage", "score")], use = "complete.obs")
print("The correlation matrix between the continuous variables is as follows: ")
corr
print("Only gestational weeks and birthweight have a significant (>0.5) correlation.")
#two way frequency tables for categorical variables

lowbw_preterm <- with(births, table(lowbw, preterm))
sprintf("Two way frequency table between low birth weight and a preterm baby: ")
lowbw_preterm
print("A preterm baby is slightly more likely to be of a low birth weight.")

sex_bw <- with(births, table(lowbw, sex))
print("Two way frequency table between low birth weight and sex: ")
sex_bw
print("Female babies appear to be slightly more likely to have a low birth weight.")

hyp_bw <- with(births, table(lowbw, hyp))
print("Two way frequency table between low birth weight and hypertension: ")
hyp_bw
print("There does not appear to be a strong connection between hypertension and low birth weight.")

preterm_hyp <- with(births, table(hyp, preterm))
print("Two way frequency table between a preterm baby and hypertension: ")
preterm_hyp
print("There does not appear to be a strong connection between maternal hypertension and a preterm baby.")

preterm_sex <- with(births, table(sex, preterm))
print("Two way frequency table between a preterm baby and sex: ")
preterm_sex
print("There does not appear to be a strong connection between sex and a preterm baby.")

sex_hyp <- with(births, table(hyp, sex))
print("Two way frequency table between hypertension and sex: ")
sex_hyp
print("Maternal hypertension appears to result in slightly more male babies.")


#create new column with a Yes for score > 150

births$highscore <- with(births, ifelse(score>150, "Yes", "No"))

print("Check that the highscore has been created and check the tail to see that NAs have been kept as NA")
head(births)
tail(births)

#create aggregated dataset with mean birthweight by sex and highscore

aggr <- aggregate(bweight~highscore+sex, data=births, FUN=mean)
print("Table of mean birthweight by sex of the baby and whether it has a highscore")

#create a plot between the variables bweight and gestwks as they are the only cont. variables with a corr >0.5

ggplot(births, aes(x = gestwks, y = bweight)) +
      geom_smooth(method = lm, se = FALSE, color = "red") +
      geom_point(color = "#000099", alpha = 0.3)+ 
      labs(x = "Gestational weeks", y = "Birth weight (g)") +
      ggtitle("Birth weight by gestational weeks \n with line of best fit")

ggsave("bweight_plot_r.pdf")

#write the final data to a csv

write.csv(births, "births_output_r.csv")

