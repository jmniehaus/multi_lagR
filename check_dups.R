# check for repeated observations within time-series or panels
check_dups = function(data, spatunit=NULL, t_index){
  
  assert(is.null(spatunit) ||
           length(spatunit) == 1 && is.character(spatunit),
         "`spatunit` must be a length 1 character string, or NULL.")
  assert(is.character(t_index) && length(t_index) == 1,
         "`t_index` must be a length 1 character string.")
  
  
  panel = !is.null(spatunit)
  
  if(!panel){
    
    dups = duplicated(data[, t_index])
    
  } else { 
    
    to_check = paste(data[, spatunit], data[, t_index], sep="_") # paste together columns of time and space. Eg, time=1, space=a, result=1a
    dups = duplicated(to_check) # check if duplicates in pasted time-space. Returns logical.
    
  }
  
  ndups = sum(dups)
  
  assert(ndups == 0,
         paste("Repeated observations within panels or time-series detected at following row numbers:\n\n",
               paste(which(dups), collapse=", ")
         )
  )
  
  
}