
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

parameters {
  real s;   // self coupling
  real g;  // global coupling
  real b;  // task modulation
  real<lower = 0> tau; // time constant
  real<lower = 0> sigma;
}

transformed parameters{
  g_N_t
  s_phi_x_t
  g_N_dt
  s_phi_ave
}

transformed data{
 x_t_dt 
 I_t_dt
}

//   x_t = all_nodes_ts$Enodes[node, -ncol(all_nodes_ts$Enodes)]
//   
//   g_N_t = all_nodes_ts$int_out$net_act1[node,]
//   
//   s_phi_x_t = s * phi(x_t)
//   
//   if(is.null(task_reg)){
  //     I_t = all_nodes_ts$int_out$spont_act1[node,]
  //     I_t_dt = all_nodes_ts$int_out$spont_act2[node,]
  //   } else {
    //     I_t = task_reg[-length(task_reg)]
    //     I_t_dt = task_reg[-1]
    //   }
    //   
    //   g_N_t_dt = all_nodes_ts$int_out$net_act2[node,]
    //   
    //   s_phi_ave = s * phi(((1 - (dt/tau))*x_t)+((dt/tau)*(g_N_t+s_phi_x_t+I_t)))
    //   
    //   mod = lm(x_t_dt ~ -1 +x_t + g_N_t + s_phi_x_t + I_t + g_N_t_dt + s_phi_ave + I_t_dt)
    
    model {
      for (node in 1:N){
        for (t in 2:N_TS){
          
          x_t_dt[node, t] ~ normal(..., sigma);
        }
      }
    }
    