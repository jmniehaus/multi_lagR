scripts = c("multi_lag.R")
sapply(scripts, source)


#Examples
t = 100000
n = 26
space = rep(letters[1:n],  each=t)
df = cbind.data.frame(y=rnorm(n*t), x=rnorm(n*t), space, ti = rep(1:t, n))

df_scramb = df[sample(nrow(df)),] # scramble the dataset for sorting

newdf_check_brokelag = multi_lag(df_scramb,
                                 "y",
                                 spatunit = "space",
                                 t_index = "ti",
                                 nlags=c(1,3),
                                 afix = c("L", "."),
                                 suffix = F,
                                 check=T,
                                 sort=T)

newdf_nocheck_seqlag = multi_lag(df_scramb, 
                                 "y", 
                                 spatunit = "space", 
                                 t_index = "ti", 
                                 nlags=2, 
                                 afix = c("L", "."), 
                                 suffix = F, 
                                 check=F)

newdf_changed_afix = multi_lag(df_scramb, 
                               "y", 
                               spatunit = "space", 
                               t_index = "ti", 
                               nlags=c(1,3), 
                               afix = c(".L", ""), 
                               suffix = T, 
                               check=F)



# Uncomment to compare speeds with dplyr, slide
# sapply(c("DataCombine", "dplyr"), library, character.only=T)
# stats = microbenchmark(mult = {multi_lag(df, "y", spatunit = "space", t_index = "ti", nlags=c(1,3), afix = c("lag_", "."), suffix = F, check=F, sort=F) }, 
#                      dp = { df %>% group_by(space) %>% mutate(lag1 = lag(y, 1, order_by=ti), lag3=lag(y, 3, order_by=ti)) },
#                      sli = { suppressWarnings(slide(df, "y", TimeVar = "ti", GroupVar = "space", NewVar= "lag3", slideBy = -3, reminder=F)) },
#                      times = 100, unit = "s")


 