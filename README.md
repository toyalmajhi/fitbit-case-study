# fitbit-case-study
# 🏃‍♀️ Fitbit Fitness Tracker Data Analysis

This case study explores the use of smart fitness devices by analyzing user data from Fitbit devices. The goal is to gain insights into users' daily activity and sleep patterns to support marketing and product strategy for Bellabeat, a wellness-focused tech company.

---

## 📌 Project Summary

- **Company**: Bellabeat (for Google Data Analytics Capstone)
- **Objective**: Help Bellabeat better understand user behavior using Fitbit data.
- **Data Source**: [Fitbit dataset from Kaggle](https://www.kaggle.com/arashnic/fitbit)
- **Tools Used**: Google Sheets, R (tidyverse, janitor, ggplot2), GitHub

---

## 🔧 Tools and Libraries

- **Google Sheets**: For initial data cleaning (removing blanks, duplicates)
- **R**: 
  - `tidyverse`: Data wrangling
  - `ggplot2`: Data visualization

---

## 🧹 Data Cleaning

### 🟢 In Google Sheets:
- Removed duplicate rows from datasets.
- Deleted rows with empty/blank values.
- Saved cleaned CSVs for import into R.

### 🟢 In R:
```r
library(tidyverse)
library(ggplot2)

daily_activity <- read_csv("dailyActivity_cleaned.csv") %>% clean_names()
sleep_day <- read_csv("sleepDay_cleaned.csv") %>% clean_names()
```
```r
#merging two datasets
combined_data <- merge(sleep_day, daily_activity, by="Id")
View(combined_data)

#fewer participants appear in the combined set (24) than in daily activity (33) an inner join was used by default

# can use full join if wanted
combined_data1 <- full_join(sleep_day, daily_activity, by="Id")
View(combined_data1)

n_distinct(combined_data$Id) #24 observation 
n_distinct(combined_data1$Id) #33 observation
```
- Data Visualization is based on 24 observation.
- Rest of the code in the r file or can also acess R markdown file (pdf/html)👍.
---

## 📊 Data Analysis 

- Users average 7,500 steps per day.

- Users average 420 minutes/day (7 hours) asleep.

- Strong positive correlation between Total Time in Bed and Total Minutes Asleep.

- Weak negative correlation between Steps Taken and Sedentary Minutes.

---

## 👀Insights Shared

- Users walking more than 10,000 steps/day burn significantly more calories.
- Most users are more active on weekdays than weekends.
- Sleep tracking is inconsistent across users.

---

## 🎯Strategic Recommendations 

- Encourage consistent step goals, Many users are sedentary; marketing should promote step challenges.
- Promote daily step goals and rewards for 10,000+ steps.
- Highlight calorie-tracking features and how they tie to fitness goals.
- Add push notifications or reminders to wear the device consistently.
- Educate users on the health benefits of regular sleep tracking.

