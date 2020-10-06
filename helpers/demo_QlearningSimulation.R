files.sources = list.files('/Users/zeynepenkavi/Dropbox/RangelLab/BayesianStats/helpers', full.names = T)
files.sources = files.sources[files.sources != '/Users/zeynepenkavi/Dropbox/RangelLab/BayesianStats/helpers/demo_QlearningSimulation.R']
sapply(files.sources, source)

demo_QlearningSimulation = function(){
  
  f_fname = 'f_Qlearning'
  g_fname = 'g_Qlearning'
  
  # probability of a positive reward following a 'correct' action 
  probRewardGood = 75/100;
  # draw 25 random feedbacks
  contBloc = runif(25) < probRewardGood
  # create 6 blocs with reversals
  contingencies = c(contBloc, 1-contBloc,contBloc, 1-contBloc, contBloc, 1-contBloc)
  
  h_feedback = function(yt, t){
    return(as.numeric(yt == contingencies[t]))
  }
  
  theta = VBA_sigmoid(.65, inverse=TRUE)

  phi = log(2.5)

  x0 = c(.5, .5)
  
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
  
  out = list('choices' = choices, 'feedback'= feedback, 'simulation' = simulation, 'eta'=sim_out$eta, 'e'=sim_out$e, 'y'=sim_out$y)
  
  return(out)
}
