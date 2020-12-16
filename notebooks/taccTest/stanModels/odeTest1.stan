

data {
  int T; //nrow states-1
  vector[2] state0; // initial state
  vector[2] states[T]; //states[1] = x(t); states[2] = y(t)
  real ts[T]; // time points
  real t0; // first time point 0
  vector[T] diffx;
}

parameters {
  real sigma;
  real theta;
}

model {
  for (i in 1:T){
    states[i, 2] ~ normal(states[i,1] - 1 + theta*exp(-states[i, 1]), sigma); 
  }
  sigma ~ lognormal(-1, 1);
  theta ~ normal(3, 5);
}

generated quantities{
  vector[T] states_rep;
  
  for (i in 1:T){
    states_rep[i] = normal_rng(states[i,1] - 1 + theta*exp(-states[i, 1]), sigma);
  }
}
