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

# Get the sum of emissions for each year
sumEmissions <- aggregate(Emissions ~ year, NEI, sum);

# Create new png file
png(filename = "plot1.png");

# Draw bar chart
barplot(sumEmissions$Emissions/10^6, names.arg = sumEmissions$year,
    main = "Total PM2.5 Emissions per Year", xlab = "Year", ylab = "Emissions (million tons)");
    
# Close the connections
dev.off();

# Cleanup
rm(sumEmissions);