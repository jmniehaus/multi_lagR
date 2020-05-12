# Multiple Time-Series or TSCS Lags of a Variable in R

> This repository includes R scripts that allow the user to create multiple lags of a variable contained in their dataframe in R. This can be done sequentially (e.g., all lags up to and including 3), or with broken lags (e.g., lags 1 and 3, but not 2). Moreover, the user can specify whether they want their original dataframe returned with the new variables appended, or a a new dataframe returned with only the new variables. 

> In addition to the above, users have the option to check for repeated observations within panels, alter the name of the new variable(s) they generate, and have the function sort their data prior to lagging it. 

> If you find inefficiencies or errors, please email me. 

## Function Arguments
- `data` -- A dataframe containing the data to be lagged, the time variable, and if panel lags are desired, a spatial/grouping variable.

- `varname` -- A length-one character string specifying the name of the variable to be lagged in the dataframe.

- `nlags` -- An integer valued scalar or vector specifying the desired lag length. 

- `t_index` -- A length-one character string specifying the name of the time variable in the dataframe. 

- `spatunit` -- A length-one character string specifying the name of the spatial/grouping variable in the dataframe. 

- `append` -- Logical indicating whether the resulting lags should be appended to the original data or returned alone. If `sort` is `TRUE` and append is `TRUE`, then the resulting lags are appended to the sorted data and returned that way. 

- `afix` -- A length-two character vector containing the characters that will be pre/appended to the lag number when naming the lag variables. Default is `c("L", ".")`, resulting in `L1.y` if `suffix` is `FALSE` and `varname`="y". 

- `suffix` -- Logical indicating whether the `afix` arguments should be placed in front of the lag number, or after it when naming.

- `sort` -- Logical indicating whether the data should be sorted by `t_index`, and `spatunit` if it is specified. Default is `TRUE`. 

- `check` -- Logical indicating whether the data should be checked for duplicate observations. If `spatunit` is not `NULL`, then duplicates are searched for within groups. This increases run time, particularly in large datasets. However, it is useful if lots of data merging has been done to ensure that the merges did not introduce duplicates. 

## Ancilarry (and required) Files

- `lagr.R` -- Custom function for lagging that does not rely on the `stats` or `dplyr` packages. 

- `assert.R` -- Omnibus argument checking function. 

- `check_dups.R` -- Function for checking for duplicates that supports panel data.

- `examples.R` -- A few examples, and benchmarking against other packages.


