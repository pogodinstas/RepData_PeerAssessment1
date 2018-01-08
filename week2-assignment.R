# Reading data
activity <- read.csv('activity.csv')

# Converting string to date
activity$date<-as.Date(activity$date)
head(activity)
class(activity[1,2])

library(dplyr)
totalSteps <- summarise(group_by(activity, date), total_steps=sum(steps))
hist(totalSteps$total_steps, main = "Total steps distribution (NAs excluded)", 
     xlab = "number of steps")
barplot(totalSteps$total_steps, main = "Total steps for each day")

# Mean steps
mean(totalSteps$total_steps, na.rm = TRUE)

# Median steps
median(totalSteps$total_steps, na.rm = TRUE)

# AVG steps for 5 min interval
fiveMinAveraged <- summarise(group_by(activity, interval), avg_steps=mean(steps, na.rm = TRUE))
plot(fiveMinAveraged$interval, fiveMinAveraged$avg_steps, type='l',
     main = "Number of steps", xlab='5 Min Interval', ylab = 'Number of steps')
fiveMinAveraged[which(fiveMinAveraged$avg_steps == max(fiveMinAveraged$avg_steps)),1]

# Calculating total number of NA
sum(is.na(activity$steps))

# Let's replace missing values with average for 5 min interval
for (i in fiveMinAveraged$interval) {
    activity[is.na(activity$steps) & activity$interval==i, 1] <- 
      fiveMinAveraged[fiveMinAveraged$interval==i,2]  
}

totalSteps <- summarise(group_by(activity, date), total_steps=sum(steps))
hist(totalSteps$total_steps, main = "Total steps distribution (NAs replaced with mean for interval)", 
     xlab = "number of steps")
# Mean steps (NAs replaced with mean for interval)
mean(totalSteps$total_steps)
# Median steps (NAs replaced with mean for interval)
median(totalSteps$total_steps)

# Analysing weekdays
activity$weekday <- weekdays(activity$date)
activity$weekday.type <- ifelse(activity$weekday == "суббота" | activity$weekday == 
                             "воскресенье", "Weekend", "Weekday")
activity$weekday.type <- factor(activity$weekday.type)

fiveMinWdAvg <- summarise(group_by(activity, interval, weekday.type), total_steps=mean(steps))
library(ggplot2)
ggplot(fiveMinWdAvg,aes(x=interval, y=total_steps))+geom_line()+facet_grid(~weekday.type)
