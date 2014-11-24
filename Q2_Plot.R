#Load the required libraries
library(plyr) 
library(reshape2)
library(ggplot2)
#After checking its existence in the working directory, download the file and extract
#if(!file.exists("exdata-data-NEI_data.zip")) {
#        temp <- tempfile()
#        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",temp, method="curl")
#        unzip(temp)
#        unlink(temp)
#}
#Read the files, subset and merge
NEI <- readRDS("summarySCC_PM25.rds") 
SCC <- readRDS("Source_Classification_Code.rds")
df <- subset(SCC, select = c("SCC", "Short.Name"))
NEI_SCC <- merge(NEI, df, by.x="SCC", by.y="SCC", all=TRUE)

NEI_SCC$Emissions <- NEI_SCC$Emissions/1000
NEI_SCC <- rename(NEI_SCC, c("year"="Year"))


#aggregate and plot
plot_2 <- subset(NEI_SCC, fips == "24510", c("Emissions", "Year","type"))
plot_2 <- aggregate(Emissions ~ Year, plot_2, sum)

plot(plot_2$Year,plot_2$Emissions, main="Total Baltimore PM2.5 Emissions", "b", xlab="Year", ylab="Emissions (thousand tons)",xaxt="n")
axis(side=1, at=c("1999", "2002", "2005", "2008"))

par(mar=c(5.1,4.1,5.1,2.1))
dev.copy(png, file="plot_2.png", width=720, height=480)

dev.off()
