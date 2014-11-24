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
plot_5 <- subset(NEI_SCC, fips == "24510" & type =="ON-ROAD", c("Emissions", "Year","type"))
plot_5 <- aggregate(Emissions ~ Year, plot_5, sum)

ggplot(data=plot_5, aes(x=Year, y=Emissions)) + geom_line() + geom_point( size=4, shape=21, fill="white") + xlab("Year") + ylab("Emissions (tons)") + ggtitle("Motor Vehicle PM2.5 Emissions in Baltimore")

ggsave(file="plot_5.png")
