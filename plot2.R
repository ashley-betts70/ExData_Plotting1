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

png('plot2.png', width=480, height=480, units="px")
par(mfrow=c(1,1))
plot(hpc$DateTime,hpc$Global_active_power,xlab="", ylab="Global Active Power (kilowatts)", type="l")
dev.off()
