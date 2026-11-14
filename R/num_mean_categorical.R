#' @title Calculate Numeric Mean of Categorical Levels
#'
#' @description
#' Selects one categorical (or numeric variable) and one or multiple numeric columns
#' of data in a dataframe or tibble format. It mutates the categorical variable to a factor
#' (to account for "numeric categorical variables" such as year).
#' It then groups by the factorized categorical variable and calculates the mean
#' of the numeric variable(s) for each level of the categorical variable.
#'
#' @param df dataframe. Data in dataframe or tibble format
#' @param cat categorical or numeric column (numeric column will be factorized) with different
#' levels
#' @param ... numeric column, input of mutliple numeric columns for which the mean will be calculated
#' for every level of `cat`
#' @param removenas logical value, set `TRUE` for removing NAs, set `FALSE` for keeping NAs
#'
#' @returns mean_values. Dataframe or tibble with mean values for each categorical level
#' @examples
#' num_mean_categorical(palmerpenguins::penguins, island, flipper_length_mm,
#' bill_length_mm, removenas = TRUE)
#' num_mean_categorical(palmerpenguins::penguins, year,
#' bill_length_mm, removenas = TRUE)
#' num_mean_categorical(palmerpenguins::penguins, species,
#' bill_depth_mm, body_mass_g, removenas = FALSE)
#'
#' @importFrom rlang :=
#'
#' @export
#'
# start of the function
num_mean_categorical <- function(df, cat, ..., removenas = TRUE){

  # checking for correct input of dataframe
  if(!is.data.frame(df)){
    stop("`df` input invalid. `df` has to be a dataframe or tibble.")
  }
  #https://www.geeksforgeeks.org/r-language/check-if-the-object-is-a-data-frame-in-r-programming-is-data-frame-function/

  # creating variables for additional sanity checks
  cat_values <- df |>
    dplyr::pull({{cat}}) # extracting the category column from df
  num_values <- df |>
    dplyr::select(...) # extracting the numeric columns into a variable

  # give a warning if categorical value is numeric
  if(!is.factor(cat_values) && !is.character(cat_values)){
    warning("`cat` input is numeric! Numeric value will be converted to factor. If this was intentional (e.g. year as variable) continue!")
  } # looked up different messages for warning message in https://www.coddykit.com/courses/learn_r/errors-warnings-and-messages-in-r-5130747

  # check that numeric input actually is numeric
  if(!all(sapply(num_values, is.numeric))){ #using sapply applies function is.numeric to all num_values columns
    # all checks if all outputs of sapply are TRUE
    stop("All `...` inputs have to be numeric columns!")
  }
  # stop function if one of the provided `...` columns are not numeric

  # check if data for numeric columns was provided
  if(ncol(num_values) == 0){ #if number of columns in num_values is zero -> error message
    stop("No numeric columns were provided.")
  }

  # core function uses dplyr functions to select, group, and calculate mean
  mean_values <- df |> # chooses dataframe of interest and pipes it into functions below
    dplyr::select({{cat}}, ...) |> # selects categorical variable and all numeric variables of interest
    dplyr::mutate({{cat}} := factor({{cat}})) |> # conversion of `cat`to factor (if input was numeric)
    dplyr::group_by({{cat}}) |> # groups by categorical variable
    dplyr::summarise(dplyr::across(c(...), \(x) mean(x, na.rm = removenas), .names = "mean_{.col}"))
  # calculates mean of numeric variable for the categorical group and names column mean_'columnname'
  # removes NAs based on logical value in removenas
  # looked up summarise across in: https://dplyr.tidyverse.org/reference/across.html

  return(mean_values)
}
