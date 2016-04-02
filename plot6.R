# Load ggplot2 library
# Install it if user doesn't have library
if(!require(ggplot2)){
    print("The ggplot2 package is needed to run this script.");
    print("It will be installed automatically for you.");
    print("Installing ggplot2...");
            
    install.packages("ggplot2");
        
    if (!require(ggplot2)) {
        stop("Could not install ggplot2");
    }
}

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
    print("Reading data...");
    NEI <- readRDS("summarySCC_PM25.rds");
}

# Read SCC data if necessary
if (!exists("SCC")) {
    print("Reading data...");
    SCC <- readRDS("Source_Classification_Code.rds");
}

motorNEI <- NEI[NEI$type == "ON-ROAD" & (NEI$fips == "24510" | NEI$fips == "06037"),];

# Rename the columns (for legend)
motorNEI[motorNEI$fips == "24510",]$fips <- "Baltimore";
motorNEI[motorNEI$fips == "06037",]$fips <- "Los Angeles";

# Get the sum of emissions for motor vehicles
sumEmissions <- aggregate(Emissions ~ year + fips, motorNEI, sum);

# Create line plot
p <- ggplot(data = sumEmissions, aes(x = year, y = Emissions, col = fips)) + geom_line() +
    ggtitle("Emissions by Type in Baltimore and Los Angeles") + labs(x = "Year", y = "Emissions (tons)");

# Save plot
ggsave(filename = "plot6.png", plot = p);

# Cleanup
rm(motorNEI, sumEmissions, p);