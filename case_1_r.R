#load pakage

library("tidyverse")
library("ggplot2")
library(here)

#load csv

list.files("case_study_1_fitbit")

daily_activity <- read.csv("case_study_1_fitbit/daily_activity_merged.csv")
sleep_day <- read.csv("case_study_1_fitbit/sleepDay_merged.csv")

#view first 5 rows

head(daily_activity)
head(sleep_day)

#column name

colnames(sleep_day)
colnames(daily_activity)

#"Id" is present in both datasets

#number of unique participants

n_distinct(daily_activity$Id)  # 33 participants
n_distinct(sleep_day$Id)       # 24 participants

nrow(daily_activity)  # 940 observations(Records)
nrow(sleep_day)       # 413 observations(Records)

#This shows that fewer users are consistently using the sleep tracker compared to activity tracker. We can say by observing the records

#summary for daily activity
daily_activity %>%
  select(TotalSteps, TotalDistance, SedentaryMinutes) %>%
  summary()

## Average daily steps: ~7,500

ggplot(daily_activity, aes(x = TotalSteps)) +
  geom_histogram(binwidth = 1000, fill = "skyblue", color = "white") +
  labs(title = "Distribution of Daily Steps")

#summary for sleep
sleep_day %>%  
  select(TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed) %>% 
  summary()

#steps vs Sedentary Minutes:
ggplot(data=daily_activity, aes(x=TotalSteps, y=SedentaryMinutes)) + geom_point()


#minute asleep vs time in bed
ggplot(data=sleep_day, aes(x=TotalMinutesAsleep, y=TotalTimeInBed)) + geom_point()

#merging two datasets
combined_data <- merge(sleep_day, daily_activity, by="Id")
View(combined_data)

write.csv(combined_data, "combined_fitbit_data.csv", row.names = FALSE) #saving the file

#fewer participants appear in the combined set (24) than in daily activity (33) an inner join was used by default

# can use full join if wanted
combined_data1 <- full_join(sleep_day, daily_activity, by="Id")
View(combined_data1)
write.csv(combined_data1, "combined_fitbit_data1.csv", row.names = FALSE)

n_distinct(combined_data$Id) #24
n_distinct(combined_data1$Id) #33


#sleep more vs take more or less steps
ggplot(data = combined_data, aes(x = TotalMinutesAsleep, y = TotalSteps)) +
  geom_point(color = "purple", alpha = 0.5) +
  geom_smooth(method = "lm", color = "darkblue", se = TRUE)
  
  
#enhanced plot for above all three plots (practice)

#1. Relationship Between Total Steps and Sedentary Minutes

ggplot(data = daily_activity, aes(x = TotalSteps, y = SedentaryMinutes)) +
  geom_point(color = "steelblue", alpha = 0.6) +
  geom_smooth(method = "lm", color = "darkred", se = TRUE) +
  labs(
    title = "Relationship Between Total Steps and Sedentary Minutes",
    subtitle = "Does more activity mean less sedentary time?",
    x = "Total Steps",
    y = "Sedentary Minutes"
  ) +
  theme_minimal()

#2. Minutes Asleep vs Total Time in Bed

ggplot(data = sleep_day, aes(x = TotalMinutesAsleep, y = TotalTimeInBed)) +
  geom_point(color = "darkgreen", alpha = 0.6) +
  geom_smooth(method = "lm", color = "black", se = TRUE) +
  labs(
    title = "Minutes Asleep vs Total Time in Bed",
    subtitle = "Do users spend more time in bed than they sleep?",
    x = "Total Minutes Asleep",
    y = "Total Time in Bed (minutes)"
  ) +
  theme_minimal()

#3. sleep more vs take more or less steps 
ggplot(data = combined_data, aes(x = TotalMinutesAsleep, y = TotalSteps)) +
  geom_point(
    aes(color = TotalMinutesAsleep),
    size = 3,
    alpha = 0.7,
    shape = 16
  ) +
  scale_color_gradient(low = "lightblue", high = "darkblue") +
  geom_smooth(method = "lm", color = "red", se = FALSE, linetype = "dashed") +
  labs(
    title = "Relationship Between Sleep Duration and Daily Step Count",
    subtitle = "Fitbit Data: Visualizing if more sleep correlates with more steps",
    x = "Total Minutes Asleep",
    y = "Total Steps",
    color = "Sleep Duration"
  ) +
  theme_minimal(base_size = 14)

## Additional Visualizations

# 4. Calories Burned vs Total Steps

#Positive linear correlation b/w total steps and calories burned

cor(daily_activity$TotalSteps, daily_activity$Calories, use = "complete.obs")

#If this gives a correlation coefficient (r) around 0.5 or higher, it indicates a positive relationship

ggplot(data = daily_activity, aes(x = TotalSteps, y = Calories)) +
  geom_point(color = "orange", alpha = 0.6) +
  geom_smooth(method = "lm", color = "darkorange", se = TRUE) +
  labs(
    title = "Calories Burned vs Total Steps",
    subtitle = "Does walking more burn more calories?",
    x = "Total Steps",
    y = "Calories Burned"
  ) +
  theme_minimal()


# 5. Time Spent in Various Activity Intensities


intensity_data <- daily_activity %>%
  select(VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes) %>%
  pivot_longer(cols = everything(), names_to = "ActivityLevel", values_to = "Minutes")

ggplot(intensity_data, aes(x = ActivityLevel, y = Minutes, fill = ActivityLevel)) +
  geom_boxplot() +
  labs(
    title = "Time Spent in Various Activity Intensities",
    subtitle = "Distribution of minutes per day across activity levels",
    x = "Activity Level",
    y = "Minutes per Day"
  ) +
  theme_minimal() +
  theme(legend.position = "none")


# 6. Daily Activity Breakdown - Bar Plot

daily_activity_long <- daily_activity %>%
  select(Id, VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes) %>%
  pivot_longer(cols = -Id, names_to = "Activity", values_to = "Minutes")

ggplot(daily_activity_long, aes(x = Activity, y = Minutes, fill = Activity)) +
  geom_bar(stat = "summary", fun = "mean") +
  labs(
    title = "Average Time Spent in Each Activity Category",
    y = "Average Minutes",
    x = "Activity Level"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

