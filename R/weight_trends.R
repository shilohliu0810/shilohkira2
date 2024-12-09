#' Generate Weight Trends Plot by Groups
#'
#' This function generates a line plot of weight trends over time for different groups, optionally merging two datasets.
#'
#' @param dataset A data frame containing the main data, or the single dataset if no merging is needed.
#' @param bodyweight_data Optional. A data frame containing body weight data to merge with the main dataset. Required if `merge_needed = TRUE`.
#' @param id_col A string specifying the column name used to merge the datasets (e.g., "ID").
#' @param grouping_col A string specifying the column name for grouping (e.g., "Treatment").
#' @param weight_cols A character vector specifying the columns containing weight data (e.g., `c("Body Weight 1", "Body Weight 2")`).
#' @param time_points A character vector specifying labels for time points corresponding to the weight columns (e.g., `c("Week 1", "Week 2")`).
#' @param merge_needed Logical. Whether merging the main dataset and `bodyweight_data` is required. Defaults to `FALSE`.
#'
#' @details
#' The function performs the following steps:
#' 1. Optionally merges `dataset` and `bodyweight_data` if `merge_needed = TRUE`.
#' 2. Ensures the required columns are present in the dataset.
#' 3. Converts weight columns to numeric values.
#' 4. Reshapes the dataset into long format using `tidyr::pivot_longer`.
#' 5. Calculates the average weight for each group at each time point.
#' 6. Creates a `ggplot2` line plot showing the weight trends over time for each group.
#'
#' @return None. This function directly prints the generated plot.
#'
#' @export
#'
#' @examples
#' # Example datasets
#' main_data <- data.frame(
#'   ID = 1:6,
#'   Treatment = c("A", "A", "B", "B", "C", "C")
#' )
#' weight_data <- data.frame(
#'   ID = 1:6,
#'   "Body Weight 1" = c(70, 75, 80, 85, 90, 95),
#'   "Body Weight 2" = c(72, 77, 82, 87, 92, 97)
#' )
#'
#' # Generate weight trends plot with merging
#' weight_trends(
#'   dataset = main_data,
#'   bodyweight_data = weight_data,
#'   id_col = "ID",
#'   grouping_col = "Treatment",
#'   weight_cols = c("Body Weight 1", "Body Weight 2"),
#'   time_points = c("Week 1", "Week 2"),
#'   merge_needed = TRUE
#' )
weight_trends <- function(
    dataset,          # The single dataset OR birth_data if merging is needed
    bodyweight_data = NULL,  # The body weight dataset if merging is needed
    id_col,           # Column to merge datasets (e.g., "ID")
    grouping_col,     # Column for grouping average by what variable (e.g., "Treatment")
    weight_cols,      # Columns for body weight (e.g., "Body Weight 1", "Body Weight 2")
    time_points,      # Labels for time points (e.g., "Week 1", "Week 2")
    merge_needed = FALSE  # Boolean: Does merging need to happen?
) {
  # Step 1: Handle merging if needed
  if (merge_needed) {
    if (is.null(bodyweight_data)) {
      stop("If merging is required, bodyweight_data must be provided.")
    }

    # Merge the datasets
    merged_data <- merge(dataset, bodyweight_data, by = id_col)
  } else {
    # Use the provided dataset directly
    merged_data <- dataset
  }

  # Step 2: Check if the specified columns exist in the merged dataset
  required_cols <- c(id_col, grouping_col, weight_cols)
  if (!all(required_cols %in% names(merged_data))) {
    stop("One or more specified columns do not exist in the dataset.")
  }

  # Step 3: Ensure Body Weight columns are numeric
  for (col in weight_cols) {
    # Convert cleaned values to numeric
    merged_data[[col]] <- suppressWarnings(as.numeric(merged_data[[col]]))
  }

  # Step 4: Reshape the data
  long_data <- merged_data %>%
    select(all_of(c(grouping_col, weight_cols))) %>%
    pivot_longer(
      cols = all_of(weight_cols),
      names_to = "TimePoint",
      values_to = "Weight"
    ) %>%
    mutate(TimePoint = factor(TimePoint, levels = weight_cols, labels = time_points))

  # Step 5: Calculate average weights for groups at each time point
  plot_data <- long_data %>%
    group_by(TimePoint, .data[[grouping_col]]) %>%
    summarise(avg_weight = mean(Weight, na.rm = TRUE), .groups = "drop")

  # Step 6: Plot the data
  gg <- ggplot(plot_data, aes(x = TimePoint, y = avg_weight, group = .data[[grouping_col]], color = .data[[grouping_col]])) +
    geom_line(size = 1.2) +   # Connect the dots with lines
    geom_point(size = 3) +    # Add points
    labs(
      title = "Weight Trends Over Selected Time Points",
      x = "Time Point",
      y = "Average Weight",
      color = "Group"
    ) +
    theme_minimal()

  # Print the plot
  print(gg)
}
