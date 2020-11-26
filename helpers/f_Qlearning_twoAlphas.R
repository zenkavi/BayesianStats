# Evolution function
f_Qlearning = function(x, P, u){
  # - x: action values (n x 1)
  # - P: learning rates for pos and neg RPEs respectively (will be sigmoid transformed)
  # - u: (1) previous action 
  #      (2) feedback received for previous action
  # u should be of shape matrix(data = c("choice", "feedback"), nrow=2, ncol = 1, byrow=T)
  # Note this is evaluated at a single time point. So e.g. u only has two values: the previous choice and the feedback for that time point only.
  alpha_pos = VBA_sigmoid(P[1])
  alpha_neg = VBA_sigmoid(P[1])
  
  prevActionIdx = u[1]+1
  feedback = u[2]
  
  fx = x
  
  delta = feedback - x[prevActionIdx]
  
  #Learning differently from negative and positive RPEs
  if(delta >= 0){
    fx[prevActionIdx] = x[prevActionIdx] + alpha_pos * delta
  } else {
    fx[prevActionIdx] = x[prevActionIdx] + alpha_neg * delta
  }
  
  n = length(x)
  
  dfdx = diag(n)
  dfdx[prevActionIdx, prevActionIdx] = 1-alpha
  
  dfdp = c(0, 0)
  dfdp[prevActionIdx] = alpha*(1-alpha)*delta
  
  out = list('fx' = fx, 'dfdx' = dfdx, 'dfdp' = dfdp)
  
  return(out)
}