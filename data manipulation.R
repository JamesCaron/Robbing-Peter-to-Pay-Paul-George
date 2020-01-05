library(xlsx)
library(data.table)
library(readr)
library(tidyr)
library(dplyr)
library(stringr)
library(ggplot2)

setwd("C:/Users/james/Downloads/SUU Fall 2019/Econometrics/research project NEW")
df <- read.csv("salaries_df_1.csv")
df <- df %>%
  group_by(player_id) %>%
  arrange(year) %>%
  mutate(player_year = rank(year)) %>%
  ungroup()
df$cpa_one <- ifelse(df$year < "1996",1,0)
df$cpa_two <- ifelse(df$year >= "1996" & df$year < "1999",1,0)
df$cpa_three <- ifelse(df$year >= "1999" & df$year < "2005",1,0)
df$cpa_four <- ifelse(df$year >= "2005" & df$year < "2011",1,0)
df$cpa_five <- ifelse(df$year >= "2011" & df$year < "2017",1,0)
df$cpa_six <- ifelse(df$year >= "2017",1,0)
df$top_player <- ifelse(df$salary_team_rank < 2, 1, 0)
df$top_two_player <- ifelse(df$salary_team_rank < 3, 1, 0)
df$top_three_player <- ifelse(df$salary_team_rank < 4, 1, 0)
df$starting_five <- ifelse(df$salary_team_rank < 6, 1,0)

write.csv(df, "salaries_df.csv", row.names = F)
