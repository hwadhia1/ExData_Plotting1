# Plot 3
# if the data is very large read 1st row (DF.row1) and 1st column (DF.Date)
# and use those to set col.names= and skip= during reading of all dates to be efficient
# on finding relevant subset of data based on dates for analysis

require(sqldf)

## Read power data first row and then just date column
fn<-"household_power_consumption.txt"
DF.row1 <- read.table(fn, header = TRUE, nrow = 1, sep=";")
# Number of columns
nc <- ncol(DF.row1)

# Save column names
ncnames<-names(DF.row1)
DF <- read.table(fn, header = FALSE, sep=";", as.is = TRUE, col.names=c(ncnames), colClasses = c(NA, rep("NULL", nc - 1)), comment.char="")

# Determine relevant start of dataset for date and number of rows to read
n2007_start <-  sqldf("SELECT min(rowid) FROM DF where Date='1/2/2007'")
n2007_end <-  sqldf("SELECT max(rowid) FROM DF where Date='2/2/2007'")
n2007_lines <- n2007_end-n2007_start+1
data <- read.table("household_power_consumption.txt", skip = n2007_start[[1]], nrows=n2007_lines[[1]], col.names=c(ncnames), colClasses = c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"), na.strings=("?"),sep=";", comment.char="")
timestamps<-strptime(paste(data$Date,data$Time,sep=" "),"%d/%m/%Y %H:%M:%S")

# Plot a line graph of Energy Sub Metering to screen
with(data,plot(timestamps,Sub_metering_1,type="l",xlab="",ylab=""))
title(ylab="Energy sub metering")
with(data,lines(timestamps,Sub_metering_2,type="l",col="red",xlab="",ylab="Energy sub metering"))
with(data,lines(timestamps,Sub_metering_3,type="l",col="blue",xlab="",ylab="Energy sub metering"))
legend("topright",lwd=1,legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),pch = 151, cex=.8, pt.cex=.8, col=c("black","red","blue"))

# Plot directly to png device to avoid legend truncation
png(filename="plot3.png")
with(data,plot(timestamps,Sub_metering_1,type="l",xlab="",ylab=""))
title(ylab="Energy sub metering")
with(data,lines(timestamps,Sub_metering_2,type="l",col="red",xlab="",ylab="Energy sub metering"))
with(data,lines(timestamps,Sub_metering_3,type="l",col="blue",xlab="",ylab="Energy sub metering"))
legend("topright",lwd=1,legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),pch = 151, cex=.8, pt.cex=.8, col=c("black","red","blue"))
dev.off()
