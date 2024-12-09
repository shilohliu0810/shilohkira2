install.packages("tidyverse")
install.packages("ggplot2")
install.packages("readxl")
install.packages("dplyr")
install.packages("tidyr")
install.packages("plotly")
library(tidyr)
library(dplyr)
library(readxl)
library(tidyverse)
library(ggplot2)
library(plotly)

#' Check and Rename Levels of a Column
#' This function allows you to interactively rename the unique values (levels) in a specified column of a dataset.
#' @param data A data frame that contains the column to be modified.
#' @param col_name A string specifying the name of the column whose levels you want to rename.
#'
#' @details
#' The function checks whether the specified column exists in the provided dataset.
#' It prints the unique values in the column and prompts the user to rename each value interactively.
#' If the user presses Enter without inputting a new name, the original value is retained.
#'
#' @return A data frame with the renamed levels in the specified column.
#' @export
#'
#' @examples
#' # Example dataset
#' df <- data.frame(
#'   Category = c("A", "B", "A", "C"),
#'   Value = c(1, 2, 3, 4)
#' )
#' # Interactively rename levels in the "Category" column
#' updated_df <- check_and_rename_levels(df, "Category")
#'
check_and_rename_levels <- function(data, col_name) {
  # Check if the column exists
  if (!col_name %in% names(data)) {
    stop("The specified column does not exist in the dataset.")
  }

  # Get unique values (levels) in the column
  unique_values <- unique(data[[col_name]])
  print("Unique values in the column:")
  print(unique_values)

  # Ask user for corrections
  corrected_values <- unique_values
  cat("Enter the new name for each value. Press Enter if you want to keep the original:\n")
  for (i in seq_along(unique_values)) {
    cat("Current value:", unique_values[i], "--> ")
    user_input <- readline()  # Get user input
    if (nchar(user_input) > 0) {
      corrected_values[i] <- user_input  # Update with user input
    }
  }

  # Replace the values in the column
  correction_map <- setNames(corrected_values, unique_values)  # Map old to new
  data[[col_name]] <- correction_map[data[[col_name]]]

  # Print confirmation
  print("Renaming complete.")

  # Return the updated dataset
  return(data)
}
