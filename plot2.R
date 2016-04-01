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

# Baltimore emissions
baltNEI <- NEI[NEI$fips == "24510",];

# Get the sum of emissions for Baltimore
sumEmissions <- aggregate(Emissions ~ year, baltNEI, sum);

# Create new png file
png(filename = "plot2.png");

# Draw bar chart
barplot(sumEmissions$Emissions, names.arg = sumEmissions$year,
    main = "PM2.5 Emissions per Year in Baltimore", xlab = "Year", ylab = "Emissions (tons)");
    
# Close the connections
dev.off();

# Cleanup
rm(sumEmissions, baltNEI);