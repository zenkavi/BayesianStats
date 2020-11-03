phi = function(a){
  out = (exp(2*a)-1)/(exp(2*a)+1)
  return(out)
}

default_args_dict = list('bottomup'= FALSE, 
                 'dt'=.5,  
                 'ea'=200,
                 'g'=1, 
                 'hubnetwork_dsity'= .25,
                 'I'= NULL,
                 'innetwork_dsity'= .60,
                 'iv'= 400,
                 'local_com'= 1, 
                 'ncommunities'= 3,
                 'noise'= NULL,
                 'noise_loc'= 0, 
                 'noise_scale'= 0,
                 'nodespercommunity'= 35,
                 'outnetwork_dsity'=.08,
                 'plot_network'= FALSE,
                 'plot_task'= FALSE, 
                 's'=1,
                 'sa'=100,
                 'showplot'=FALSE,
                 'standardize'=FALSE,
                 'stim_mag'=.5,
                 'stimsize'= 3, 
                 'taskdata'=NULL,
                 'tasktiming'=NULL,
                 'tau'=1, 
                 'Tmax'=1000,
                 'topdown'=TRUE,
                 'W'= NULL)

networkModel = function(W, args_dict){
  
  Tmax=args_dict$Tmax
  dt=args_dict$dt
  g=args_dict$g
  s=args_dict$s
  tau=args_dict$tau
  I=args_dict$I
  noise=args_dict$noise
  noise_loc = args_dict$noise_loc
  noise_scale = args_dict$noise_scale
  
  TT = seq(0, Tmax, dt)
  totalnodes = dim(W)[1]
  
  # External input (or task-evoked input) && noise input
  if(is.null(I)){
    I = matrix(0, totalnodes, length(TT))
    } 
  
  # Noise parameter
  if (is.null(noise)){
    noise = matrix(0, totalnodes, length(TT))
  } else {
    noise = matrix(rnorm(totalnodes*length(TT), mean = noise_loc, sd = noise_scale), totalnodes, length(TT))
  }
  
  # Initial conditions and empty arrays
  Enodes = matrix(0, totalnodes, length(TT))
  # Initial conditions
  # AZE: changing initial conditions to 0 if there is a task simulation
  if (!is.null(I)){
    Einit = matrix(0, totalnodes, 1)
  } else {
    Enit  = matrix(rnorm(totalnodes), totalnodes, 1)
  }
  
  #Assign initial values to first time point of all nodes
  Enodes[,1] = Einit
  
  spont_act = matrix(0, totalnodes, 1)
  
  for (t in 1:(length(TT)-1)){
    ## Solve using Runge-Kutta Order 2 Method
    # With auto-correlation
    spont_act = noise[,t] + I[,t]
    k1e = -Enodes[,t] + g*(W %*% phi(spont_act)) # Coupling
    k1e = k1e + s*phi(Enodes[,t]) + spont_act# Local processing
    k1e = k1e/tau
    # 
    ave = Enodes[,t] + k1e*dt
    #
    # With auto-correlation
    spont_act = noise[,t+1] + I[,t+1]
    k2e = -ave + g*(W %*% phi(spont_act)) # Coupling
    k2e = k2e + s*phi(ave) + spont_act # Local processing
    k2e = k2e/tau
    
    Enodes[,t+1] = Enodes[,t] + (.5*(k1e+k2e))*dt
  }
  
  return(Enodes)
}