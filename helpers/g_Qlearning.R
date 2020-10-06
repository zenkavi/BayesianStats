# Observation function
g_Qlearning = function(x, P){
  # IN:
  #    - x: Q-values (expected value for each action)
  #    - P: (1) inverse (log-) temperature 
  #         (2) bias
  #  OUT:
  #    - gx : P(y = 1|x)
  
  beta = exp(P[1])
  
  if(length(P)>1){
    const = P[2]
  } else{
    const = 0
  }
  
  dQ = x[2] - x[1]
  
  gx = VBA_sigmoid(beta * dQ + const)
  
  dgdx = c(-1, 1) * beta * gx * (1-gx)
  
  dgdp = rep(0, length(P))
  dgdp[1] = beta * dQ * gx * (1-gx)
  
  out = list('gx' = gx, 'dgdx' = dgdx, 'dgdp' = dgdp)
  
  return(out)
}