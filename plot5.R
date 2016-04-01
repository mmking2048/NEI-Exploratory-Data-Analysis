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

motorNEI <- NEI[NEI$type == "ON-ROAD" & NEI$fips == "24510",];

# Get the sum of emissions for motor vehicles
sumEmissions <- aggregate(Emissions ~ year, motorNEI, sum);

# Create new png file
png(filename = "plot5.png");

# Draw bar chart
barplot(sumEmissions$Emissions, names.arg = sumEmissions$year,
    main = "PM2.5 Emissions from Motor Vehicles in Baltimore", xlab = "Year", ylab = "Emissions (tons)");
    
# Close the connections
dev.off();

# Cleanup
rm(sumEmissions, motorNEI);