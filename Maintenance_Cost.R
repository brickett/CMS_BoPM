# Regression for CMS Lease Cost
# Bryan Ricketts

# Import Packages
library(readxl)
library(ggplot2)
library(dplyr)
library(magrittr)
library(broom)
library(tidyr)

#set directory to GitHub repo
setwd("C:/Users/bjr21/Documents/GitHub/CMS_BoPM")

# Load Data
df <- read_excel("CombinedDataFY14-18.xlsx")

# Rename Data
names(df)[3] <- "FiscalYear"
names(df)[10] <- "SqFt"
names(df)[37] <- "TotCost"

#subset
df_active <- subset(df, df$TotCost!= 0)

# Create Factor Variables
df_active$Region.f <- factor(df_active$Region)

# Run analysis
CostModel <- summary(lm(TotCost ~ SqFt + Region.f + FiscalYear, data = df_active ))

Tidy_CostModel <- tidy(CostModel)

# Capture Residuals
df_active_Clean <- df_active %>% drop_na(SqFt, Region.f, FiscalYear, TotCost)
                                         
df_active_Clean$Residuals <- CostModel$residuals

#write to file
write.csv(df_active_Clean, "Maintenance_residuals.csv")
