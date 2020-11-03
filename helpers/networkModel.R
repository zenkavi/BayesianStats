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
  
  return(Enodes)
}