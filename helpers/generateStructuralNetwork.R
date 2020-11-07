generateStructuralNetwork = function(args_dict){
  # """
  #   Randomly generates a structural network with a single hub network
  # 
  #   Parameters:
  #       ncommunities = number of communities within the network (one will automatically be a hub-network
  #       innetwork_dsity = connectivity density of within-network connections
  #       outnetwork_dsity = connectivity density of out-of-network connections
  #       hubnetwork_dsity = out-of-network connectivity density for the hub-network
  #       showplot = if set to True, will automatically display the structural matrix using matplotlib.pyplot
  # 
  #   Returns: 
  #       Unweighted structural connectivity matrix (with 1s indicating edges and 0s otherwise)
  #   """
  
  # Initialize parameters
  ncommunities=args_dict$ncommunities
  innetwork_dsity=args_dict$innetwork_dsity
  outnetwork_dsity=args_dict$outnetwork_dsity
  hubnetwork_dsity=args_dict$hubnetwork_dsity
  nodespercommunity=args_dict$nodespercommunity
  showplot=args_dict$showplot
  
  totalnodes = nodespercommunity * ncommunities
  
  W = matrix(0, nrow=totalnodes, ncol=totalnodes)
  # Construct structural matrix
  nodecount = 0
  for (i in range(ncommunities)){
    for (j in range(ncommunities)){
      for (node in range(nodespercommunity)){
        # Set within network community connections
        if (i==j){
          tmp_a = matrix(rnorm(nodespercommunity*nodespercommunity), nrow=nodespercommunity)<innetwork_dsity
          indstart = i*nodespercommunity
          indend = i*nodespercommunity+nodespercommunity
          W[indstart:indend,indstart:indend] = tmp_a
        } else{
          tmp_b = matrix(rnorm(nodespercommunity*nodespercommunity), nrow=nodespercommunity)<outnetwork_dsity
          indstart_i = i*nodespercommunity
          indend_i = i*nodespercommunity + nodespercommunity
          indstart_j = j*nodespercommunity
          indend_j = j*nodespercommunity + nodespercommunity
          W[indstart_i:indend_i, indstart_j:indend_j] = tmp_b
        }
      }
    }
  }
    
  
  # Redo a community as a hub-network
  hubnetwork = 0
  if (hubnetwork_dsity>0){
    for (i in range(ncommunities)){
      for (j in range(ncommunities)){
        if( (i==hubnetwork | j==hubnetwork) & i!=j){
          tmp_b = np.random.rand(nodespercommunity,nodespercommunity)<hubnetwork_dsity
          indstart_i = i*nodespercommunity
          indend_i = i*nodespercommunity + nodespercommunity
          indstart_j = j*nodespercommunity
          indend_j = j*nodespercommunity + nodespercommunity
          W[indstart_i:indend_i, indstart_j:indend_j] = tmp_b
        }
      }
    }
  } # Only do if we want a hub network
    
  
  # Make sure self-connections exist
  # np.fill_diagonal(W, 1)
  
  if (showplot){
    data.frame(W) %>%
      mutate(to = row.names(.),
             from = names(.),
             from = gsub("X","",from)) %>%
      gather(key, weight, -to, -from) %>%
      select(-key) %>%
      ggplot(aes(x=from, y=to, fill=weight))+
      geom_tile() 
  }
  
  return(W)
}


