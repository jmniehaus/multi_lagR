`%!in%` = Negate(`%in%`)

assert = function(cond, expr, call = F, immediate = F, type="error"){
  if(length(type) != 1 || !is.character(type) || type %!in% c("error", "warning", "message")){
    stop("Argument `type` must be a length 1 string from c(\"error\", \"warning\", \"message\")")
  }
  
  if(!cond){
    switch(type, 
           "error" = stop(expr, call. = call),
           "warning" = warning(expr, call. = call, immediate. = immediate),
           "message" = message(expr, appendLF=T)
    ) 
  }
  
} 
