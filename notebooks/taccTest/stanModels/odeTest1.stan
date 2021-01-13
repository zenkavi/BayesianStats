

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
  vector[1] a_mu[N];
  
  for(n in 1:N){
    a_mu[n] = a0 * exp(-ke*ts[n]);
    a[n] ~ normal(a_mu[n], sigma); 
  }
  
  a0 ~ normal(15, 5);
  ke ~ beta(1, 1);
  sigma ~ lognormal(-1,1);
}

generated quantities{
  vector[1] a_mu_gen[N];
  vector[1] a_gen[N];
  
  for(n in 1:N){
    a_mu_gen[n] = a0 * exp(-ke*ts[n]);
    a_gen[n, 1] = normal_rng(a_mu_gen[n, 1], sigma); 
  }
}
