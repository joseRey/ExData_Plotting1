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


## Plot 4
png("plot4.png", width=480, height=480)

par(mfrow=c(2,2),mar=c(4,4,4,1.5), oma=c(0,0,0,0))

with(DT, {
  plot(datetime, Global_active_power, type="n",
       xlab="", ylab="Global Active Power")
  lines(datetime, Global_active_power)})

with(DT, {
  plot(datetime, Voltage, type="n")
  lines(datetime, Voltage)})

legendText <- c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
legendColor <- c("black","red","blue")
with(DT, {
  plot(datetime, Sub_metering_1, type="n",
       xlab="", ylab="Energy sub metering")
  lines(datetime, Sub_metering_1, col="black")
  lines(datetime, Sub_metering_2, col="red")
  lines(datetime, Sub_metering_3, col="blue")
  legend("topright", lty=1,  col=legendColor,
         legend=legendText,
         bty="n")})

with(DT, {
  plot(datetime, Global_reactive_power, type="n")
  lines(datetime, Global_reactive_power)})
dev.off()
