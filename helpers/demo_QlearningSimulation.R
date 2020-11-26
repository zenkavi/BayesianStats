files.sources = list.files('/Users/zeynepenkavi/Dropbox/RangelLab/BayesianStats/helpers', full.names = T)
files.sources = files.sources[files.sources != '/Users/zeynepenkavi/Dropbox/RangelLab/BayesianStats/helpers/demo_QlearningSimulation.R']
sapply(files.sources, source)

make_QlearningTask = function(probRewardGood = .75, blocksize = 25, numBlocks = 6){
  
  # probability of a positive reward following a 'correct' action 
  probRewardGood = 75/100;
  # draw 25 random feedbacks
  contBloc = runif(blockSize) < probRewardGood
  # create 6 blocks with reversals
  contingencies = rep(c(contBloc, 1-contBloc), numBlocks/2)
  
  return(contingencies)
}

demo_QlearningSimulation = function(alpha=.65, beta=2.5, 
                                    blockSize = 25, numBlocks = 6,
                                    f_fname = 'f_Qlearning', g_fname = 'g_Qlearning'){
  
  contingencies = make_QlearningTask(probRewardGood = .75, blocksize = blocksize, numBlocks = numBlocks)
  
  h_feedback = function(yt, t){
    return(as.numeric(yt == contingencies[t]))
  }
  
  theta = c()
  for(i in 1:length(alpha)){
    theta[i] = VBA_sigmoid(alpha[i], inverse=TRUE) #will be transformed back in f_Qlearning
  }

  phi = log(beta) #will be transformed back in g-Qlearning

  x0 = c(.5, .5) #starting EVs
  
  n_t = length(contingencies)
  
  u = matrix(NaN, nrow=2, ncol=length(contingencies)-1)
  # instead of a 'skipf' option setting the initial input to the initial state
  u = cbind(x0, u)
  
  sim_out = VBA_simulate(n_t,
                         f_fname,
                         g_fname,
                         theta,
                         phi,
                         u,
                         Inf, Inf, #deterministic evolution and observation
                         x0,
                         h_feedback)
  
  simulation = list('state' = sim_out$x[,-ncol(sim_out$x)], #x(:,1:end-1)
                    'initial'= x0,
                    'evolution' = theta,
                    'observation' = phi)
  
  end = dim(u)[2]
  choices = sim_out$u[1,2:end]
  feedback = sim_out$u[2,2:end]
  
  out = list('choices' = choices, 'feedback'= feedback, 
             'simulation' = simulation, 'eta'=sim_out$eta, 
             'e'=sim_out$e, 'y'=sim_out$y)
  
  return(out)
}
