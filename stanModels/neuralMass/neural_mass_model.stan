
functions {
  
  vector phi(){
    return out
  }
  
  vector dx_dt(real t,       // time
               vector x,     // system state {1 x N - network activity for each time point}
               int N,
               vector W,
               real s,
               real g,
               real beta, 
               real tau) {
  
    vector[N] dx_dt;
    
    for (i in 1:N){
      dx_dt[i] = -x[i] + s * phi(x[i])
    }
    
    
    return  dx_dt;
  }
}

data {
  int<lower = 0> N_TS;           // number of measurement times
  int<lower = 0> N;             // number of nodes
  real ts[N_TS];                 // measurement times > 0
  vector[N] y_init;             // initial measured activity level
  vector<lower = 0>[N] y[N_TS];    // measured activity level with nodes in cols and timepoints in rows
  vector[N] W_mat[N]; // adjacency matrix
}

parameters {
  real<lower = 0> s;   // self coupling
  real<lower = 0> g;  // global coupling
  real<lower = 0> beta;  // task modulation
  real<lower = 0> tau; // sampling rate (?)
  vector[N] x_init;  // initial activity level
  real<lower = 0> sigma;   // measurement error
}

transformed parameters {
  vector[N] z[N_TS] = ode_rk45(dx_dt, x_init, 0, ts, N, s, g, beta, tau);
}

model {
  s ~ ...;
  g ~ ...;
  beta ~ ...;
  tau ~ ...;
  sigma ~ lognormal(-1, 1);
  z_init ~ ...;
  
  
  for (k in 1:N) {
    y_init[k] ~ lognormal(log(z_init[k]), sigma);
    y[ , k] ~ lognormal(log(z[, k]), sigma[k]);
  }
}
// 
// generated quantities {
//   vector[2] y_init_rep;
//   vector[2] y_rep[N];
//   for (k in 1:2) {
//     y_init_rep[k] = lognormal_rng(log(z_init[k]), sigma[k]);
//     for (n in 1:N)
//       y_rep[n, k] = lognormal_rng(log(z[n, k]), sigma[k]);
//   }
// }
// 
