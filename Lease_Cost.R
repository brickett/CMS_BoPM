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

# Clean Data
df <- df %>% drop_na(BldCode)
df <- subset(df, df$Zip != "XXXX" & df$Zip != "`")

df$NumPark <- as.double(df$NumPark)
df$SqFt <- as.double(df$SqFt)

# Create Dummy Variables
df$GAS[df$GAS != "L"] <- 0
df$GAS[df$GAS == "L"] <- 1
df$ELECTRICITY[df$ELECTRICITY != "L"] <- 0
df$ELECTRICITY[df$ELECTRICITY == "L"] <- 1
df$`WATER / SEWER`[df$`WATER / SEWER` != "L"] <- 0
df$`WATER / SEWER`[df$`WATER / SEWER` == "L"] <- 1
df$HVAC[df$HVAC != "L"] <- 0
df$HVAC[df$HVAC == "L"] <- 1
df$ELECTRIC[df$ELECTRIC != "L"] <- 0
df$ELECTRIC[df$ELECTRIC == "L"] <- 1
df$PLUMBING[df$PLUMBING != "L"] <- 0
df$PLUMBING[df$PLUMBING == "L"] <- 1
df$`FLUORESCENT LAMPS / BALLASTS`[df$`FLUORESCENT LAMPS / BALLASTS` != "L"] <- 0
df$`FLUORESCENT LAMPS / BALLASTS`[df$`FLUORESCENT LAMPS / BALLASTS` == "L"] <- 1
df$`JANITORIAL CLEANING`[df$`JANITORIAL CLEANING` != "L"] <- 0
df$`JANITORIAL CLEANING`[df$`JANITORIAL CLEANING` == "L"] <- 1
df$`WASTE DISPOSAL`[df$`WASTE DISPOSAL` != "L"] <- 0
df$`WASTE DISPOSAL`[df$`WASTE DISPOSAL` == "L"] <- 1
df$`PEST CONTROL`[df$`PEST CONTROL` != "L"] <- 0
df$`PEST CONTROL`[df$`PEST CONTROL` == "L"] <- 1
df$ELEVATOR[df$ELEVATOR != "L"] <- 0
df$ELEVATOR[df$ELEVATOR == "L"] <- 1
df$`FIRE EXTING INSPECTION & MAINT`[df$`FIRE EXTING INSPECTION & MAINT` != "L"] <- 0
df$`FIRE EXTING INSPECTION & MAINT`[df$`FIRE EXTING INSPECTION & MAINT` == "L"] <- 1
df$`SNOW REMOVAL`[df$`SNOW REMOVAL` != "L"] <- 0
df$`SNOW REMOVAL`[df$`SNOW REMOVAL` == "L"] <- 1
df$`LAWN CARE`[df$`LAWN CARE` != "L"] <- 0
df$`LAWN CARE`[df$`LAWN CARE` == "L"] <- 1
df$`SECURITY MAINTENANCE & MONITORING`[df$`SECURITY MAINTENANCE & MONITORING` != "L"] <- 0
df$`SECURITY MAINTENANCE & MONITORING`[df$`SECURITY MAINTENANCE & MONITORING` == "L"] <- 1
df$`LIFE SAFETY MAINTENANCE & MONITORING`[df$`LIFE SAFETY MAINTENANCE & MONITORING` != "L"] <- 0
df$`LIFE SAFETY MAINTENANCE & MONITORING`[df$`LIFE SAFETY MAINTENANCE & MONITORING` == "L"] <- 1
df$`MAT & TOWEL`[df$`MAT & TOWEL` != "L"] <- 0
df$`MAT & TOWEL`[df$`MAT & TOWEL` == "L"] <- 1
df$`SECURITY GUARDS`[df$`SECURITY GUARDS` != "Y"] <- 0
df$`SECURITY GUARDS`[df$`SECURITY GUARDS` == "Y"] <- 1

#rename
names(df)[12] <- "WaterSewer"
names(df)[16] <- "Lamps"
names(df)[17] <- "Janitor"
names(df)[18] <- "Waste"
names(df)[19] <- "Pest"
names(df)[21] <- "Fire"
names(df)[22] <- "Snow"
names(df)[23] <- "Lawn"
names(df)[24] <- "Security"
names(df)[25] <- "Safety"
names(df)[26] <- "Mat"
names(df)[27] <- "Guard"


df_active <- subset(df, df$UseCode!= "TERMINATED")
df_active <- subset(df_active, df_active$TotCost!= 0)

# Create Factor Variables
df_active$Zip.f <- factor(df_active$Zip)
df_active$UseCode.f <- factor(df_active$UseCode)

# Run analysis
CostModel <- summary(lm(TotCost ~ SqFt + NumPark + UseCode.f +
                          GAS + ELECTRICITY + WaterSewer + HVAC + ELECTRIC + PLUMBING + Lamps + Janitor + Waste + Pest + ELEVATOR +
                          Fire + Snow + Lawn + Security + Guard +
                          Zip.f, data = df_active ))

Tidy_CostModel <- tidy(CostModel)

df_active_Clean <- df_active %>% drop_na(SqFt, NumPark, UseCode.f, Zip.f, GAS, ELECTRICITY, WaterSewer, HVAC, ELECTRIC, PLUMBING, Lamps, Janitor, Waste, Pest, ELEVATOR, Fire, Snow, Lawn, Security, Guard)

df_active_Clean$Residuals <- CostModel$residuals

#write to file
write.csv(df_active_Clean, "residuals.csv")
