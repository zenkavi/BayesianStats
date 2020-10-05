source('f_Qlearning.R')
source('g_Qlearning.R')

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
  
  sim_out = VBA_simulate(n_t+1,
                          ...., #after writing this function see if you should use string or get(string) to use the function itself as the input
                          ....,
                          )
  
  simulation = list('state' = x[,-ncol(x)], #x(:,1:end-1)
                    'initial'= x0,
                    'evolution' = theta,
                    'observation' = phi)
  
  choices = sim_out$u[...]
  feedback = sim_out$u[...]
  
  out = list('choices' = choices, 'feedback'= feedback, 'simulation' = simulation)
  
  return(out)
}
