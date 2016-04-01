# Download data if necessary
if (!file.exists("summarySCC_PM25.rds") || !file.exists("Source_Classification_Code.rds")) {
    print("Downloading data...");
    fileUrl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip";
    download.file(fileUrl, destfile = "Emissions.zip", mode = "wb");
    unzip("Emissions.zip");
    file.remove("Emissions.zip");
    rm(fileUrl);
}

# Read NEI data if necessary
if (!exists("NEI")) {
    print("Reading NEI data...");
    NEI <- readRDS("summarySCC_PM25.rds");
}

# Read SCC data if necessary
if (!exists("SCC")) {
    print("Reading SCC data...");
    SCC <- readRDS("Source_Classification_Code.rds");
}

# Find rows in SCC with "Coal" in Short.Name
coalMatches <- grepl("Coal", SCC$Short.Name, ignore.case = TRUE);
coalIndexes <- SCC[coalMatches,]$SCC;
coalNEI <- NEI[NEI$SCC %in% coalIndexes,];

# Get the sum of emissions for coal
sumEmissions <- aggregate(Emissions ~ year, coalNEI, sum);

# Create new png file
png(filename = "plot4.png");

# Draw bar chart
barplot(sumEmissions$Emissions/10^6, names.arg = sumEmissions$year,
    main = "PM2.5 Emissions per Year from Coal Sources", xlab = "Year", ylab = "Emissions (million tons)");
    
# Close the connections
dev.off();

# Cleanup
rm(sumEmissions, coalMatches, coalIndexes, coalNEI);