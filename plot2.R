link<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(link, destfile = "./exhousehold.zip", method = "curl")
unzip(zipfile = "./exhousehold.zip")
rawdata<- read.table("./household_power_consumption.txt", sep = ";", na.strings = "?", header = TRUE, stringsAsFactors = FALSE)
library(dplyr)
cutdata<- filter(rawdata, Date == "1/2/2007"| Date == "2/2/2007")
combo_time <-paste(cutdata$Date, cutdata$Time, collapse = NULL, sep = ' ')
library(lubridate)
Date_time<-strptime(combo_time, format = "%d/%m/%Y %H:%M:%S")
cutdata1<-select(cutdata, Global_active_power : Sub_metering_3)
dataready<- cbind(Date_time, cutdata1)
dataready<- mutate(dataready, weekday=wday(Date_time, label = TRUE, abbr = TRUE))
## fun with line plots
with(dataready, plot(Date_time, Global_active_power, main ="", ylab = "Global Active Power (kilowatts)", pch = ".", xlab = ""))
lines(dataready$Date_time, dataready$Global_active_power, lwd = 1)
## Print to PNG and turn device off
dev.copy(png, file = "plot2.png")
dev.off()