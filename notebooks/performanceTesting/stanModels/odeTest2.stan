
functions{
  vector da_dt(real t,
  vector a_t, 
  real ke) {
    
    vector[1] dadt;
    dadt = -ke * a_t;
    return dadt;
  }
}

data {
  int N;
  real ts[N];
  vector[1] a[N];
}

parameters {
  vector[1] a0;
  real<lower=0,upper=1> ke;
  real<lower=1E-10> sigma;
}

model {
  vector[1] a_mu[N] = ode_rk45(da_dt, a0, 0, ts, ke);
  
  for(n in 1:N){
    a[n] ~ normal(a_mu[n], sigma); 
  }
  
  a0 ~ normal(15, 5);
  ke ~ beta(1, 1);
  sigma ~ lognormal(-1,1);
}

generated quantities{
  
  vector[1] a_mu_gen[N] = ode_rk45(da_dt, a0, 0, ts, ke);
  vector[1] a_gen[N];
  
  for(n in 1:N){
    a_gen[n, 1] = normal_rng(a_mu_gen[n, 1], sigma); 
  }
}