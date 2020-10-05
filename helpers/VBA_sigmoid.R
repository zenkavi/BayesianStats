# Simplified version
VBA_sigmoid = function(x, inverse=FALSE, center = 0, scale = 1, offset = 0, slope = 1){
  
  if(inverse){
    lx = scale * (1/(x - offset)) - 1
    y = center - (1/slope) * log (lx)
  } else{
    y = offset + scale * 1 / (1 + exp(- slope * (x - center)))
  }
  return(y)
}






