
<!-- README.md is generated from README.Rmd. Please edit that file -->

# shilohkira

<!-- badges: start -->
<!-- badges: end -->

shilohkira is a package that makes data fun and easy! The goal of
shilohkira is to help you more efficiently work with any data of your
choice, as well as introduce you to a mortality dataset recording the
death rates across country and other demographics including age and
gender.

With this package, you would be able to interactively work with R
console prompts to filter through and change different values across a
column, as well as to fix non-numeric values to any user inputs and
decisions of your choice. While it’s all up to your discretion, our
package helps you streamline the process.

In addition, our package helps you visualize your data. We help you make
a scatterplot graphing changes over time for different treatment groups,
and another chart plotting changes in weight over time for each sample
you have in the dataset. We also generate a summary statistics table one
for your data so you can get a sense of how your samples change over
time in numerical format as well.

## Installation

You can install the development version of shilohkira like so:

If you were running the folder on your computer locally, open up the
shilohkira folder and run the code
`devtools::install()' since this function essentially replaces the`install.packages(“shilohkira”)’
function. Then you can run \`library(shilohkira)’ as usual and you would
be able to use all the different functions in our package!

We also pushed our package onto GitHub, so you would also be able to
install the pacakge from GitHub by running
\`devtools::install_github(“shilohliu0810/shilohkira2”)’.

## Data

We are also introducing you to the [mortality
dataset](https://ghdx.healthdata.org/record/ihme-data/gbd-2010-mortality-results-1970-2010)
in our package. This dataset contains data of mortality by age and sex
across countries over time from 1970-2010, for 187 countries in the
world. This is an important dataset to explore if you want to see how
mortality and death rates, whether as a result as crime, health, or
other factors, vary across countries considering the regions that they
are located and the socioeconomic characteristics comparisons.

It is especially useful to apply our functions to this dataset for
cleaning purposes, and making columns numeric or renaming deviant values
are also functions that are generalizable across all types of data
cleaning. As for plotting purposes, since the mortality dataset is
consisted of two different genders, as with the idea of having a placebo
and treatment group for our sample mouse dataset, we are also able to be
useful in helping you plot differences across these two genders in terms
of mortality rate or death rate trends over time. The time series
component of this dataset also makes it applicable to our package
because we are able to help you plot different countries all on the same
graph for displaying changes over time.

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(shilohkira)
```

``` r
## basic example code
install.packages("readxl")
#> Installing package into '/private/var/folders/bl/ty38nsqs4334ccr2xpygp5mr0000gp/T/RtmprB6ryM/temp_libpath34e24b1c3e0c'
#> (as 'lib' is unspecified)
#> 
#> The downloaded binary packages are in
#>  /var/folders/bl/ty38nsqs4334ccr2xpygp5mr0000gp/T//RtmpmLo0kD/downloaded_packages
library(readxl)
library(tidyverse)
#> ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
#> ✔ dplyr     1.1.4     ✔ readr     2.1.5
#> ✔ forcats   1.0.0     ✔ stringr   1.5.1
#> ✔ ggplot2   3.5.1     ✔ tibble    3.2.1
#> ✔ lubridate 1.9.3     ✔ tidyr     1.3.1
#> ✔ purrr     1.0.2
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
setwd("/Users/shilohliu/Dropbox/shilohkira2")
sheet_names <- excel_sheets("data-raw/mousedata.xlsx")
all_sheets <- lapply(sheet_names, function(sheet) {
  read_excel("/Users/shilohliu/Dropbox/shilohkira2/data-raw/mousedata.xlsx", sheet = sheet)
})
#> New names:
#> • `Date Body Weight 2` -> `Date Body Weight 2...5`
#> • `Date Body Weight 2` -> `Date Body Weight 2...7`
names(all_sheets) <- sheet_names
Birth <- all_sheets[[1]]    
Bodyweight <- all_sheets[[2]] 
Outcome <- all_sheets[[3]]  

newBirth <- check_and_rename_levels(Birth, "Treatment")
#> [1] "Unique values in the column:"
#> [1] "Plac"    "Placobo" "Tmt"     "Trmt"   
#> Enter the new name for each value. Press Enter if you want to keep the original:
#> Current value: Plac --> 
#> Current value: Placobo --> 
#> Current value: Tmt --> 
#> Current value: Trmt --> 
#> [1] "Renaming complete."
Bodyweight2 <- make_column_numeric_interactive(Bodyweight, "Body Weight 2")
#> No non-numeric values found in the column.
Bodyweight <- make_column_numeric_interactive(Bodyweight, "Body Weight 3")
#> The following non-numeric values were found in the column: Body Weight 3 
#> Row 31 : Current value = Dead 
#> Enter a numeric value to replace this, or leave blank to set it to NA: 
#> Value set to NA.
Bodyweight <- make_column_numeric_interactive(Bodyweight, "Body Weight 1")
#> No non-numeric values found in the column.
weight_trends(
  dataset = newBirth,
  bodyweight_data = Bodyweight2,
  id_col = "ID",
  grouping_col = "Treatment",
  weight_cols = c("Body Weight 1", "Body Weight 2", "Body Weight 3"),
  time_points = c("Week 1", "Week 2", "Week 3"),
  merge_needed = TRUE
)
```

<img src="man/figures/README-example-1.png" width="100%" />

``` r
summary_stats <- summary_table(
  dataset = newBirth,
  bodyweight_data = Bodyweight,
  id_col = "ID",
  grouping_col = "Treatment",
  weight_cols = c("Body Weight 1", "Body Weight 2", "Body Weight 3"),
  time_points = c("Week 1", "Week 2", "Week 3"),
  merge_needed = TRUE
)
print(summary_stats)
#> # A tibble: 12 × 6
#>    TimePoint Treatment  Mean Median StdDev Count
#>    <fct>     <chr>     <dbl>  <dbl>  <dbl> <int>
#>  1 Week 1    Plac       22.4   22.3   1.92    14
#>  2 Week 1    Placobo    24.5   24.5  NA        1
#>  3 Week 1    Tmt        21.6   20.7   3.82    14
#>  4 Week 1    Trmt       22.3   22.3  NA        1
#>  5 Week 2    Plac       22.4   22.3   1.93    14
#>  6 Week 2    Placobo    24.6   24.6  NA        1
#>  7 Week 2    Tmt        20.7   20.5   2.68    14
#>  8 Week 2    Trmt       22.2   22.2  NA        1
#>  9 Week 3    Plac       22.5   22.6   1.90    14
#> 10 Week 3    Placobo    24.7   24.7  NA        1
#> 11 Week 3    Tmt        20.7   20.6   2.95    13
#> 12 Week 3    Trmt       22.2   22.2  NA        1
```
