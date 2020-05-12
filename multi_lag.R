scripts = c("assert.R", "lagr.R", "check_dups.R")
sapply(scripts, source)


# create multiple lags for a single time series or within each panel. Does not require dplyr.
multi_lag = function(data, 
                     varname, 
                     nlags, 
                     t_index, 
                     spatunit=NULL, 
                     append=T,
                     afix = c("L", "."),
                     suffix = F,
                     sort = T,
                     check=T){
  
  stopifnot(!missing(data), !missing(varname), !missing(nlags), !missing(t_index))
  
  
  # convert tbl to dataframe for subsetting. 
  # Could use unname(unlist()) on cols for subsetting instead, but fn returns df anyway, so this conversion is less cumbersome
  if(any(c("tbl", "tbl_df") %in% class(data))){
    warning("Be aware: `data` input as class ", paste(class(data), collapse =", "), ", but output is data.frame only.", call.=F, immediate. = F)
    data=as.data.frame(data)
  }
  
  # argument checking
  assert(is.character(varname) && length(varname) == 1, 
         "`varname` must be a character string of length 1.")
  assert(all(nlags %% 1 == 0) && is.null(dim(nlags)),
         "`nlags` must be an integer valued scalar or vector.")
  assert(is.null(spatunit) ||
           length(spatunit) == 1 && is.character(spatunit), 
         "`spatunit` must be a length 1 character string, or NULL.")
  assert(is.character(t_index) && length(t_index) == 1,
         "`t_index` must be a length 1 character string.")
  assert(is.character(afix) && length(afix == 2),
         "`afix` must be a length 2 character vector.")
  
  panel = !is.null(spatunit)
  
  #Make sure users know they havent specified a grouping variable
  assert(panel, type="message", immediate = F,
         paste0("Argument `spatunit` not entered. Defaulting to single time series with time variable == ", t_index)
  )
  
  
  # set up data 
  if(length(nlags) > 1) lag_index = nlags else lag_index = seq_len(nlags)
  
  if(panel){
    if(check) check_dups(data, spatunit, t_index) else warning("Argument `check` set as FALSE...Not checking for duplicates.")
    if(sort) data = data[order(data[,spatunit], data[,t_index]),] else warning("Argument `sort` set as FALSE...Ensure your data are sorted.") #order data within panels
    data_tolag = data[,c(spatunit, varname)] # get panel indices
    data_split = split(data_tolag, data_tolag[, spatunit]) # split along spatial paneling variable
    data_split = lapply(data_split, "[[", varname) # subset the now split data, getting only the dependent variable. Returns list.
    
    # container for lags 
    lagged=list()
    
    # create nlags sequential lags of varname within panels.
    for(i in seq_along(lag_index)){
      lagged[[i]]=as.vector(sapply(data_split, lagr, laglen=lag_index[i])) #do.call(c, lapply(data_split, lagr, laglen=lag_index[i])) # unlist(lapply(data_split, lagr, laglen=lag_index[i])) 
      } 
    } else {
      
    if(check) check_dups(data, spatunit=NULL, t_index) else warning("Argument `check` set as FALSE...Not checking for duplicates.")
    if(sort) data = data[order(data[,t_index]),] else warning("Argument `sort` set as FALSE...Ensure your data are sorted.")
    lagged = lapply(lag_index, lagr, x=data[, varname])
  }
  
  lag_df = do.call(cbind.data.frame, lagged)
  
  if(!suffix){
    varnames = paste0(afix[1], lag_index, afix[2], varname)
  }  else varnames = paste0(varname, afix[1], afix[2], lag_index)
  
  colnames(lag_df) = varnames
  
  if(append) 
    return(cbind.data.frame(data, lag_df)) 
  else 
    return(lag_df)
}

