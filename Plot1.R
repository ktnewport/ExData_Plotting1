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
## histogram fun
par(mfrow = c(1,1), mar = c(3, 3, 3, 3))
plot1<-hist(dataready$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", ylab = "Frequency", main = paste("Global Active Power"))
## Print to PNG and turn device off
dev.copy(png, file = "Plot1.png")
dev.off()