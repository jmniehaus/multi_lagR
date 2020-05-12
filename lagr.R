# create lag of length laglen. Advantage is absence of dplyr
lagr = function(x, laglen){
  assert(is.null(dim(x)) && is.atomic(x) && laglen %% 1 == 0, call = T,
         "`x` must be a vector and `laglen` must be an integer value.")
  
  if(laglen == 0) return(x)
  nobs = length(x)
  
  
  if(nobs <= laglen){
    lagged = rep(NA, times=nobs)
  } else {
    lagged = c(rep(NA, laglen), head(x, nobs-laglen))
  }
  
  return(lagged)
}