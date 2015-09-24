# Use this script to process SAF files in POR format
# These files are found here:
# http://www.nyc.gov/html/nypd/html/analysis_and_planning/stop_question_and_frisk_report.shtml

library("foreign")
library("stringr")

# This'll take a while:
saf <- data.frame(read.spss("path_to_saf_data.por"))

# Alternatively, use:
# saf <- read.csv("path_to_saf_data.csv")

# Now slice out the fields we want:
safxprt <-
  saf[,
          c("PCT",
            "SER_NUM",
            "DATESTOP",
            "TIMESTOP",
            "SEX",
            "RACE",
            "AGE",
            "XCOORD",
            "YCOORD"
          )
    ]

# Trim leading/trailing spaces from dates
safxprt$DATESTOP <- sub("(^ +)|( +$)", "", as.character(safxprt$DATESTOP))

# Dates are in the format mmddyyyy, where leading 0s are dropped from the month.
safxprt$DATESTOP <- ifelse(str_length(safxprt$DATESTOP) == 8, safxprt$DATESTOP, paste("0", safxprt$DATESTOP, sep=""))

# Trim leading/trailing spaces from time and pad with a 0
safxprt$TIMESTOP <- str_pad(sub("(^ +)|( +$)", "", safxprt$TIMESTOP), 4, "left", "0")

# Convert to POSIX
safxprt$STAMP <- strptime(paste(safxprt$DATESTOP, safxprt$TIMESTOP), "%m%d%Y %H%M")

# Add minutes from start (timezone difference)
safxprt$MINUTE <- as.vector(difftime(as.POSIXct(safxprt$STAMP), ISOdate(2012,1,1,5,0,0), units = "mins"))

# Order by minutes:
safxprt <- safxprt[order(safxprt$MINUTE),]

# Write data to text file:
write.table(safxprt, file="data/saf.tsv", sep="\t", row.names=F)

unique(safxprt$RACE)
table(safxprt$RACE)
example <- head(safxprt, 100)
