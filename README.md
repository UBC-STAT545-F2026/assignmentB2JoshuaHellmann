
<!-- README.md is generated from README.Rmd. Please edit that file -->

# fastmean

This is an R package that includes a function called
`num_mean_categorical`.

The goal of fastmean is to allow a fast way to calculate the mean of one
or more numeric variables for each level of a categorical variable using
`num_mean_categorical`.

## Installation

Package installation can be done directly by calling:
`devtools::install_github("UBC-STAT545-F2026/assignmentB2JoshuaHellmann", ref = "0.1.0")`

## Example

This is a basic example which shows you how to use
`num_mean_categorical` with the `penguins` dataset from the
`palmerpenguins` package. It calculates the mean flipper and bill length
for each island:

``` r
library(fastmean)
library(palmerpenguins)
#> 
#> Attaching package: 'palmerpenguins'
#> The following objects are masked from 'package:datasets':
#> 
#>     penguins, penguins_raw

num_mean_categorical(palmerpenguins::penguins, island, flipper_length_mm, bill_length_mm, removenas = TRUE)
#> # A tibble: 3 × 3
#>   island    mean_flipper_length_mm mean_bill_length_mm
#>   <fct>                      <dbl>               <dbl>
#> 1 Biscoe                      210.                45.3
#> 2 Dream                       193.                44.2
#> 3 Torgersen                   191.                39.0
```
