zeros = function(dim1, dim2=1){
  if(dim2 != 1){
    out = matrix(0, nrow=dim1, ncol=dim2)
  } else {
    out = rep(0, dim1*dim2)
  }
  return(out)
}

VBA_simulate = function(n_t, f_fname, g_fname, theta, phi, u, alp, sigma, x0, fb){
  
# This function creates the time series of hidden-states and measurements
# under the following nonlinear state-space model:
#    x_t = f(x_t-1,Theta,u_t) + f_t
#    y_t = g(x_t,Phi,u_t) + e_t
  
#   IN:
#        - n_t: the number of time bins for the time series of hidden-states and
#      observations, i.e. the time indices satisfy: 1<= t < n_t
#      - f_fname/g_fname: evolution/observation function names.
#      - theta/phi: evolution/observation parameters values.
#      - u: the mxt input matrix
#      - alpha: precision of the stochastic innovations
#      - sigma: precision of the measurement error
#      - options: structure variable containing the following fields:
#           .inF
#          .inG
#      - x0: the initial conditions
#      - fb: an optional feedback struture that contains the following fields:
#            .h_fname: the name/handle of the function that implements the
#          feedback mapping, i.e. that maps the system's output y_t to its
#        feedback h(y_t,t,inH) 
#        .inH: an optional entry structure for the feedback mapping
#        .indy: the vector of indices that are used to address the previous
#        system output (y_t-1) within the current input (u_t)
#        .indfb: the vector of indices that are used to address the feedback
#        h(y_t-1,t-1,inH) to the previous system output within the current
#        input (u_t) 
#  OUT:
#    - y: the pxt (noisy) measurement time series
#    - x: the nxt (noisy) hidden-states time series
#    - x0: the nx1 initial conditions
#    - eta: the nxt stochastic innovations time series
#    - e: the pxt measurement errors (e:=y-<y>)
  
  f_fun = get(f_fname)
  g_fun = get(g_fname)

  n = length(x0)
  
  dim = list('n_theta' = length(theta),
             'n_phi' = length(phi),
             'n' = n,
             'n_t' = n_t,
             'p' = 1)
  
  #based on VBA_defaultPriors.m
  # iQy # not defining bc it is not an argument for VBA_random("Bernoulli")  
  iQx = vector("list", dim$n_t)
  iQx = lapply(iQx, function(x){diag(dim$n)})
  
  x   = zeros(dim$n, dim$n_t-1)
  eta = zeros(dim$n, dim$n_t)
  e   = zeros(dim$p, dim$n_t)
  y   = zeros(dim$p, dim$n_t)
  
  x = cbind(x0, x)
  
  for(t in 1:(dim$n_t-1)){
    Cx = solve(iQx[[t]]) / alp #not using alpha to avoid confusion with ggplot function
    eta[,t] =  MASS::mvrnorm(mu= zeros(dim$n), Sigma = Cx)
    # Evolution
    x[,t+1] = f_fun(x[,t], theta, u[,t])$fx + eta[,t]
    
    gt = g_fun(x[,t+1], phi)$gx
    
    y[,t] = rbinom(1, 1, gt) #flip coin with p that is output from the observation function
    
    e[,t] = y[,t] - gt
    
    u[1, t+1] = y[,t] #choices
    u[2, t+1] = fb(y[,t], t) #feedback
  }
  
  out = list('y'=y, 'x'=x, 'x0'=x0, 'eta'=eta, 'e'=e, 'u'=u)
  
  return(out)
}