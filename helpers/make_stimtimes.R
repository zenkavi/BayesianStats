make_stimtimes = function(stim_nodes, args_dict){
  
  # """
  #   Creates task timing and timeseries for all nodes in network
  #   Parameters:
  #       Tmax = task length
  #       dt = sampling rate
  #       stim_nodes = nodes that are stimulated by the task
  #       tasktiming = block task array is created if not specified. If specified must be of length Tmax/dt
  #       ncommunities = number of communities in network
  #       nodespercommunity = number of nodes per community in network
  #       sa = start point of stimulation
  #       ea = end point of stimulation
  #       iv = interstim interval
  #   Returns: 
  #       2D array with nodes in rows and time points in columns
  #   """
  
  # Initialize parameters
  Tmax=args_dict$Tmax
  dt=args_dict$dt
  stim_mag=args_dict$stim_mag
  tasktiming=args_dict$tasktiming
  ncommunities = args_dict$ncommunities
  nodespercommunity = args_dict$nodespercommunity
  sa = args_dict$sa
  ea = args_dict$ea
  iv = args_dict$iv
  
  totalnodes = nodespercommunity*ncommunities
  TT = seq(0,Tmax,dt)
  
  # Construct timing array for convolution 
  # This timing is irrespective of the task being performed
  # Tasks are only determined by which nodes are stimulated
  if (is.null(tasktiming)){    
    tasktiming = rep(0, length(TT))
    for (t in 1:(length(TT))){
      if (t%%iv>sa & t%%iv<ea){
        tasktiming[t] = 1.0
      }
    }
  }
  
  stimtimes = matrix(0, totalnodes, length(TT))
  
  # When task is ON the activity for a stim_node at that time point changes the size of stim_mag
  for (t in 1:length(TT)){
    if (tasktiming[t] == 1){
      stimtimes[stim_nodes,t] = stim_mag
    }
  }
  
  return(list(tasktiming = tasktiming, stimtimes = stimtimes))
}
