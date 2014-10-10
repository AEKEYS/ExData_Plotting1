############ PLOT 3 ################

## STEP 1: READ & PREPARE DATA ##

# Import column names and convert to character vector
# The the header names from first row
powNames <- read.table("household_power_consumption.txt",sep=";",nrows=1)
# Now convert the returned data.frame to a character vector
powNames <- sapply(powNames, as.character)

# Estimated data would require 142.49 megabytes + working space
# So... want to load only required rows

# Import just the rows from February 1st and 2nd
powData <- read.table("household_power_consumption.txt",
                      sep=";",
                      col.names = powNames, 
                      na.strings ="?",
                      colClasses ="character",
                      skip=66637,#num minutes since first observation
                      nrows=2880) #two days in minutes

# Create a new character vector that combines date and time
Date_time <- paste(powData$Date,powData$Time)
# Add vector to the data frame
powData <- cbind(Date_time,powData)
powData$Date_time<-as.character(powData$Date_time)

# Convert Date_time to POSIXlt
powData$Date_time <- strptime(powData$Date_time,
                              format="%d/%m/%Y %H:%M:%S")

# Convert Global_active_power to numeric
powData$Global_active_power <- as.numeric(powData$Global_active_power)

# Convert Sub_metering vectors to numeric
SubMetering <- lapply(powData[,8:10],as.numeric)
SubMetering<-data.frame(SubMetering)
powData[,8:10]<-SubMetering
rm(SubMetering) #remove object, no longer needed

## STEP 2: PLOT THE DATA ##

# Explicitly launch a file graphics device
png(file="plot3.png",bg="transparent")

par(oma=c(0,1,0,1)) # add padding to outer margin
par(cex.lab=.8) # decrease label magnification
par(mar=c(3,4,1,1)) # adjust plot margins

# Generate the device but don't plot data
with(powData, plot(Date_time, Sub_metering_1,
                   type="n", 
                   xlab="",
                   ylab="Energy sub metering"))
# Now, plot the data connected by lines
# First, Sub_metering_1 -- this is the kitchen
with(powData,lines(Date_time,Sub_metering_1,col="black",lwd=1))
# Next, Sub_metering_2 -- this is the laundry room
with(powData,lines(Date_time,Sub_metering_2,col="red",lwd=1))
# Finally, Sub_metering_3 -- this is elec water heater and air con
with(powData,lines(Date_time,Sub_metering_3,col="blue",lwd=1))

# Now, draw the legend
legend("topright",
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),#names
       cex=.8, #reduce magnification
       col=c("black","red","blue"), #symbol colors
       lwd=1, #symbol weight
       lty=c(1,1,1)) #symbol type

# Explicitly close graphics device
dev.off()