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


# Evolution function
f_Qlearning = function(x, P, u){
  # - x: action values (n x 1)
  # - P: learning rate (will be sigmoid transformed)
  # - u: (1) previous action 
  #      (2) feedback received for previous action
  # u should be of shape matrix(data = c("choice", "feedback"), nrow=2, ncol = 1, byrow=T)
  # Note this is evaluated at a single time point. So e.g. u only has two values: the previous choice and the feedback for that time point only.
  alpha = VBA_sigmoid(P)
  
  prevActionIdx = u[1,1]+1
  feedback = u[2,1]
  
  fx = x
  
  delta = feedback - x[prevActionIdx]
  fx[prevActionIdx] = x[prevActionIdx] + alpha * delta
  
  n = length(x)
  
  dfdx = diag(n)
  dfdx[prevActionIdx, prevActionIdx] = 1-alpha
  
  dfdp = c(0, 0)
  dfdp[prevActionIdx] = alpha*(1-alpha)*delta
  
  return(fx, dfdx, dfdp)
}

# Observation function
g_Qlearning = function(x, P, u, idx){
  # IN:
  #    - x: Q-values
  #    - P: (1) inverse (log-) temperature 
  #         (2) bias
  #    - u: (idx(1)) index of 0 coded cue
  #         (idx(2)) index of 1 coded cue
  #    - in: 
  #        - idx: position of inputs indicating Q-values to use
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
  
  return(gx, dgdx, dgdp)
}
