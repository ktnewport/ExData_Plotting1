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
##Fun with mfrow & margins
par(mfrow = c(2,2), mar = c(4,4,2,1))
## Graph 1
with(dataready, plot(Date_time, Global_active_power, main ="", ylab = "Global Active Power (kilowatts)", pch = ".", xlab = ""))
lines(dataready$Date_time, dataready$Global_active_power, lwd = 1)
##Graph 2
with(dataready, plot(Date_time, Voltage, main ="", ylab = "Voltage", pch = ".", xlab = "datetime"))
lines(dataready$Date_time, dataready$Voltage, lwd = 1)
## Graph 3
with(dataready, plot(Date_time, Sub_metering_1, type = "n", main = "", ylab = "Engery sub metering", xlab = ""))
lines(dataready$Date_time, dataready$Sub_metering_1, col = "black")
lines(dataready$Date_time, dataready$Sub_metering_2, col = "red")
lines(dataready$Date_time, dataready$Sub_metering_3, col = "blue")
## I don't know what's going on.  This legend script works in the single graph, but will not produce when part of the quad-graph...
legend("topright", lwd = 1, bty = "n", bg = "transparent", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
## Graph 4
with(dataready, plot(Date_time, Global_reactive_power, main ="", ylab = "Global_reactive_power", pch = ".", xlab = "datetime"))
lines(dataready$Date_time, dataready$Global_reactive_power, lwd = 1)
## Print to PNG and turn device off
dev.copy(png, file = "plot4.png")
dev.off()