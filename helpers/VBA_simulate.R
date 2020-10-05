VBA_simulate = function(n_t,f_fname,g_fname,theta,phi,u,alpha,sigma,options,x0,fb){
  
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
  
  out = list('y'=y, 'x'=x, 'x0'=x0, 'eta'=eta, 'e'=e, 'u'=u)
  
  return(out)
}