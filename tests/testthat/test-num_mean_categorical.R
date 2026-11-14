# Test 1
# Data input is a vector and not a dataframe should result in an error message
test_that("Providing wrong input for the dataframe results in an error", {
  a <- c(A = 1, B = 2, C = 3) #define arbitrary vector
  expect_error(num_mean_categorical(a, B, C, removenas = TRUE), regexp = "`df` input invalid. `df` has to be a dataframe or tibble.")
})

# Test 2
# Providing categorical variable for the numeric input should result in an error message
test_that("Providing a categorical input for a numeric variable results in an error", {
  expect_error(num_mean_categorical(palmerpenguins::penguins, island, species, removenas = TRUE), regexp = "All `...` inputs have to be numeric columns!")
})

# Test 3
# Providing no numeric input should result in an error message
test_that("Providing no numeric input for the ellipses should result in an error", {
  expect_error(num_mean_categorical(palmerpenguins::penguins, island, removenas = TRUE), regexp = "No numeric columns were provided.")
})

# Test 4
# Running the test on a test dataset and check if results are equal to alternative approach
test_that("The function actually calculates the mean", {

  # Check if the function actually calculates the mean
  # Creating a small tibble first
  test_tibble <- dplyr::tibble(
    student = c("A", "A", "B", "B"),
    grade = c(80, 75, 92, 83)
  )

  # calculate mean using base R (https://www.statology.org/r-mean-by-group/)
  mean_test_tibble <- aggregate(test_tibble$grade, list(test_tibble$student), FUN=mean)

  # extract mean of both students and save as variable
  mean_test_tibble_grades <- mean_test_tibble[,2]

  # run function and extract mean values of both students and save as variable
  mean_function <- num_mean_categorical(test_tibble, student, grade, removenas = TRUE)
  mean_function_grades <- dplyr::pull(mean_function, var = 2)

  expect_equal(mean_test_tibble_grades, mean_function_grades)
})
