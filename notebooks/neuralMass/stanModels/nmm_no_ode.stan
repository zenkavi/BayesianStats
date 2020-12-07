
functions {
  real phi(real a){
    real out = (exp(2*a)-1)/(exp(2*a)+1);
    return out;
  }
}

data {
  int<lower = 0> N_TS; // number of measurement times
  int<lower = 0> N; // number of nodes
  vector[N] x_t[N_TS]; // measured time series for all nodes
  vector[N] W[N]; // adjacency matrix
  vector[N_TS] I_t; // task stimulation
}

transformed data{
  vector[N] x_t_dt[N_TS-1];
  vector[N_TS-1] I_t_dt;
  
  x_t_dt = x_t[,2:]; 
  I_t_dt = I_t[2:];
}

parameters {
  real s;   // self coupling
  real g;  // global coupling
  real b;  // task modulation
  real<lower = 0> tau; // time constant
  real<lower = 0> sigma;
}

transformed parameters{
  
  vector[N] g_N_t[N_TS-1];
  vector[N] s_phi_x_t[N_TS-1];
  vector[N] g_N_dt[N_TS-2];
  vector[N] s_phi_ave[N_TS-2];
  
  for (node in 1:N){
    for (t in 2:N_TS){
      g_N_t[node, t] = g * sum(W[node,] * x_t[,t]);
      s_phi_x_t[node, t] = ;
      g_N_dt[node, t] = ;
      s_phi_ave[node, t] = ;
      
      pred_x_t_dt = 
    }
  }
}

model {
  for (node in 1:N){
    for (t in 2:N_TS){
      
      x_t_dt[node, t] ~ normal(..., sigma);
    }
  }
}
