#' Age-Specific Mortality Data by Country (1970-2010)
#'
#' Includes age-specific mortality rates, number of deaths, and death rates per 100,000 population,
#' categorized by country, year, age group, and sex. This dataset is sourced from the Global Burden of Disease (GBD) Study 2010.
#'
#' @format A tibble with 73,319 rows and 7 variables:
#' \describe{
#'   \item{Country Code}{a character string denoting ISO codes for countries (e.g., AFG, USA).}
#'   \item{Country Name}{a character string representing the full name of the country (e.g., Afghanistan, United States).}
#'   \item{Year}{an integer denoting the year of observation (1970 to 2010).}
#'   \item{Age Group}{a character string describing the specific age group (e.g., 0-6 days, 1-4 years).}
#'   \item{Sex}{a factor denoting gender (Male, Female, Both).}
#'   \item{Number of Deaths}{a character string representing the total deaths for the specified group (e.g., "31,840").}
#'   \item{Death Rate Per 100,000}{a numeric value showing the mortality rate per 100,000 population for the group.}
#' }
#'
#' @source {Institute for Health Metrics and Evaluation (IHME). 2010. Global Burden of Disease (GBD) Study 2010. Mortality age-specific data by country.}
#' \doi{10.1016/S0140-6736(10)61347-2}
"mortality"
