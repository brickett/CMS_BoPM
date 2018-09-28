# Regression for CMS Lease Cost
# Bryan Ricketts

# Import Packages
library(readxl)
library(dplyr)
library(magrittr)
library(broom)
library(tidyr)
library(plm)

#set directory to GitHub repo
setwd("C:/Users/bjr21/Documents/GitHub/CMS_BoPM")

# Load Data
df <- read_excel("CombinedDataFY14-18.xlsx")

# Rename Data
names(df)[3] <- "FiscalYear"
names(df)[10] <- "ParkSqFt"
names(df)[11] <- "TotSqFt"
names(df)[38] <- "TotCost"

# Split Square Footage
df$ParkSqFt[is.na(df$ParkSqFt)] <- 0
df$BuildSqFt <- df$BuildSqFt <- df$TotSqFt - df$ParkSqFt

# Convert Fiscal Year to Date
df$FiscalYear.Date <- as.Date(paste(df$FiscalYear, 1, 1, sep = "-"))

#subset
df_active <- subset(df, df$TotCost!= 0)
df_active <- df_active %>% drop_na(TotSqFt)

# Create Factor Variables
df_active$Region.f <- factor(df_active$Region)
df_active$SiteFull.f <- factor(df_active$SiteFull)
df_active$asbestosFlag <- not(is.na(df_active$`Asbestos Abatement`))

# Run analysis - Basic OLS
CostModel_OLS <- summary(lm(TotCost ~ BuildSqFt + ParkSqFt + FiscalYear.Date + Region.f + asbestosFlag, data = df_active ))

Tidy_CostModel_OLS <- tidy(CostModel_OLS)

# Capture Residuals
df_active_Clean <- df_active %>% drop_na(TotSqFt, Region.f, FiscalYear.Date, TotCost)
df_active_Clean$Residuals <- CostModel_OLS$OLSresiduals

#write to file
write.csv(df_active_Clean, "Maintenance_residuals.csv")
