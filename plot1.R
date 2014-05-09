require(data.table)
DT <- fread("household_power_consumption.txt",
            sep=";", header=TRUE, na.strings="?", stringsAsFactors =FALSE)

startDate <- as.Date("2007-02-01","%Y-%m-%d")
endDate <- as.Date("2007-02-02","%Y-%m-%d")

DT <- DT[as.Date(Date,"%d/%m/%Y") %in% c(startDate, endDate)]


# columns to become numeric
toNumeric <- c("Global_active_power", "Global_reactive_power",
               "Voltage", "Global_intensity",
               "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")

# two data.table opperations
#   1. convert list of coumns to numeric
#   2. create new datetime column with the combination of Date and Time strings
DT[,(toNumeric):= lapply(.SD, as.numeric),.SDcols=toNumeric]
DT[,datetime:= as.POSIXct(paste(Date, Time), format="%d/%m/%Y %H:%M:%S")]

## Plot 1
png("plot1.png", width=480, height=480)
with(DT,
     hist(Global_active_power, col="red",
          xlab="Global Active Power (killowats)", main="Global Active Power",
          bty="n"))
dev.off()

