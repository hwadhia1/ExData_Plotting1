# Plot 2
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

# Plot a line graph of Global Active Power
with(data,plot(timestamps,Global_active_power,type="l",xlab="",ylab="Global Active Power (kilowatts)"))

# Copy screen plot to png and save file
dev.copy(png,"plot2.png")
dev.off()
