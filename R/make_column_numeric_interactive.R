#' Interactively Convert a Column to Numeric
#'
#' This function converts a specified column in a dataset to numeric by removing non-numeric characters and interactively resolving remaining non-numeric values.
#' @param data A data frame containing the column to be converted.
#' @param column_name A string specifying the name of the column to convert to numeric.
#'
#' @details
#' The function performs the following steps:
#' 1. Removes non-numeric characters from the column.
#' 2. Attempts to convert the column to numeric, identifying rows where conversion fails.
#' 3. For rows with non-numeric values, the user is prompted interactively to provide a numeric replacement or set the value to `NA`.
#'
#' Non-numeric rows are processed interactively:
#' - Leave the input blank to set the value to `NA`.
#' - Enter a valid numeric value to replace the non-numeric value.
#' - Invalid inputs prompt the user to try again.
#'
#' @return A data frame with the specified column converted to numeric.
#' @export
#'
#' @examples
#' # Example dataset
#' df <- data.frame(
#'   ID = 1:5,
#'   Value = c("10", "20.5", "Thirty", "40$", "50kg")
#' )
#'
#' # Interactively convert the "Value" column to numeric
#' updated_df <- make_column_numeric_interactive(df, "Value")
make_column_numeric_interactive <- function(data, column_name) {
  # Check if the column exists
  if (!column_name %in% names(data)) {
    stop("The specified column does not exist in the dataset.")
  }

  # Extract and clean the column
  column <- gsub("[^0-9.]", "", data[[column_name]])  # Remove non-numeric characters
  suppressWarnings({
    numeric_column <- as.numeric(column)
  })

  # Identify non-numeric values
  non_numeric_rows <- which(is.na(numeric_column) & !is.na(data[[column_name]]))

  # If no non-numeric values, return the original column converted to numeric
  if (length(non_numeric_rows) == 0) {
    cat("No non-numeric values found in the column.\n")
    data[[column_name]] <- numeric_column
    return(data)
  }

  # Interactive resolution for non-numeric values
  cat("The following non-numeric values were found in the column:", column_name, "\n")
  for (i in non_numeric_rows) {
    cat("Row", i, ": Current value =", data[[column_name]][i], "\n")
    user_input <- readline(prompt = "Enter a numeric value to replace this, or leave blank to set it to NA: ")

    if (user_input == "") {
      numeric_column[i] <- NA  # Replace with NA
      cat("Value set to NA.\n")
    } else if (!is.na(as.numeric(user_input))) {
      numeric_column[i] <- as.numeric(user_input)  # Replace with user-provided value
      cat("Value updated to:", user_input, "\n")
    } else {
      cat("Invalid input. Value remains non-numeric. Please try again.\n")
    }
  }

  # Replace the column in the dataset with the corrected numeric column
  data[[column_name]] <- numeric_column

  # Return the updated dataset
  return(data)
}
