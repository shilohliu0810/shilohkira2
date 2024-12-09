#' Create an Interactive Weight Trends Plot
#' This function generates an interactive scatter plot with line connections to visualize weight trends over time for each individual in a dataset.
#'
#' @param bodyweight_data A data frame containing weight data, including individual IDs and body weights at multiple time points.
#' @param id_col A string specifying the name of the column containing individual IDs (e.g., "ID").
#' @param weight_cols A character vector specifying the names of the columns containing weight measurements (e.g., `c("Weight_1", "Weight_2")`).
#' @param time_points A character vector specifying the labels for the time points corresponding to the weight columns (e.g., `c("Week 1", "Week 2")`).
#'
#' @details
#' This function performs the following steps:
#' 1. Checks if the specified columns exist in the provided dataset.
#' 2. Reshapes the dataset from wide format to long format using `tidyr::pivot_longer`.
#' 3. Creates an interactive plotly scatter plot with lines connecting weight trends for each individual over time.
#'
#' The plot includes interactive tooltips showing the ID, weight, and time point for each data point.
#'
#' @return None. This function directly prints an interactive plot created with `plotly`.
#' @export
#'
#' @examples
#' # Example dataset
#' df <- data.frame(
#'   ID = c(1, 2, 3),
#'   "Body Weight 1" = c(70, 80, 60),
#'   "Body Weight 2" = c(72, 82, 62),
#'   "Body Weight 3" = c(74, 84, 64)
#' )
#'
#' # Create an interactive weight trends plot
#' wrongnum(
#'   bodyweight_data = df,
#'   id_col = "ID",
#'   weight_cols = c("Body Weight 1", "Body Weight 2", "Body Weight 3"),
#'   time_points = c("Week 1", "Week 2", "Week 3")
#' )
wrongnum <- function(
    bodyweight_data,  # Dataset with body weights
    id_col,           # Column for ID (e.g., "ID")
    weight_cols,      # Columns for weights (e.g., "Body Weight 1", "Body Weight 2")
    time_points       # Labels for time points (e.g., "Week 1", "Week 2", "Week 3")
) {
  # Step 1: Check that the specified columns exist
  missing_cols <- setdiff(c(id_col, weight_cols), names(bodyweight_data))
  if (length(missing_cols) > 0) {
    stop(paste("The following columns are missing in the dataset:", paste(missing_cols, collapse = ", ")))
  }

  # Step 2: Reshape data into long format
  long_data <- bodyweight_data %>%
    pivot_longer(
      cols = all_of(weight_cols),
      names_to = "TimePoint",
      values_to = "Weight"
    ) %>%
    mutate(
      TimePoint = factor(TimePoint, levels = weight_cols, labels = time_points)  # Relabel time points
    )

  # Step 3: Create an interactive scatter plot with line connections
  p <- plot_ly(
    data = long_data,
    x = ~TimePoint,
    y = ~Weight,
    color = ~get(id_col),  # Color each line by ID
    text = ~paste("ID:", get(id_col), "<br>Weight:", Weight, "<br>Time Point:", TimePoint),
    type = "scatter",
    mode = "lines+markers"  # Add both lines and points
  ) %>%
    layout(
      title = "Weight Trends Per ID",
      xaxis = list(title = "Time Point"),
      yaxis = list(title = "Weight"),
      legend = list(title = list(text = "ID"))
    )

  # Print the plot
  print(p)
}
