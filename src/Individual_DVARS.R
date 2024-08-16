# Load required libraries
library(readxl)
library(dplyr)
library(ggplot2)

setwd('~/Downloads/PhD/Analysis/Project_Uno/')

# Path to Excel file
file_path <- "ARB_QC.xlsx"

# Get sheet names
sheet_names <- excel_sheets(file_path)
sheet_names_proper <- c('1-echo baseline',
'1-echo + SDC',
'3-echo',
'3-echo + SDC',
'3-echo + T2s',
'3-echo + T2s + SDC',
'4-echo',
'4-echo + SDC',
'4-echo + T2s',
'4-echo + T2s + SDC',
'3-echo ME-ICA', 
'4-echo ME-ICA')

# Create an empty list to store data frames for each sheet
all_data <- list()

# Loop through each sheet
for (sheet_name in sheet_names) {
  # Read data from each sheet, including the first row
  data <- read_excel(file_path, sheet = sheet_name, col_names = FALSE)
  # Add a column for the sheet name
  data$Sheet_Name <- sheet_name
  # Remove the last column (which contains the sheet name)
  data <- data[, -ncol(data)]
  # Store data frame in the list
  all_data[[sheet_name]] <- data
}

# Calculate mean for each row in each sheet
means_list <- lapply(all_data, function(sheet_data) {
  apply(sheet_data, 2, mean)
})

# Convert means_list to a data frame
means_df <- do.call(rbind, lapply(seq_along(means_list), function(i) {
  sheet_name <- sheet_names_proper[i]
  data.frame(Sheet_Name = rep(sheet_name, length(means_list[[i]])),
             Participant = seq_along(means_list[[i]]),
             DVARS = means_list[[i]])
}))

# Plot
# Reorder the levels of Sheet_Name to match the order of the dataframe
means_df$Sheet_Name <- factor(means_df$Sheet_Name, levels = unique(means_df$Sheet_Name))

plot <- ggplot(means_df, aes(x = Sheet_Name, y = DVARS, color = factor(Participant))) +
  geom_boxplot() +
  geom_point(position = position_jitterdodge(jitter.width = 0.2, dodge.width = 0.75), size = 2) +  # Adjust jitter width and dodge width
  geom_line(aes(group = Participant), alpha = 0.5) +  # Add lines connecting points
  labs(x = "Pipeline", y = "DVARS", color = "Participant",
       title = "Individual DVARS Values Across Pipelines") +  # Add title
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels

# Print the plot
print(plot)
