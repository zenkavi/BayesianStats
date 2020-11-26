k_fold = function(aModel, testIndices, simData, dataVarNames, logLikVarName){
  
  numFolds = length(testIndices)
  
  #expected log pointwise predictive density
  elpd = 0
  
  for(i in 1:numFolds){
    cur_ind = testIndices[[i]]
    
    m_data = list(N_train = nrow(simData) - length(cur_ind), N_test = length(cur_ind))
    
    for (j in 1:length(dataVarNames)){
      m_data[[paste0(dataVarNames[j], '_train')]] = simData[-cur_ind, dataVarNames[j]]
      m_data[[paste0(dataVarNames[j], '_test')]] = simData[cur_ind, dataVarNames[j]]
    }
    
    fit = sampling(aModel, data=m_data, show_messages=FALSE, verbose=FALSE, refresh= 0)
    
    fold_llpd = extract_log_lik(fit, logLikVarName) #requires loo
    
    fold_llpd_means = colMeans(fold_llpd) #mean loglik for each left out train datapoint across samples
    #fold_elpd_increment = sum(fold_llpd_means) #sum of mean logliks of each train datapoint
    #elpd = elpd+fold_elpd_increment 
    elpd = c(elpd, fold_llpd_means)
  }
  
  return(elpd)
}