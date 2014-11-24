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
plot_4 <- subset(NEI_SCC, grepl('Coal',NEI_SCC$Short.Name, fixed=TRUE), c("Emissions", "Year","type", "Short.Name"))
plot_4 <- aggregate(Emissions ~ Year, plot_4, sum)

ggplot(data=plot_4, aes(x=Year, y=Emissions)) + geom_line() + geom_point( size=4, shape=21, fill="white") + xlab("Year") + ylab("Emissions (thousands of tons)") + ggtitle("Total United States PM2.5 Coal Emissions")

ggsave(file="plot_4.png")
