#Load the required libraries
library(plyr) 
library(reshape2)
library(ggplot2)
#After checking the existence of the zip file (or its contents after extraction) in the working directory, download the file and extract

if(!file.exists("exdata-data-NEI_data.zip")||(!file.exists("Source_Classification_Code.rds") && !file.exists("summarySCC_PM25.rds"))) {
        temp <- tempfile()
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",temp, method="curl")
        unzip(temp)
        unlink(temp)
}
#Read the files, subset and merge
NEI <- readRDS("summarySCC_PM25.rds") 
SCC <- readRDS("Source_Classification_Code.rds")
df <- subset(SCC, select = c("SCC", "Short.Name"))
NEI_SCC <- merge(NEI, df, by.x="SCC", by.y="SCC", all=TRUE)

NEI_SCC$Emissions <- NEI_SCC$Emissions/1000
NEI_SCC <- rename(NEI_SCC, c("year"="Year"))


#aggregate and plot
plot_3 <- subset(NEI_SCC, fips == "24510", c("Emissions", "Year","type"))
plot_3 <- melt(plot_3, id=c("Year", "type"), measure.vars=c("Emissions"))
plot_3 <- dcast(plot_3, Year + type ~ variable, sum)

ggplot(data=plot_3, aes(x=Year, y=Emissions, group=type, color=type)) + geom_line() + geom_point( size=4, shape=21, fill="white") + xlab("Year") + ylab("Emissions (tons)") + ggtitle("Baltimore PM2.5 Emissions by Type and Year")

ggsave(file="plot_3.png")

