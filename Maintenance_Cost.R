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
df <- read_excel("Leases.xlsx")

# Rename Data
names(df)[1] <- "BldCode"
names(df)[46] <- "Zip"
names(df)[49] <- "NumPark"
names(df)[50] <- "SqFt"
names(df)[62] <- "UseCode"
names(df)[77] <- "TotCost"
