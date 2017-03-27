library(dplyr)
setClass("myDate")
setAs("character","myDate", function(from) as.Date(from, format="%d/%m/%Y"))
if (!file.exists("household_power_consumption.zip")) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "household_power_consumption.zip")
}

# Read the data file and setup most of the column classes
hpc <- read.table(unz("household_power_consumption.zip","household_power_consumption.txt"), header=T,sep=";",stringsAsFactors = F, colClasses = c("myDate","character",rep("numeric",7)),na.strings=c("?"))
# Finish the processing of the data. Reduce size as first step.
hpc <- hpc %>% 
  filter(Date >= "2007-02-01" & Date <= "2007-02-02") %>% 
  mutate(DateTime = as.POSIXct(strptime(paste(format(Date, format="%d/%m/%Y"), Time), "%d/%m/%Y %H:%M:%S"))) %>%
  select(-c(Date,Time))

png('plot4.png', width=480, height=480, units="px")
par(mfrow=c(2,2))
plot(hpc$DateTime,hpc$Global_active_power,xlab="", ylab="Global Active Power (kilowatts)", type="l")
plot(hpc$DateTime,hpc$Voltage,xlab="", ylab="Voltage", type="l")
plot(hpc$DateTime,hpc$Sub_metering_1, xlab="", ylab="Energy sub metering", type="l",col="black")
lines(hpc$DateTime,hpc$Sub_metering_2,col="green")
lines(hpc$DateTime,hpc$Sub_metering_3,col="blue")
legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c("black","green","blue"), lty=c(1,1,1))
plot(hpc$DateTime,hpc$Global_reactive_power,xlab="", ylab="Global_reactive_power", type="l")
dev.off()
