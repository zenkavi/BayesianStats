
functions {
  vector dz_dt(real t,       // time
               vector z,     // system state {prey, predator}
               real alpha,
               real beta,
               real gamma,
               real delta) {
    
    real u = z[1];
    real v = z[2];

    real du_dt = (alpha - beta * v) * u;
    real dv_dt = (-gamma + delta * u) * v;
    
    vector[2] res;
    res[1] = du_dt;
    res[2] = dv_dt;
    return  res;
  }
}

data {
  int<lower = 0> N;           // number of measurement times
  real ts[N];                 // measurement times > 0
  vector[2] y_init;             // initial measured populations
  vector<lower = 0>[2] y[N];    // measured populations
}

parameters {
  real<lower = 0> alpha;   // { alpha, beta, gamma, delta }
  real<lower = 0> beta;
  real<lower = 0> gamma;
  real<lower = 0> delta;
  vector[2] z_init;  // initial population
  real<lower = 0> sigma[2];   // measurement errors
}

transformed parameters {
  vector[2] z[N] = ode_rk45(dz_dt, z_init, 0, ts, alpha, beta, gamma, delta);
}

model {
  alpha ~ normal(1, 0.5);
  gamma ~ normal(1, 0.5);
  beta ~ normal(0.05, 0.05);
  delta ~ normal(0.05, 0.05);
  sigma ~ lognormal(-1, 1);
  z_init ~ lognormal(log(10), 1);
  
  
  for (k in 1:2) {
    y_init[k] ~ lognormal(log(z_init[k]), sigma[k]);
    y[ , k] ~ lognormal(log(z[, k]), sigma[k]);
  }
}

generated quantities {
  vector[2] y_init_rep;
  vector[2] y_rep[N];
  
  for (k in 1:2) {
    y_init_rep[k] = lognormal_rng(log(z_init[k]), sigma[k]);
    for (n in 1:N)
      y_rep[n, k] = lognormal_rng(log(z[n, k]), sigma[k]);
  }
}

