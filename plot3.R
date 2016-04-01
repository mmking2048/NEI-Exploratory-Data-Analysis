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
    print("Reading NEI data...");
    NEI <- readRDS("summarySCC_PM25.rds");
}

# Baltimore emissions
baltNEI <- NEI[NEI$fips == "24510",];

# Get the sum of emissions by year and by type
sumEmissions <- aggregate(Emissions ~ year + type, baltNEI, sum);

# Create line chart
p <- ggplot(data = sumEmissions, aes(x = year, y = Emissions, col = type)) + geom_line() +
    ggtitle("Emissions by Type in Baltimore") + labs(x = "Year", y = "Emissions (tons)");
    
# Save chart to file
ggsave(filename = "plot3.png", plot = p);
    
# Cleanup
rm(sumEmissions, p, baltNEI);