
functions {
  
  real phi(real a){
    real out = (exp(2*a)-1)/(exp(2*a)+1);
    return out;
  }
  
  vector dx_dt(real t,       // time
               vector x,     // system state {1 x N - network activity for each time point}
               int N,
               vector W,
               vector I,
               real s,
               real g,
               real b, 
               real tau) {
  
    vector[N] res;
    
    for (i in 1:N){
      res[i] = (-x[i] + s * phi(x[i]) + g * sum(W[i,] * x[i]) + b * I[t])/tau;
    }
    
    // returns change for one time point for all nodes
    return  res;
  }
}

data {
  int<lower = 0> N_TS;           // number of measurement times
  int<lower = 0> N;             // number of nodes
  real ts[N_TS];                 // measurement times > 0
  vector[N] y_init;             // initial measured activity level
  vector[N] y[N_TS];    // measured activity level with nodes in cols and timepoints in rows
  vector[N] W[N]; // adjacency matrix
  vector[N_TS] I; // task stimulation
}

parameters {
  real<lower = 0> s;   // self coupling
  real<lower = 0> g;  // global coupling
  real<lower = 0> b;  // task modulation
  real<lower = 0> tau; // time constant
  real<lower = 0> sigma;   // measurement error
}


// https://mc-stan.org/docs/2_25/stan-users-guide/measurement-error-models.html
// in section "Estimating System Parameters and Initial State" the solver is placed in the model section
transformed parameters {
  // states x are estimated as parameters z with some uncertainty. 
  // these estimated parameters are used in the model description to relate them to measured data
  vector[N] z[N_TS] = ode_rk45(dx_dt, y_init, 0, ts, N, W, I, s, g, b, tau);
}

model {
  s ~ lognormal(-1, 1);
  g ~ lognormal(-1, 1);
  beta ~ lognormal(-1, 1);
  tau ~ normal(1, 0.5);
  sigma ~ lognormal(-1, 1);

  
  for (k in 1:N) {
    // y_init[k] ~ lognormal(log(z_init[k]), sigma);
    y[ , k] ~ lognormal(log(z[, k]), sigma[k]);
  }
}
